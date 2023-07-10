load(":rule_defaults.bzl", "DEFAULT_PROVIDERS", "EXTRA_EXECUTABLES", "EXTRA_TESTS", "IMPLICIT_TARGETS")

visibility("//tests/...")

def rule(
        rule_or_macro,
        *,
        executable = None,
        test = None,
        implicit_targets = None,
        providers = DEFAULT_PROVIDERS):
    rule_name = get_rule_name(rule_or_macro)

    if executable == None:
        executable = is_executable(rule_name)
    if test == None:
        test = is_test(rule_name)
    if implicit_targets == None:
        implicit_targets = get_implicit_targets(rule_name)

    return struct(
        rule = rule_or_macro,
        executable = executable,
        test = test,
        implicit_targets = implicit_targets,
        providers = providers,
    )

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

def get_implicit_targets(rule_name):
    return IMPLICIT_TARGETS.get(rule_name, [])
