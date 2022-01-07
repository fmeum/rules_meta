load("//meta:defs.bzl", "wrap_with_transition")

cc_17_library = wrap_with_transition(
    native.cc_library,
    {
        "cxxopt": {
            "@platforms//os:windows": ["/std:c++17"],
            "//conditions:default": ["--std=c++17"],
        },
    },
)

cc_opt_binary = wrap_with_transition(
    native.cc_binary,
    {
        "compilation_mode": "opt",
    },
    executable = True,
)

cc_dbg_test = wrap_with_transition(
    native.cc_test,
    {
        "compilation_mode": "dbg",
        # Workaround for https://github.com/bazelbuild/bazel/issues/13819.
        "dynamic_mode": "off",
    },
    test = True,
)
