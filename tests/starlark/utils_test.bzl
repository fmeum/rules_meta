load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//meta/internal:utils.bzl", "value_from_select")

def _select_type_test_impl(ctx):
    env = unittest.begin(ctx)
    asserts.equals(env, value_from_select(select({"//conditions:default": "foo\"bar"})), type(""))
    asserts.equals(env, value_from_select(select({"bar": ""})), type(""))
    asserts.equals(env, value_from_select(select({Label("@foo//:bar"): ""})), type(""))

    asserts.equals(env, value_from_select(select({"//conditions:default": []})), type([]))
    asserts.equals(env, value_from_select(select({"bar": []})), type([]))
    asserts.equals(env, value_from_select(select({Label("@foo//:bar"): []})), type([]))

    asserts.equals(env, value_from_select(["foo"] + select({"//conditions:default": ["bar"]})), type([]))
    asserts.equals(env, value_from_select(["foo"] + select({"bar": ["bar"]})), type([]))
    asserts.equals(env, value_from_select(["foo"] + select({Label("@foo//:bar"): []})), type([]))

    asserts.equals(env, value_from_select(select({"//conditions:default": {}})), type({}))
    asserts.equals(env, value_from_select(select({"bar": {}})), type({}))
    asserts.equals(env, value_from_select(select({Label("@foo//:bar"): {}})), type({}))

    asserts.equals(env, value_from_select({"foo": "bar"} | select({"//conditions:default": {}})), type({}))
    asserts.equals(env, value_from_select({"foo": "bar"} | select({"bar": {}})), type({}))
    asserts.equals(env, value_from_select({"foo": "bar"} | select({Label("@foo//:bar"): {}})), type({}))

    asserts.equals(env, value_from_select(select({"//conditions:default": 1})), type(1))
    asserts.equals(env, value_from_select(select({"bar": -2})), type(-2))
    asserts.equals(env, value_from_select(select({Label("@foo//:bar"): 3})), type(3))
    return unittest.end(env)

_select_type_test = unittest.make(_select_type_test_impl)

def utils_test_suite(name):
    unittest.suite(
        name,
        _select_type_test,
    )
