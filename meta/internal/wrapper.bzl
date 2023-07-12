load(":setting.bzl", "validate_and_get_attr_name")

visibility("private")

def make_wrapper(*, rule_info, frontend, transitioning_alias, values):
    return lambda *, name, **kwargs: _wrapper(
        name = name,
        kwargs = kwargs,
        kind = rule_info.kind,
        frontend = frontend,
        transitioning_alias = transitioning_alias,
        values = values,
    )

def _wrapper(*, name, kwargs, kind, frontend, transitioning_alias, values):
    original_name = name + "_"
    alias_name = name + "_alias"

    kind(
        name = original_name,
        tags = ["manual"],
        visibility = ["//visibility:private"],
        **kwargs
    )

    value_attrs = {
        validate_and_get_attr_name(setting): value
        for setting, value in values.items()
    }

    transitioning_alias(
        name = alias_name,
        exports = ":" + original_name,
        tags = ["manual"],
        visibility = ["//visibility:private"],
        **value_attrs
    )

    frontend(
        name = name,
        exports = ":" + alias_name,
    )
