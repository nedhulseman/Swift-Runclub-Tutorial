//
//  RunView.swift
//  runclub_tut
//
//  Created by Ned hulseman on 1/18/25.
//

import SwiftUI
import AudioToolbox

func seconds_to_timer(totalSeconds: Int) -> String {
    let totalMinutes = totalSeconds / 60
    let totalHours =  totalMinutes / 60
    let remainingMinutes = totalMinutes % 60
    let remainingSeconds = totalSeconds % 60
    return String(format: "%01d:%02d:%02d", totalHours, remainingMinutes, remainingSeconds)
}

struct RunView: View {
    @EnvironmentObject var runTracker: RunTracker
    var body: some View {
        VStack{
            HStack{
                VStack{
                    Text("\(runTracker.distance, specifier: "%.2f") meters")
                        .font(.title3)
                        .bold()
                    Text("Distance")
                }
                .frame(maxWidth: .infinity)
                VStack{
                    Text("BPM")
                }
                .frame(maxWidth: .infinity)
                VStack{
                    Text("\(runTracker.pace, specifier: "%.2f") minute per km")
                        .font(.title3)
                        .bold()
                    Text("Pace")
                }
                .frame(maxWidth: .infinity)
            }
            
            VStack {
                Text("\(seconds_to_timer(totalSeconds: runTracker.elapsedTime))")
                    .font(.system(size:64))
                Text("Time")
                    .foregroundStyle(.gray)
            }
            .frame(maxHeight: .infinity)
            HStack{
                Button {
                    runTracker.pauseRun()
                } label: {
                    Image(systemName: "pause.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .padding(36)
                        .background(.black)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    
                }
                .frame(maxWidth:.infinity)
                
                Button {
                    
                } label: {
                    Image(systemName: "stop.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .padding(36)
                        .background(.black)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    
                }
                .frame(maxWidth:.infinity)
                .simultaneousGesture(LongPressGesture().onEnded({_ in
                    runTracker.stopRun()
                    AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {   }

                }))
            }
            
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(.yellow)
    }
}

#Preview {
    RunView()
        .environmentObject(RunTracker())
}
