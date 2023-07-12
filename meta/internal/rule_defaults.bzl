visibility("private")

DEFAULT_PROVIDERS = [
    # RunEnvironmentInfo can't be returned from a non-executable, non-test rule
    # and thus requires special handling.
    CcInfo,
    JavaInfo,
    InstrumentedFilesInfo,
    PyInfo,
]

IMPLICIT_TARGETS = {
}
