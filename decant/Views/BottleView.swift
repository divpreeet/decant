//
//  BottleView.swift
//  decant
//
//  Created by divpreet singh on 05/05/2026.
//

import SwiftUI

struct BottleView: View {
    let bottle: Bottle
    
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
            
            Spacer()
        }
        .padding()
    }
}
