def _noop():
    pass

_FUNC_TYPE = type(_noop)

def _is_func(x):
    ret

def with_config(
        rule_or_macro,
        *,
        values = {},
        flag_values = {},
        executable = None,
        test = None,
        additional_providers = [],
        target_suffixes = []):
    """"""
    config_transition = _make_transition(
        values = values,
        flag_values = flag_values,
    )

    if executable == None and test == None:
        executable = False
        test = False
        if func_name.endswith("_test>"):
            test = True
        elif func_name.endswith("_binary>"):
            executable = True

    forwarding_rule = make_forwarding_rule(
        config_transition = config_transition,
        executable = executable,
        test = test,
        additional_providers = additional_providers,
    )

    macro = make_macro(
        forwarding_rule = forwarding_rule,
        target_suffixes = target_suffixes,
    )

    return macro, forwarding_rule

def _make_transition(
        *,
        values = {},
        flag_values = {}):
    def transition_impl(settings, attrs):
        for key, value in values.items():
            settings[key] = value
        for key, value in flag_values.items():
            attrs[key] = value
        return settings, attrs
