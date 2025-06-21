//
//  DatabaseService.swift
//  runclub_tut
//
//  Created by Ned hulseman on 6/20/25.
//

import Foundation
import Supabase

struct Table {
    static let workouts = "workouts"
}
struct RunPayload: Codable {
    var id: Int?
    let createdAt: Date
    var distance: Double
    var pace: Double
    var time: Int
    var userId: UUID
    
    enum CodingKeys: String, CodingKey {
        case id, distance, pace, time
        case createdAt = "created_at"
        case userId = "user_id"
    }
    
}

final class DatabaseService {
    static let shared = DatabaseService()
    private var supabase = SupabaseClient(supabaseURL: Secrets.supabaseURL!, supabaseKey: Secrets.supabaseKey)
    private init() {}
    
    // CRUD
    func saveWorkout(run: RunPayload) async throws {
        let _ = try await supabase.from(Table.workouts).insert(run).execute().value
    }
    func fetchWorkouts() {
        
    }
}
