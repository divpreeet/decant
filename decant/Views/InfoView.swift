//
//  InfoView.swift
//  decant
//
//  Created by divpreet singh on 06/05/2026.
//

import SwiftUI
import AppKit

struct InfoView: View {
    let bottle: Bottle
    @State private var size: Int64 = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(bottle.name)
                .font(.headline)
            
            Divider()
            
            InfoRow(label: "Location", value: bottle.path.path)
            InfoRow(label: "Architecture", value: bottle.architecture)
            InfoRow(label: "Wine Version", value: bottle.wineVersion)
            InfoRow(label: "Size", value: formattedSize)
            
            Spacer()
            
        }
        .padding(20)
        .frame(width: 400, height: 260)
        .onAppear {
            size = BottleManager.shared.folderSize(for: bottle.path)
        }
    }
    
    var formattedSize: String{
        ByteCountFormatter.string(fromByteCount: size, countStyle: .file)
    }
}



struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View{
        HStack{
            Text(label)
                .foregroundStyle(.secondary)
                .frame(width: 110, alignment: .leading)
            
            Button{
                NSWorkspace.shared.activateFileViewerSelecting([URL(fileURLWithPath: value)])
            } label: {
                Text(value)
                    .lineLimit(2)
                    .truncationMode(.middle)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
            Spacer()
        }
    }
}
