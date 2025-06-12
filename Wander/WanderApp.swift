//
//  WanderApp.swift
//  Wander
//
//  Created by Jake Kinchen on 10/13/24.
//

import SwiftUI
import SwiftData
import AVFoundation

@main
struct WanderApp: App {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var beaconManager = BeaconManager()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    init() {
        configureAudioSession()
    }

    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: [.duckOthers, .defaultToSpeaker])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("AudioSession error: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
