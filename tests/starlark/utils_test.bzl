load("@rules_testing//lib:test_suite.bzl", "test_suite")
load("@rules_testing//lib:unit_test.bzl", "unit_test")
load("//meta/internal:utils.bzl", "get_attr_type")
load("//meta/internal:rule.bzl", "get_rule_name", "is_executable", "is_test")

def _get_attr_type_test(env):
    env.expect.that_str(get_attr_type(select({"//conditions:default": "foo\"bar"}))).equals(type(""))

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

def _noop_impl(ctx):
    pass

my_binary = rule(_noop_impl, executable = True)
my_library = rule(_noop_impl)
my_test = rule(_noop_impl, test = True)

def my_macro_binary():
    pass

def my_macro_library():
    pass

def my_macro_test():
    pass

def _is_executable_test(name):
    unit_test(
        name = name,
        impl = _is_executable_test_impl,
        attrs = {
            "cc_binary": attr.bool(default = is_executable(get_rule_name(native.cc_binary))),
            "cc_library": attr.bool(default = is_executable(get_rule_name(native.cc_library))),
            "cc_test": attr.bool(default = is_executable(get_rule_name(native.cc_test))),
            "java_binary": attr.bool(default = is_executable(get_rule_name(native.java_binary))),
            "java_library": attr.bool(default = is_executable(get_rule_name(native.java_library))),
            "java_test": attr.bool(default = is_executable(get_rule_name(native.java_test))),
            "my_binary": attr.bool(default = is_executable(get_rule_name(my_binary))),
            "my_library": attr.bool(default = is_executable(get_rule_name(my_library))),
            "my_test": attr.bool(default = is_executable(get_rule_name(my_test))),
            "my_macro_binary": attr.bool(default = is_executable(get_rule_name(my_macro_binary))),
            "my_macro_library": attr.bool(default = is_executable(get_rule_name(my_macro_library))),
            "my_macro_test": attr.bool(default = is_executable(get_rule_name(my_macro_test))),
            "py_binary": attr.bool(default = is_executable(get_rule_name(native.py_binary))),
            "py_library": attr.bool(default = is_executable(get_rule_name(native.py_library))),
            "py_test": attr.bool(default = is_executable(get_rule_name(native.py_test))),
            "sh_binary": attr.bool(default = is_executable(get_rule_name(native.sh_binary))),
            "sh_library": attr.bool(default = is_executable(get_rule_name(native.sh_library))),
            "sh_test": attr.bool(default = is_executable(get_rule_name(native.sh_test))),
        },
    )

def _is_executable_test_impl(env):
    env.expect.where(rule = "cc_binary").that_bool(env.ctx.attr.cc_binary).equals(True)
    env.expect.where(rule = "cc_library").that_bool(env.ctx.attr.cc_library).equals(False)
    env.expect.where(rule = "cc_test").that_bool(env.ctx.attr.cc_test).equals(False)
    env.expect.where(rule = "java_binary").that_bool(env.ctx.attr.java_binary).equals(True)
    env.expect.where(rule = "java_library").that_bool(env.ctx.attr.java_library).equals(False)
    env.expect.where(rule = "java_test").that_bool(env.ctx.attr.java_test).equals(False)
    env.expect.where(rule = "my_binary").that_bool(env.ctx.attr.my_binary).equals(True)
    env.expect.where(rule = "my_library").that_bool(env.ctx.attr.my_library).equals(False)
    env.expect.where(rule = "my_test").that_bool(env.ctx.attr.my_test).equals(False)
    env.expect.where(rule = "my_macro_binary").that_bool(env.ctx.attr.my_macro_binary).equals(True)
    env.expect.where(rule = "my_macro_library").that_bool(env.ctx.attr.my_macro_library).equals(False)
    env.expect.where(rule = "my_macro_test").that_bool(env.ctx.attr.my_macro_test).equals(False)
    env.expect.where(rule = "py_binary").that_bool(env.ctx.attr.py_binary).equals(True)
    env.expect.where(rule = "py_library").that_bool(env.ctx.attr.py_library).equals(False)
    env.expect.where(rule = "py_test").that_bool(env.ctx.attr.py_test).equals(False)
    env.expect.where(rule = "sh_binary").that_bool(env.ctx.attr.sh_binary).equals(True)
    env.expect.where(rule = "sh_library").that_bool(env.ctx.attr.sh_library).equals(False)
    env.expect.where(rule = "sh_test").that_bool(env.ctx.attr.sh_test).equals(False)

