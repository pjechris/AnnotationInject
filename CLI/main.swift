import Foundation

// This executable just forward to shell script

var task = Process()
var errorPipe = Pipe()

task.executableURL = URL(fileURLWithPath: "../../Scripts/annotationinject")
task.standardError = errorPipe
task.arguments = CommandLine.arguments

try task.run()

let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()

exit(errorData.isEmpty ? 0 : 1)

