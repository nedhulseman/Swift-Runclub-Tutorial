//
//  AuthService.swift
//  runclub_tut
//
//  Created by Ned hulseman on 6/12/25.
//

import Foundation

final class AuthService {
    static let shared = AuthService()
    private var supabase = SupabaseClient(supabaseURL: <#T##URL#>, supabaseKey: <#T##String#>))
    private init () {}
    
    func magicLinkLogin(){
        try await supabase.auth.signInWithOTP(
          email: "example@email.com",
          redirectTo: URL(string: "my-app-scheme://")!
        )
    }
}
