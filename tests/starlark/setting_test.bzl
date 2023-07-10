load("@rules_testing//lib:test_suite.bzl", "test_suite")
load("@rules_testing//lib:unit_test.bzl", "unit_test")
load("//meta/internal:setting.bzl", "get_attr_name", "get_attr_type")

def _get_attr_type_test(env):
    def make_subject(expr):
        return env.expect.where(expression = str(expr)).that_str(get_attr_type(expr))

    make_subject(select({"//conditions:default": "foo\"bar"})).equals("string")
    make_subject(select({"//conditions:default": ["foo\"bar"]})).equals("string_list")

#    asserts.equals(env, value_from_select(select({"bar": ""})), type(""))
#    asserts.equals(env, value_from_select(select({Label("@foo//:bar"): ""})), type(""))

#    asserts.equals(env, value_from_select(select({"//conditions:default": []})), type([]))
#    asserts.equals(env, value_from_select(select({"bar": []})), type([]))
#    asserts.equals(env, value_from_select(select({Label("@foo//:bar"): []})), type([]))
#
#    asserts.equals(env, value_from_select(["foo"] + select({"//conditions:default": ["bar"]})), type([]))
#    asserts.equals(env, value_from_select(["foo"] + select({"bar": ["bar"]})), type([]))
#    asserts.equals(env, value_from_select(["foo"] + select({Label("@foo//:bar"): []})), type([]))
#
#    asserts.equals(env, value_from_select(select({"//conditions:default": {}})), type({}))
#    asserts.equals(env, value_from_select(select({"bar": {}})), type({}))
#    asserts.equals(env, value_from_select(select({Label("@foo//:bar"): {}})), type({}))
#
#    asserts.equals(env, value_from_select({"foo": "bar"} | select({"//conditions:default": {}})), type({}))
#    asserts.equals(env, value_from_select({"foo": "bar"} | select({"bar": {}})), type({}))
#    asserts.equals(env, value_from_select({"foo": "bar"} | select({Label("@foo//:bar"): {}})), type({}))
#
#    asserts.equals(env, value_from_select(select({"//conditions:default": 1})), type(1))
#    asserts.equals(env, value_from_select(select({"bar": -2})), type(-2))
#    asserts.equals(env, value_from_select(select({Label("@foo//:bar"): 3})), type(3))
#    return unittest.end(env)

def _get_attr_name_test(env):
    env.expect.that_str(get_attr_name("platforms")).equals("platforms")

    some_setting_subject = env.expect.that_str(get_attr_name(Label("@bazel_tools//:some_setting")))
    some_setting_subject.contains("some_setting")
    some_setting_subject.not_equals(get_attr_name(Label("@bazel_tools//pkg:some_setting")))

def setting_test_suite(name):
    test_suite(
        name = name,
        basic_tests = [
            _get_attr_name_test,
            _get_attr_type_test,
        ],
    )
