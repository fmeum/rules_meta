load("//meta:defs.bzl", "with_cfg")

cc_asan_binary, _cc_asan_binary = with_cfg.rule(
    native.cc_binary,
    executable = False,
).extend(
    "copt",
    ["-DNAME=\"with_cfg\""],
).build()
