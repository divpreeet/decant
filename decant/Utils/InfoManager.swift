//
//  InfoManager.swift
//  decant
//
//  Created by divpreet singh on 06/05/2026.
//

import SwiftUI
import AppKit

class InfoManager {
    static let shared = InfoManager()
    private var windows: [UUID: NSWindow] = [:]
    
    func showInfo(for bottle: Bottle) {
        if let existing = windows[bottle.id] {
            existing.makeKeyAndOrderFront(nil)
            return
        }
        
        let view = InfoView(bottle: bottle)
        let hosting = NSHostingView(rootView: view)
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 300), styleMask: [.titled, .closable], backing: .buffered, defer: false
        )
        
        
        window.title = bottle.name
        window.contentView = hosting
        window.isReleasedWhenClosed = false
        window.center()
        window.makeKeyAndOrderFront(nil)
        windows[bottle.id] = window
        
        NotificationCenter.default.addObserver(forName: NSWindow.willCloseNotification, object: window, queue: .main) { [weak self] _ in
            self?.windows.removeValue(forKey: bottle.id)
        }
    }
}


