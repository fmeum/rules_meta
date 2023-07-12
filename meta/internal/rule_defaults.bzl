visibility("private")

DEFAULT_PROVIDERS = [
    # RunEnvironmentInfo can't be returned from a non-executable, non-test rule
    # and thus requires special handling.
    AnalysisTestResultInfo,
    CcInfo,
    CcToolchainConfigInfo,
    DebugPackageInfo,
    InstrumentedFilesInfo,
    OutputGroupInfo,
    PyInfo,
    PyRuntimeInfo,
    RunEnvironmentInfo,
    platform_common.TemplateVariableInfo,
    platform_common.ToolchainInfo,
    apple_common.XcodeProperties,
    apple_common.XcodeVersionConfig,
]

IMPLICIT_TARGETS = {
    "cc_binary": [
        ".dwp",
        ".stripped",
    ],
    "java_binary": [
        ".jar",
        "-src.jar",
        "_deploy.jar",
        "_deploy-src.jar",
    ],
}
