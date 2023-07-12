load("//meta:defs.bzl", "with_cfg")

cc_asan_binary, _cc_asan_binary = with_cfg.rule(
    native.cc_binary,
).extend(
    "copt",
    select({"//conditions:default": ["-DNAME=\"with_cfg\""]}),
).build()
