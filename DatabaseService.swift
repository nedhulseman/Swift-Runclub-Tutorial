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
struct RunPayload: Identifiable, Codable {
    var id: Int?
    let createdAt: Date
    let distance: Double
    let pace: Double
    let time: Int
    let userId: UUID
    let route: [GeoJson]
    
    enum CodingKeys: String, CodingKey {
        case id, distance, pace, time, route
        case createdAt = "created_at"
        case userId = "user_id"
    }
    
}

struct GeoJson:  Codable {
    var longitude: Double
    var latitude: Double
    
}



final class DatabaseService {
    static let shared = DatabaseService()
    private var supabase = SupabaseClient(supabaseURL: Secrets.supabaseURL!, supabaseKey: Secrets.supabaseKey)
    private init() {}
    
    // CRUD
    func saveWorkout(run: RunPayload) async throws {
        let _ = try await supabase.from(Table.workouts).insert(run).execute().value
    }
    func fetchWorkouts()  async throws -> [RunPayload] {
        return try await supabase.from(Table.workouts).select().execute().value
        
    }
}
