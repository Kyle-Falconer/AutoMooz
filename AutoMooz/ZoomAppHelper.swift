//
//  ZoomAppHelper.swift
//  AutoMooz
//
//  Created by Kyle Falconer on 10/26/20.
//

import Foundation

class ZoomAppHelper {
    static func launchZoom(meetingUrl: String) {
        print("launching Zoom using URL")
        
//        let bash: CommandExecuting = Bash()
//        if let openOutput = try? bash.run(commandName: "open", arguments: ["\"\(meetingUrl)\""]) { print(openOutput) }
        let output = shell(command: "open \"\(meetingUrl)\"")
        print(output)
    }
    
    static func launchZoom(meetingId: String) {
        print("launching Zoom using ID")
//        let bash: CommandExecuting = Bash()
        
//        if let openOutput = try? bash.run(commandName: "open", arguments: ["\"zoommtg://zoom.us/join?confno=\(meetingId)}\""]) { print(openOutput) }
        let output = shell(command: "open \"zoommtg://zoom.us/join?confno=\(meetingId)\"")
        print(output)
    }
    
    static func shell(command: String) -> String {
        let task = Process()
        let pipe = Pipe()

        task.standardOutput = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/bash"
        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!

        return output
    }

//    // see https://stackoverflow.com/a/26973384/940217
//    @discardableResult
//    static func shell(_ args: String...) -> Int32 {
//        let task = Process()
//        task.launchPath = "/usr/bin/env"
//        task.arguments = args
//        task.launch()
//        task.waitUntilExit()
//        return task.terminationStatus
//    }
}
