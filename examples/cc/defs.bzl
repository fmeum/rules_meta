load("//meta:defs.bzl", "with_cfg")

cc_define_test, _cc_define_test_ = with_cfg(native.cc_test).extend(
    "copt",
    select({"//conditions:default": ["-DNAME=\"with_cfg\""]}),
).build()
