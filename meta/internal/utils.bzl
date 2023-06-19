def value_from_select(select):
    s = str(select)
    pos = 0
    if s.startswith("select({"):
        pos += len("select({")
        if s.startswith("Label("):
            pos += len("Label(")

    c = s[0]
    if c == "[":
        return _LIST_TYPE
    elif c == "{":
        return _DICT_TYPE
    elif c == "\"":
        return _STRING_TYPE
    print(s)
    return _STRING_TYPE

def attr_from_value(value):
    if is_dict(value):
        value = value.values()[0]
    if is_list(value):
        return attr.string_list()
    elif is_string(value):
        return attr.string()
    else:
        fail("Unsupported type for setting value: %s" % type(value))

def is_dict(value):
    return type(value) == _DICT_TYPE

def is_list(value):
    return type(value) == _LIST_TYPE

def is_select(value):
    return type(value) == _SELECT_TYPE

def is_string(value):
    return type(value) == _STRING_TYPE

def is_struct(value):
    return type(value) == _STRUCT_TYPE

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
    RunEnvironmentInfo,
    # No longer available with last_green.
    # ProtoToolchainInfo,
    PyInfo,
    PyRuntimeInfo,
]

REPLACE_ONLY_LIST_COMMAND_LINE_OPTIONS = [
    "catalyst_cpus",
    "fat_apk_cpu",
    "ios_multi_cpus",
    "macos_cpus",
    "platforms",
    "tvos_cpus",
    "watchos_cpus",
]

_DICT_TYPE = type({})
_LIST_TYPE = type([])
_SELECT_TYPE = type(select({"//conditions:default": True}))
_STRING_TYPE = type("")
_STRUCT_TYPE = type(struct())
