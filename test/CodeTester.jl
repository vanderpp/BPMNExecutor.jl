using BPMNExecutor

parsed = parseBPMN()

print(topLevelResumableGenerator(parsed))
print(topScopeGenerator(parsed))