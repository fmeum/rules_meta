load(":rule_defaults.bzl", "DEFAULT_PROVIDERS")

visibility("private")

def get_frontend(*, executable, test):
    if test:
        frontend = _frontend_test
    elif executable:
        frontend = _frontend_executable
    else:
        frontend = _frontend_default

def _frontend_impl(ctx):
    target = ctx.attr.exports
    return [
        target[DefaultInfo],
    ] + [
        target[provider]
        for provider in providers
        if provider in target
    ]

_frontend_attrs = {
    "exports": attr.label(
        mandatory = True,
    ),
}
_frontend_executable = rule(_frontend_impl, attrs = _frontend_attrs, executable = True)
_frontend_test = rule(_frontend_impl, attrs = _frontend_attrs, test = True)

def _frontend_default(*, name, target, attrs):
    alias(
        name = name,
        actual = target,
        **attrs
    )
