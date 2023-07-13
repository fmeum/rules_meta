load(":builder.bzl", "make_builder")
load(":common.bzl", "RuleInfo")
load(":rule_defaults.bzl", "DEFAULT_PROVIDERS", "IMPLICIT_TARGETS")

visibility(["//meta", "//tests/..."])

# A globally unique string that we can use to validate that implicit target
# patterns contain a single placeholder.
_PATTERN_VALIDATION_MARKER = "with_cfg!-~+this string is pretty unique"

def rule(
        rule_or_macro,
        *,
        executable = None,
        implicit_targets = None,
        extra_providers = []):
    rule_name = get_rule_name(rule_or_macro)

    if executable == None:
        executable = is_executable(rule_name)
    if implicit_targets == None:
        implicit_targets = get_implicit_targets(rule_name)

    # Validate implicit target patterns eagerly for better error messages.
    for pattern in implicit_targets:
        if pattern.format(_PATTERN_VALIDATION_MARKER).count(_PATTERN_VALIDATION_MARKER) != 1:
            fail("Implicit target pattern must contain exactly one '{}' placeholder: " + pattern)

    rule_info = RuleInfo(
        kind = rule_or_macro,
        executable = executable,
        # Bazel enforces that a rule is a test rule if and only if its name ends with "_test", so we
        # do not allow overriding this.
        test = is_test(rule_name),
        implicit_targets = implicit_targets,
        providers = DEFAULT_PROVIDERS + extra_providers,
    )
    return make_builder(rule_info)

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
    return rule_name.endswith("_binary")

def is_test(rule_name):
    return rule_name.endswith("_test")

def get_implicit_targets(rule_name):
    return IMPLICIT_TARGETS.get(rule_name, [])
