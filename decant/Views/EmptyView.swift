//
//  EmptyView.swift
//  decant
//
//  Created by divpreet singh on 05/05/2026.
//


import SwiftUI

struct EmptyView: View {
    var onCreate:  () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "wineglass")
                .font(.system(size: 50))
                .foregroundStyle(.secondary)
            
            Text("No bottles")
                .font(.title2)
                .fontWeight(.semibold)
            
            Button(action: onCreate) {
                Label("Create bottle", systemImage: "plus")
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
