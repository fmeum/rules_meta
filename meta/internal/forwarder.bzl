load(":setting.bzl", "get_attr_name", "get_attr_type")

visibility("private")

def make_forwarder_rule(*, providers, transition, values):
    settings_attrs = {
        get_attr_name(settings): getattr(attr, get_attr_type(value))
        for setting, value in values.items()
    }
    return rule(
        make_forwarder_impl(providers = providers),
        attrs = settings_attrs | {
            "exports": attr.label(mandatory = True),
        },
        transitions = transition,
    )

def make_forwarder_impl(*, providers):
    return lambda ctx: _forwarder_base_impl(ctx, providers = providers)

def _forwarder_base_impl(ctx, *, providers):
    target = ctx.attr.exports
    return [
        target[DefaultInfo],
    ] + [
        target[provider]
        for provider in providers
        if provider in target
    ]
