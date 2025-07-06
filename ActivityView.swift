//
//  ActivityView.swift
//  runclub_tut
//
//  Created by Ned hulseman on 6/23/25.
//

import SwiftUI

struct ActivityView: View {
    @State var activities = [RunPayload]()
    

    var body: some View {
        NavigationStack {
            List {
                ForEach(activities) { run in
                    VStack(alignment: .leading) {
                        Text("Morning Run")
                            .bold()
                            .font(.title3)
                        Text("\(DateToString(date: run.createdAt)  )")
                        HStack(spacing: 24) {
                            
                            VStack {
                                Text("Distance")
                                    .font(.caption)
                                    .bold()
                                Text("\(run.distance / 1000 , specifier: "%.2f") km")
                            }
                            VStack {
                                Text("Pace")
                                    .font(.caption)
                                    .bold()
                                Text("\(run.pace , specifier: "%.2f" )/km")
                            }
                            VStack {
                                Text("Time")
                                    .font(.caption)
                                    .bold()
                                Text("\(run.time, specifier: "%.2f")")
                            }
                            
                        }
                    }
                    .frame(maxWidth:.infinity, alignment: .leading)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Activity")
            .onAppear {
                Task {
                    do {
                        activities = try await DatabaseService.shared.fetchWorkouts()
                        activities.sort(by: {$0.createdAt >= $1.createdAt})
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                
            }
        }
    }
    func DateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    ActivityView()
}
