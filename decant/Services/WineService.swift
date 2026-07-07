//
//  WineService.swift
//  decant
//
//  Created by divpreet singh on 05/07/2026.
//

import Foundation
import AppKit
import Combine

class WineService: ObservableObject {
    static let shared = WineService()
    
    @Published var runningProcesses: [UUID: RunningProcess] = [:]
    
    struct RunningProcess: Identifiable {
        let id: UUID
        let process: Process
        let bottleID: UUID
        let executableURL: URL
        let startedAt: Date
    }
    
    enum WineError: Error, LocalizedError {
        case notFound
        case launchFailed(Error)
        
        var errorDescription: String? {
            switch self {
            case .notFound:
                return "Wine not found. Install it using homebrew (brew install --cask wine-stable)"
            case .launchFailed(let error):
                return "Launch failed: \(error.localizedDescription)"
            }
        }
    }
    
    func wineDetector() -> URL? {
        let candidates: [String] = [
            "/opt/homebrew/bin/wine64",
            "/opt/homebrew/bin/wine",
            "/usr/local/bin/wine64",
            "/usr/local/bin/wine"
        ]
        
        for path in candidates {
            if FileManager.default.isExecutableFile(atPath: path) {
                return URL(fileURLWithPath: path)
            }
        }
        
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/which")
        task.arguments = ["wine"]
        
        let output = Pipe()
        task.standardOutput = output
        
        try? task.run()
        task.waitUntilExit()
        if task.terminationStatus == 0{
            let data = output.fileHandleForReading.readDataToEndOfFile()
            if let path = String(data: data, encoding: .utf8)?
                .trimmingCharacters(in: .whitespacesAndNewlines), !path.isEmpty {
                return URL(fileURLWithPath: path)
            }
        }
        
        return nil
        
    }
    
    @discardableResult
    func runExec(_ url: URL, in bottle: Bottle) throws -> UUID {
        guard let wineURL = wineDetector() else {
            throw WineError.notFound
        }
        
        let process = Process()
        process.executableURL = wineURL
        process.arguments = [url.path]
        
        var env = ProcessInfo.processInfo.environment
        env["WINEPREFIX"] = bottle.path.path
        process.environment = env
        process.currentDirectoryURL = bottle.path
        
        let id = UUID()
        let running = RunningProcess(
            id: id,
            process: process,
            bottleID: bottle.id,
            executableURL: url,
            startedAt: Date()
        )
        
        DispatchQueue.main.async {
            self.runningProcesses[id] = running
        }
        
        try process.run()
        

        process.terminationHandler = { [weak self] _ in
            DispatchQueue.main.async {
                self?.runningProcesses.removeValue(forKey: id)
            }
        }
        
        return id
    }
    
    func killProcess(id: UUID) {
        runningProcesses[id]?.process.terminate()
    }
    
    func processes(for bottleID: UUID) -> [RunningProcess] {
        runningProcesses.values.filter { $0.bottleID == bottleID }
    }
}