def _is_test_test(name):
    unit_test(
        name = name,
        impl = _is_test_test_impl,
        attrs = {
            "cc_binary": attr.bool(default = is_test(get_rule_name(native.cc_binary))),
            "cc_library": attr.bool(default = is_test(get_rule_name(native.cc_library))),
            "cc_test": attr.bool(default = is_test(get_rule_name(native.cc_test))),
            "java_binary": attr.bool(default = is_test(get_rule_name(native.java_binary))),
            "java_library": attr.bool(default = is_test(get_rule_name(native.java_library))),
            "java_test": attr.bool(default = is_test(get_rule_name(native.java_test))),
            "my_binary": attr.bool(default = is_test(get_rule_name(my_binary))),
            "my_library": attr.bool(default = is_test(get_rule_name(my_library))),
            "my_test": attr.bool(default = is_test(get_rule_name(my_test))),
            "my_macro_binary": attr.bool(default = is_test(get_rule_name(my_macro_binary))),
            "my_macro_library": attr.bool(default = is_test(get_rule_name(my_macro_library))),
            "my_macro_test": attr.bool(default = is_test(get_rule_name(my_macro_test))),
            "py_binary": attr.bool(default = is_test(get_rule_name(native.py_binary))),
            "py_library": attr.bool(default = is_test(get_rule_name(native.py_library))),
            "py_test": attr.bool(default = is_test(get_rule_name(native.py_test))),
            "sh_binary": attr.bool(default = is_test(get_rule_name(native.sh_binary))),
            "sh_library": attr.bool(default = is_test(get_rule_name(native.sh_library))),
            "sh_test": attr.bool(default = is_test(get_rule_name(native.sh_test))),
        },
    )

def _is_test_test_impl(env):
    env.expect.where(rule = "cc_binary").that_bool(env.ctx.attr.cc_binary).equals(False)
    env.expect.where(rule = "cc_library").that_bool(env.ctx.attr.cc_library).equals(False)
    env.expect.where(rule = "cc_test").that_bool(env.ctx.attr.cc_test).equals(True)
    env.expect.where(rule = "java_binary").that_bool(env.ctx.attr.java_binary).equals(False)
    env.expect.where(rule = "java_library").that_bool(env.ctx.attr.java_library).equals(False)
    env.expect.where(rule = "java_test").that_bool(env.ctx.attr.java_test).equals(True)
    env.expect.where(rule = "my_binary").that_bool(env.ctx.attr.my_binary).equals(False)
    env.expect.where(rule = "my_library").that_bool(env.ctx.attr.my_library).equals(False)
    env.expect.where(rule = "my_test").that_bool(env.ctx.attr.my_test).equals(True)
    env.expect.where(rule = "my_macro_binary").that_bool(env.ctx.attr.my_macro_binary).equals(False)
    env.expect.where(rule = "my_macro_library").that_bool(env.ctx.attr.my_macro_library).equals(False)
    env.expect.where(rule = "my_macro_test").that_bool(env.ctx.attr.my_macro_test).equals(True)
    env.expect.where(rule = "py_binary").that_bool(env.ctx.attr.py_binary).equals(False)
    env.expect.where(rule = "py_library").that_bool(env.ctx.attr.py_library).equals(False)
    env.expect.where(rule = "py_test").that_bool(env.ctx.attr.py_test).equals(True)
    env.expect.where(rule = "sh_binary").that_bool(env.ctx.attr.sh_binary).equals(False)
    env.expect.where(rule = "sh_library").that_bool(env.ctx.attr.sh_library).equals(False)
    env.expect.where(rule = "sh_test").that_bool(env.ctx.attr.sh_test).equals(True)

def utils_test_suite(name):
    test_suite(
        name = name,
        basic_tests = [
            _get_attr_type_test,
        ],
        tests = [
            _is_executable_test,
            _is_test_test,
        ],
    )
