load("//meta/internal:meta.bzl", _meta = "meta")
load("//meta/internal:rule.bzl", "rule")

meta = _meta

with_cfg = struct(
    rule = rule,
)
