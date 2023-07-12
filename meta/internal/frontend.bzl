load(":common.bzl", "FrontendInfo")

visibility("private")

def get_frontend(*, executable, test):
    if test:
        return _frontend_test
    elif executable:
        return _frontend_executable
    else:
        return _frontend_default

def _frontend_impl(ctx):
    target = ctx.attr.exports
    run_environment_info = target[FrontendInfo].run_environment_info
    return [
        DefaultInfo(
            files = target[DefaultInfo].files,
            data_runfiles = target[DefaultInfo].files,
            default_runfiles = target[DefaultInfo].default_runfiles,
        ),
    ] + [
        target[provider]
        for provider in target[FrontendInfo].providers
        if provider in target
    ] + (
        [run_environment_info] if run_environment_info else []
    )

_frontend_attrs = {
    "exports": attr.label(
        mandatory = True,
        providers = [FrontendInfo],
    ),
}

_frontend_executable = rule(_frontend_impl, attrs = _frontend_attrs, executable = True)
_frontend_test = rule(_frontend_impl, attrs = _frontend_attrs, test = True)

def _frontend_default(*, name, exports, **kwargs):
    native.alias(
        name = name,
        actual = exports,
        **kwargs
    )
