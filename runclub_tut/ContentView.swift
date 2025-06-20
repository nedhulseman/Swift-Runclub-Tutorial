//
//  ContentView.swift
//  runclub_tut
//
//  Created by Ned hulseman on 1/5/25.
//



import SwiftUI

struct ContentView: View {
    var body: some View {
        if let session = AuthService.shared.currentSession {
            HomeView()
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
