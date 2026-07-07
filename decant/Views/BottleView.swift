//
//  BottleView.swift
//  decant
//
//  Created by divpreet singh on 05/05/2026.
//

import SwiftUI

struct BottleView: View {
    let bottle: Bottle
    @ObservedObject private var wineService = WineService.shared
    @State private var errorMessage: String?
    
    private var runningProcesses: [WineService.RunningProcess] {
        wineService.processes(for: bottle.id)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(bottle.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Path: \(bottle.path.path)")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text("Arch: \(bottle.architecture)")
            Text("Wine: \(bottle.wineVersion)")
            
            Divider()
            
            if runningProcesses.isEmpty {
                Button("Run Exectuable") {
                    pickAndRun()
                }
            }
            
            ForEach(runningProcesses) { proc in
                HStack {
                    Circle()
                        .fill(.green)
                        .frame(width: 8, height: 8)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(proc.executableURL.lastPathComponent)
                            .fontWeight(.medium)
                        
                        Text(proc.startedAt, style:.relative)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Button("Stop") {
                        wineService.killProcess(id: proc.id)
                    }
                    .buttonStyle(.glass)
                    .buttonStyle(.bordered)
                    .tint(.red)
                }
                .padding(10)
                .background(.green.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            Button("Run Another") {
                pickAndRun()
            }
            .disabled(!runningProcesses.isEmpty == false)
            
            if let error = errorMessage {
                Text(error)
                    .foregroundStyle(.red)
                    .font(.caption)
            }
            Spacer()  
        }
        
        .padding()
    }
    
    private func pickAndRun() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.message = "Select a Windows executable to run in this bottle"
        panel.begin {
            response in
            guard response == .OK,
                  let url = panel.url else {
                return
            }
            do {
                try wineService.runExec(url, in: bottle)
                errorMessage = nil
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
