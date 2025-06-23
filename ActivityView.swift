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
                    HStack {
                        Text("\(run.distance / 1000 ) km")
                        Text("\(run.createdAt.formatted()  )")

                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Activity")
            .onAppear {
                
            }
        }
    }
}

#Preview {
    ActivityView()
}
