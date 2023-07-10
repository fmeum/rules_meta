load(":utils.bzl", "is_label", "is_select", "is_string")

def add_set_setting(builder, *, setting, value):
    attr_name = get_attr_name(setting)
    update_func = lambda _, attr: getattr(attr, attr_name)
    builder = builder | {setting: update_func}

def add_extend_setting(builder, *, setting, value):
    attr_name = get_attr_name(setting)
    update_func = lambda settings, attr: settings[setting] + getattr(attr, attr_name)
    builder = builder | {setting: update_func}

def get_attr_name(setting):
    if is_label(setting):
        # Trigger an early error if the label refers to an invalid repo name.
        setting.workspace_name

        # Ensure that the hash, which is a (signed) 32-bit integer, is non-negative, so that it does
        # not contain a dash, which is not allowed in attribute names. Also ensure that the
        # attribute name starts with a letter as it needs to be a valid identifier.
        return "s_{}_{}".format(hash(str(setting)) + 2147483648, setting.name)
    elif is_string(setting):
        if not setting:
            fail("The empty string is not a valid setting")
        if setting[0] in "@/:":
            fail("Use Label(...) rather than a string to refer to a custom build setting")
        return setting
    else:
        fail("Expected Label or string, got: {} ({})".format(setting, type(setting)))

def get_attr_type(value):
    if is_string(value):
        return "string"
    if is_label(value):
        return "label"

    s = str(value)
    pos = 0

    # In a select, skip over the first key to the first value.
    if s.startswith("select({", pos):
        pos += len("select({")
        if s.startswith("Label(", pos):
            pos += len("Label(")

        # Skip over the string.
        if s[pos] != "\"":
            fail("Failed to parse select value: {}".format(s))
        pos += 1
        for _ in range(pos, len(s)):
            c = s[pos]
            pos += 1
            if c == "\\":
                # Skip over the escaped character.
                pos += 1
            elif c == "\"":
                break

        if s.startswith("): ", pos):
            pos += len("): ")
        elif s.startswith(": ", pos):
            pos += len(") ")

    suffix = ""
    if s[pos] == "[":
        pos += 1
        suffix = "_list"

    if s.startswith("Label(", pos):
        return "label" + suffix
    if s[pos] == "\"":
        return "string" + suffix
    if s[pos] == "-" or s[pos].isdigit():
        return "int" + suffix

    fail("Failed to determine type of: {}".format(s))
