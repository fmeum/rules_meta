_DICT_TYPE = type({})
_LIST_TYPE = type([])
_SELECT_TYPE = type(select({"//conditions:default": True}))
_STRING_TYPE = type("")

def attr_from_value(value):
    if is_dict(value):
        value = value.values()[0]
    if is_list(value):
        return attr.string_list()
    elif is_string(value):
        return attr.string()
    else:
        fail("Unsupported type for setting value: %s" % type(value))

def identifier_from_setting(setting):
    with_safe_chars = "".join([_safe_char(c) for c in setting.elems()])
    return "transitive_{}_{}".format(with_safe_chars, str(hash(setting)).replace("-", "_"))

def is_dict(value):
    return type(value) == _DICT_TYPE

def is_list(value):
    return type(value) == _LIST_TYPE

def is_select(value):
    return type(value) == _SELECT_TYPE

def is_string(value):
    return type(value) == _STRING_TYPE

def _safe_char(c):
    if c.isalpha() or c.isdigit():
        return c
    else:
        return "_"

# Extracted from https://docs.bazel.build/versions/5.0.0/skylark/lib/skylark-provider.html
NATIVE_PROVIDERS = [
    CcInfo,
    CcToolchainConfigInfo,
    DebugPackageInfo,
    InstrumentedFilesInfo,
    JavaInfo,
    JavaPluginInfo,
    OutputGroupInfo,
    ProtoInfo,
    # No longer available with last_green.
    # ProtoToolchainInfo,
    PyInfo,
    PyRuntimeInfo,
]
