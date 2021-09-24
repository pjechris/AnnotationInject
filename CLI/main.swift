import Foundation

// This executable just forward to shell script

var sourcery = Process()
var generateSwiftFatFile = Process()
let currentPath = FileManager.default.currentDirectoryPath

generateSwiftFatFile = Process()
generateSwiftFatFile.executableURL = URL(fileURLWithPath: "/bin/bash")
generateSwiftFatFile.arguments = ["\(currentPath)/Scripts/generate-annotation-template"]

sourcery.executableURL = URL(fileURLWithPath: "/usr/bin/swift")
sourcery.arguments = [
    "run",
    "sourcery",
    "--templates",
    currentPath + "/Templates"
] + Array(CommandLine.arguments.dropFirst())

try generateSwiftFatFile.run()
generateSwiftFatFile.waitUntilExit()

try sourcery.run()
sourcery.waitUntilExit()
