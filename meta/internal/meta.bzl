load(":forwarding.bzl", "transition_and_forward_providers_factory")
load(":utils.bzl", "attr_from_value", "is_dict", "is_list", "is_select", "is_struct", "REPLACE_ONLY_LIST_COMMAND_LINE_OPTIONS")

def _wrap_with_transition(
        original_rule,
        settings,
        executable = False,
        test = False,
        extra_providers = []):
    """Creates a new rule that behaves like an existing rule but also modifies build settings.

    Args:
        original_rule: The existing rule to wrap (e.g., native.cc_binary).
        settings: A dictionary of settings changes to apply.
        executable: Whether the new rule should be executable (default: False).
        test: Whether the new rule should be a test rule (default: False).
        extra_providers: Additional providers that the wrapping rule should forward from the original rule.

    Returns:
        A new rule that behaves like the original rule after applying the provided changes to the build settings.
    """
    is_native_rule = str(original_rule).startswith("<built-in rule ")
    native_rule_name = None
    if is_native_rule:
        native_rule_name = str(original_rule)[len("<built-in rule "):-1]

    raw_value_settings = {}
    attr_settings = {}
    attr_counter = 0
    settings_mode = {}
    for setting, value in settings.items():
        full_setting = _maybe_add_command_line_option_prefix(setting)
        if is_struct(value):
            if not hasattr(value, "mode") or not hasattr(value, "value"):
                fail("Value for setting '%s' cannot be a struct" % setting)
            settings_mode[full_setting] = value.mode
            value = value.value
        else:
            settings_mode[full_setting] = _autodetect_mode(full_setting)
        if is_dict(value):
            attr_settings[full_setting] = struct(
                name = "attr_%d" % attr_counter,
                type = attr_from_value(value),
                value = select(value),
            )
            attr_counter += 1
        elif is_select(value):
            fail("Instead of select({...}), use {...} as the value of setting '%s'." % setting)
        else:
            raw_value_settings[full_setting] = value

    all_settings = raw_value_settings.keys() + attr_settings.keys()

    def _transition_impl(input_settings, attrs):
        updated_settings = {}
        for setting in all_settings:
            if setting in raw_value_settings:
                new_value = raw_value_settings[setting]
            else:
                new_value = getattr(attrs, attr_settings[setting].name)
            # Some setting types do not allow reading from Starlark, so we have to wrap them in a lambda to defer
            # evaluation until we know it's safe. Otherwise, we get Bazel server crashes such as:
            # java.lang.IllegalArgumentException: cannot expose internal type to Starlark: class com.google.devtools.build.lib.rules.cpp.CppConfiguration$DynamicMode
            updated_settings[setting] = _get_updated_value(settings_mode[setting], lambda: input_settings[setting], new_value)
        return updated_settings

    _transition = transition(
        implementation = _transition_impl,
        inputs = all_settings,
        outputs = all_settings,
    )

    _apply_transition_rule = transition_and_forward_providers_factory(
        _transition,
        attrs = {
            attr.name: attr.type
            for attr in attr_settings.values()
        },
        executable = executable,
        test = test,
        extra_providers = extra_providers,
    )

    def _wrapper_macro(name, visibility = None, tags = None, testonly = None, **kwargs):
        # Use a subdirectory to preserve the basename but still prevent a name
        # collision with the transition rule.
        orig_name = "{name}/{name}".format(name = name)

        internal_rule_tags = list(tags or [])
        if "manual" not in internal_rule_tags:
            internal_rule_tags.append("manual")

        # Native test rules offer an env attribute that has to be moved to the wrapper.
        wrapper_env = kwargs.pop("env", default = None) if is_native_rule else None
        wrapper_env_inherit = kwargs.pop("env_inherit", default = None) if is_native_rule else None
        # All executable rules offer an args attribute that has to be moved to the wrapper.
        wrapper_args = kwargs.pop("args", default = None) if (executable or test) else None
        original_rule(
            name = orig_name,
            tags = internal_rule_tags,
            testonly = testonly,
            visibility = ["//visibility:private"],
            **kwargs
        )

        _apply_transition_rule(
            name = name,
            args = wrapper_args,
            env = wrapper_env,
            env_inherit = wrapper_env_inherit,
            exports = ":" + orig_name,
            tags = tags,
            testonly = testonly,
            visibility = visibility,
            **{
                attr.name: attr.value
                for attr in attr_settings.values()
            }
        )

    return _wrapper_macro

def _append(value):
    return struct(
        value = value,
        mode = _MODE_APPEND,
    )

def _replace_with(value):
    return struct(
        value = value,
        mode = _MODE_REPLACE,
    )

meta = struct(
    append = _append,
    replace_with = _replace_with,
    wrap_with_transition = _wrap_with_transition,
)

_MODE_APPEND = "rules_meta_append"
_MODE_REPLACE = "rules_meta_replace"

def _get_updated_value(mode, current_value, new_value):
    if not is_list(new_value) or mode == _MODE_REPLACE:
        return new_value
    return current_value() + new_value

_COMMAND_LINE_OPTION_PREFIX = "//command_line_option:"

def _maybe_add_command_line_option_prefix(setting):
    if not setting or not setting[0].isalpha():
        return setting
    else:
        return _COMMAND_LINE_OPTION_PREFIX + setting

def _autodetect_mode(setting):
    if not setting.startswith(_COMMAND_LINE_OPTION_PREFIX):
        return _MODE_APPEND
    option = setting[len(_COMMAND_LINE_OPTION_PREFIX):]
    if option in REPLACE_ONLY_LIST_COMMAND_LINE_OPTIONS:
        fail("""In most cases, the value of the command-line option '--%s' should be fully replaced, not appended to as is the default for meta.wrap_with_transition.
You probably want to wrap the value with meta.replace_with(...). If you really want the default behavior, wrap the value with meta.append(...).""" % option)
