visibility("private")

SettingInfo = provider(fields = ["operation", "value"])

RuleInfo = provider(fields = ["kind", "executable", "test", "implicit_targets", "providers"])

FrontendInfo = provider(fields = ["executable", "providers", "run_environment_info"])
