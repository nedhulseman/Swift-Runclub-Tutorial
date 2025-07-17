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
                    NavigationLink {
                        SingleActivityView(run: run)
                    } label: {
                        VStack(alignment: .leading) {
                            Text("Morning Run")
                                .bold()
                                .font(.title3)
                            Text("\(run.createdAt.DateToString())  )")
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
            }
            .listStyle(.plain)
            .navigationTitle("Activity")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(role: .destructive){
                        Task {
                            do {
                                try await AuthService.shared.logout()
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    } label: {
                        Text("Logout")
                            .foregroundStyle(.red)
                    }
                }
            }
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
}

#Preview {
    ActivityView()
}
