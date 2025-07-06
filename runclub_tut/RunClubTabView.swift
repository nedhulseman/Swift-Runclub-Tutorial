//
//  RunClubTabView.swift
//  runclub_tut
//
//  Created by Ned hulseman on 1/7/25.
//

import SwiftUI

struct RunClubTabView: View {
    @State var selectTab = 0
    var body: some View {
        TabView(selection: $selectTab){
            HomeView()
                .tag(0)
                .tabItem {
                    Image(systemName: "figure.run.circle")
                    Text("Run")
                }
            ActivityView()
                .tag(1)
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Activity")
                }
        }
    }
}

#Preview {
    RunClubTabView()
}
