//
//  CreateView.swift
//  decant
//
//  Created by divpreet singh on 05/05/2026.
//

import SwiftUI

struct CreateView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    var onCreate: (String) -> Void
    
    var body: some View{
        VStack(alignment: .leading, spacing: 20) {
            Text("New bottle")
                .font(.title2)
                .fontWeight(.semibold)
            
            TextField("Bottle Name", text: $name)
                .textFieldStyle(.roundedBorder)
            
            HStack {
                Spacer()
                
                Button("Cancel") {
                    dismiss()
                }
                
                Button("Create") {
                    onCreate(name.isEmpty ? "Untitled Bottle" : name)
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding(24)
        .frame(width:400)
    }
}
