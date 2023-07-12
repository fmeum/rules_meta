load(":setting.bzl", "validate_and_get_attr_name")

visibility("private")

def make_wrapper(*, rule_info, frontend, transitioning_alias, values):
    return lambda *, name, **kwargs: _wrapper(
        name = name,
        kwargs = kwargs,
        rule_info = rule_info,
        frontend = frontend,
        transitioning_alias = transitioning_alias,
        values = values,
    )

def _wrapper(*, name, kwargs, rule_info, frontend, transitioning_alias, values):
    visibility = kwargs.pop("visibility", None)
    tags = kwargs.pop("tags", None)
    if not tags:
        tags_with_manual = ["manual"]
    elif "manual" not in tags:
        tags_with_manual = tags + ["manual"]
    else:
        tags_with_manual = tags

    dirname, separator, basename = name.rpartition("/")
    original_name = "{dirname}{separator}{basename}_/{basename}".format(
        dirname = dirname,
        separator = separator,
        basename = basename,
    )
    alias_name = name + "_with_cfg"

    rule_info.kind(
        name = original_name,
        tags = tags_with_manual,
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
        tags = tags_with_manual,
        visibility = ["//visibility:private"],
        **value_attrs
    )

    frontend(
        name = name,
        exports = ":" + alias_name,
        tags = tags,
        visibility = visibility,
    )

    for implicit_target in rule_info.implicit_targets:
        transitioning_alias(
            name = name + implicit_target,
            exports = ":" + original_name + implicit_target,
            tags = tags_with_manual,
            visibility = visibility,
            **value_attrs
        )
