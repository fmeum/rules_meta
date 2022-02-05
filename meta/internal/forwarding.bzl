load(":utils.bzl", "NATIVE_PROVIDERS")

def transition_and_forward_providers_factory(
        transition,
        attrs = {},
        executable = False,
        test = False,
        extra_providers = []):
    rule_attrs = dict(attrs)
    rule_attrs.update({
        "env": attr.string_dict(),
        # This attribute name is internal only, so it can only help to choose a
        # name that is treated as a dependency attribute by the IntelliJ plugin:
        # https://github.com/bazelbuild/intellij/blob/11acaac819346f74e930c47594f37d81e274efb1/aspect/intellij_info_impl.bzl#L29
        "exports": attr.label(
            cfg = transition,
            executable = executable,
        ),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
    })

    # This is allowed to collide.
    rule_name = "apply_transition"
    if test:
        rule_name += "_test"
    return rule(
        name = rule_name,
        implementation = _transition_and_forward_providers_impl_factory(extra_providers),
        attrs = rule_attrs,
        executable = executable,
        test = test,
    )

def _transition_and_forward_providers_impl_factory(extra_providers = []):
    def _transition_and_forward_providers_impl(ctx):
        target = ctx.attr.exports[0]
        providers = [target[p] for p in NATIVE_PROVIDERS + extra_providers if p in target]

        default_info = target[DefaultInfo]
        original_executable = default_info.files_to_run.executable
        if original_executable == None:
            providers.append(target[DefaultInfo])
        else:
            # We cannot forward the target's DefaultInfo since Bazel expects an
            # executable to be created by the rule that returned it in its
            # DefaultInfo. To emulate this, symlink the original executable.
            new_executable_path = "{name}_/{basename}".format(
                name = ctx.attr.name,
                basename = original_executable.basename,
            )
            new_executable = ctx.actions.declare_file(new_executable_path)
            ctx.actions.symlink(
                output = new_executable,
                target_file = original_executable,
                is_executable = True,
            )
            runfiles = ctx.runfiles()
            runfiles = runfiles.merge(default_info.default_runfiles)
            runfiles = runfiles.merge(default_info.data_runfiles)
            providers.append(
                DefaultInfo(
                    files = default_info.files,
                    runfiles = runfiles,
                    executable = new_executable,
                ),
            )

        if ctx.attr.env:
            expanded_env = {
                key: ctx.expand_make_variables("env", value, {})
                for key, value in ctx.attr.env.items()
            }
            providers.append(testing.TestEnvironment(expanded_env))

        return providers

    return _transition_and_forward_providers_impl
