//
//  ContentView.swift
//  decant
//
//  Created by divpreet singh on 05/05/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var bottles: [Bottle] = []
    @State private var selectedBottle: Bottle?
    @State private var createSheet = false
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedBottle) {
                ForEach(bottles) { bottle in
                    Text(bottle.name)
                        .tag(bottle)
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {createSheet = true}) {
                        Image(systemName: "plus")
                    }
                }
            }
        } detail: {
            if let bottle = selectedBottle {
                BottleView(bottle: bottle)
            } else {
                EmptyView() {
                    createSheet = true
                }
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
    }

    func addBottle() {
        let newBottle = BottleManager.shared.createBottle(name: "New Bottle")
        bottles.append(newBottle)
    }
}

#Preview {
    ContentView()
}
