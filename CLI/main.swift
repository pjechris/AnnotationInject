import Foundation

// This executable just forward to shell script

var sourcery = Process()
var generateSwiftFatFile = Process()

generateSwiftFatFile = Process()
generateSwiftFatFile.executableURL = URL(fileURLWithPath: "/bin/bash")
generateSwiftFatFile.arguments = ["\(FileManager.default.currentDirectoryPath)/Scripts/generate-annotation-template"]

sourcery.executableURL = URL(fileURLWithPath: "/usr/bin/swift")
sourcery.arguments = ["run", "sourcery"] + Array(CommandLine.arguments.dropFirst())

try generateSwiftFatFile.run()
generateSwiftFatFile.waitUntilExit()

try sourcery.run()
sourcery.waitUntilExit()
