load("//meta:defs.bzl", "with_cfg")

my_sh_test, _my_sh_test_ = with_cfg.rule(
    native.sh_test,
).build()
