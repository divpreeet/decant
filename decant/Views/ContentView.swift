//
//  ContentView.swift
//  decant
//
//  Created by divpreet singh on 05/05/2026.
//

import SwiftUI
import AppKit

struct ContentView: View {
    @State private var bottles: [Bottle] = []
    @State private var selectedBottle: Bottle?
    @State private var createSheet = false
    @State private var infoBottle: Bottle?
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedBottle) {
                ForEach(bottles) { bottle in
                    Text(bottle.name)
                        .tag(bottle)
                        .contextMenu {
                            Button("Show in Finder") {
                                NSWorkspace.shared.activateFileViewerSelecting([bottle.path])
                            }
                            Button("Get Info") {
                                InfoManager.shared.showInfo(for: bottle)
                            }
                            Button("Delete", role: .destructive) {
                            if let index = bottles.firstIndex(of:bottle) {
                                deleteBottle(at: IndexSet(integer: index))
                            }
                        }
                    }
                }
                
            }
            .onDeleteCommand {
                if let selected = selectedBottle,
                   let index = bottles.firstIndex(of: selected) {
                    deleteBottle(at: IndexSet(integer: index))
                }
            }
            
        } detail: {
            if bottles.isEmpty{
                EmptyView() {
                    createSheet = true
                }
            } else if let bottle = selectedBottle {
                BottleView(bottle: bottle)
            } else {
                Text("Select a bottle")
                    .foregroundStyle(.secondary)
            }
        }
        .toolbar {
            ToolbarItem {
                
                Button {
                    createSheet = true
                } label: {
                    Image(systemName: "plus")
                }
           }
            
            ToolbarItem {
                Button(role: .destructive) {
                    if let selected = selectedBottle,
                       let index = bottles.firstIndex(of: selected) {
                        deleteBottle(at: IndexSet(integer: index))
                    }
                } label: {
                    Image(systemName: "trash")
                }
                .disabled(selectedBottle == nil)
            }
            
            ToolbarItem{
                Button {
                    if let selected = selectedBottle {
                        InfoManager.shared.showInfo(for: selected)
                    }
                } label: {
                    Image(systemName: "info.circle")
                }
                .disabled(selectedBottle == nil)
            }
        }
        .onAppear {
            bottles = BottleManager.shared.loadBottles()
        }
        .sheet(isPresented: $createSheet) {
            CreateView { name in
                let bottle = BottleManager.shared.createBottle(name: name)
                bottles.append(bottle)
                selectedBottle = bottle
            }
        }
        .navigationSplitViewColumnWidth(min: 180, ideal: 220, max: 280)
    }

    func addBottle() {
        let newBottle = BottleManager.shared.createBottle(name: "New Bottle")
        bottles.append(newBottle)
    }
    
    func deleteBottle(at offsets: IndexSet) {
        for index in offsets {
            let bottle = bottles[index]
            BottleManager.shared.deleteBottle(bottle)
        }
        
        bottles.remove(atOffsets: offsets)
        
        if !bottles.contains(where: { $0.id == selectedBottle?.id }) {
            selectedBottle = bottles.first
        }
    }
}

#Preview {
    ContentView()
}
