visibility("private")

DEFAULT_PROVIDERS = [
    CcInfo,
    InstrumentedFilesInfo,
    JavaInfo,
    PyInfo,
    RunEnvironmentInfo,
]

EXTRA_EXECUTABLES = {
}

EXTRA_TESTS = {
    "cc_test_wrapper": True,
}

IMPLICIT_TARGETS = {
}
