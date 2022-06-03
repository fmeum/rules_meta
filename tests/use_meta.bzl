load("//meta:defs.bzl", "meta")

cc_17_library = meta.wrap_with_transition(
    native.cc_library,
    {
        "cxxopt": {
            "@platforms//os:windows": ["/std:c++17"],
            "//conditions:default": ["--std=c++17"],
        },
    },
)

cc_opt_binary = meta.wrap_with_transition(
    native.cc_binary,
    {
        "compilation_mode": "opt",
    },
    executable = True,
)

cc_dbg_test = meta.wrap_with_transition(
    native.cc_test,
    {
        "compilation_mode": "dbg",
    },
    test = True,
)

cc_host_binary = meta.wrap_with_transition(
    native.cc_binary,
    {
        "platforms": meta.replace_with(["@local_config_platform//:host"]),
    },
    executable = True,
)
