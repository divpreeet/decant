//
//  BottleManager.swift
//  decant
//
//  Created by divpreet singh on 05/05/2026.
//

import Foundation

class BottleManager {
    static let shared = BottleManager()
    
    private let fileManager = FileManager.default
    private var baseURL: URL {
        fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Decant")
    }
    
    private var bottlesURL: URL {
        baseURL.appendingPathComponent("bottles")
    }
    
    private func createBaseDirectory() {
        try? fileManager.createDirectory(at: bottlesURL, withIntermediateDirectories: true)
    }

    init() {
        createBaseDirectory()
    }
    
    func saveBottleConfig(_ bottle: Bottle) {
        let configURL = bottle.path.appendingPathComponent("config.json")
        
        if let data = try? JSONEncoder().encode(bottle) {
            try? data.write(to: configURL)
        }
    }
    
    func createBottle(name: String) -> Bottle {
        let id = UUID()
        let bottleURL = bottlesURL.appendingPathComponent(id.uuidString)
        try? fileManager.createDirectory(at: bottleURL, withIntermediateDirectories: true)
        
        let bottle = Bottle(
            id: id,
            name: name,
            path: bottleURL,
            created: Date(),
            wineVersion: "system",
            architecture: "win64",
        )
        saveBottleConfig(bottle)
        return bottle
    }
    
    func loadBottles() -> [Bottle] {
        guard let contents = try? fileManager.contentsOfDirectory(at: bottlesURL, includingPropertiesForKeys: nil) else {
            return []
        }
        
        return contents.compactMap { url in
            let configURL = url.appendingPathComponent("config.json")
            
            guard let data = try? Data(contentsOf: configURL),
                  let bottle = try? JSONDecoder().decode(Bottle.self, from: data) else {
                return nil
            }
            
            return bottle
        }
                
    }

}
