//
//  CountdownView.swift
//  runclub_tut
//
//  Created by Ned hulseman on 1/16/25.
//

import SwiftUI

struct CountdownView: View {
    @EnvironmentObject var runTracker: RunTracker
    @State var timer: Timer?
    @State var countdown = 3
    var body: some View {
        Text("\(countdown)")
            .font(.system(size:256))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.yellow)
            .onAppear(perform: {
                setupCountdown()
            })

            
    }
    func setupCountdown(){
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ _ in
                if countdown <= 1{
                    timer?.invalidate()
                    timer = nil
                    runTracker.presentCountdown = false
                    runTracker.startRun()
                } else{
                    countdown -= 1
                }
        }
    }
}

#Preview {
    CountdownView()
}
