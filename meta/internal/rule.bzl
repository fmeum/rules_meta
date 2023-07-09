load(":rule_defaults.bzl", "DEFAULT_PROVIDERS", "DEFAULT_TARGETS", "EXTRA_EXECUTABLES", "EXTRA_TESTS")

visibility("//tests/...")

def get_rule_name(rule_or_macro):
    s = str(rule_or_macro)
    if s.startswith("<rule "):
        return s.removeprefix("<rule ").removesuffix(">")
    elif s.startswith("<built-in rule "):
        return s.removeprefix("<built-in rule ").removesuffix(">")
    elif s.startswith("<function "):
        return s.removeprefix("<function ").removesuffix(">").partition(" from ")[0]
    else:
        fail("Not a rule or macro: " + s)

def is_executable(rule_name):
    if rule_name.endswith("_binary"):
        return True
    return EXTRA_EXECUTABLES.get(rule_name, False)

def is_test(rule_name):
    if rule_name.endswith("_test"):
        return True
    return EXTRA_TESTS.get(rule_name, False)
