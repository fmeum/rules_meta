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

    original_executable = target[FrontendInfo].executable
    dirname, separator, _ = ctx.label.name.rpartition("/")
    basename = original_executable.basename
    executable = ctx.actions.declare_file(dirname + separator + basename)

    # TODO: If this is a copy rather than a symlink, runfiles discovery will not work correctly.
    #       Fix this by using a wrapper script rather than a symlink.
    ctx.actions.symlink(output = executable, target_file = original_executable)
    data_runfiles = ctx.runfiles([executable]).merge(target[DefaultInfo].data_runfiles)
    default_runfiles = ctx.runfiles([executable]).merge(target[DefaultInfo].default_runfiles)

    run_environment_info = target[FrontendInfo].run_environment_info
    return [
        DefaultInfo(
            executable = executable,
            files = target[DefaultInfo].files,
            data_runfiles = data_runfiles,
            default_runfiles = default_runfiles,
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
