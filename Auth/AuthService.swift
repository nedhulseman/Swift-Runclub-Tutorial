//
//  AuthService.swift
//  runclub_tut
//
//  Created by Ned hulseman on 6/12/25.
//

import Foundation
import Supabase

struct Secrets {
    static let supabaseURL = URL(string: "https://mrrwuzbnmnjbynumsuba.supabase.co")
    static let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1ycnd1emJubW5qYnludW1zdWJhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk3NDAwMTQsImV4cCI6MjA2NTMxNjAxNH0.W88TyaoPHlhEShfXlXOA5eqv1ayPs4RWQjzbFTpE4vs"
}

@Observable
final class AuthService {
    static let shared = AuthService()
    private var supabase = SupabaseClient(supabaseURL: Secrets.supabaseURL!, supabaseKey: Secrets.supabaseKey)
    
    var currentSession: Session?
    private init () { Task { currentSession = try? await supabase.auth.session } }
    
    func magicLinkLogin(email: String) async throws {
        try await supabase.auth.signInWithOTP(
          email: email,
          redirectTo: URL(string: "com.runclub-tutorial://login-callback")!
        )
    }
    func handleOpenURL(url: URL) async throws {
        currentSession = try await supabase.auth.session(from: url)
    }
    
    func logout() async throws {
        try await supabase.auth.signOut()
        currentSession = nil
    }
}
