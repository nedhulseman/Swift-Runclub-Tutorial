//
//  PauseView.swift
//  runclub_tut
//
//  Created by Ned hulseman on 6/11/25.
//

import SwiftUI
import MapKit
import AudioToolbox

struct PauseView: View {
    @EnvironmentObject var runTracker: RunTracker
    var body: some View {
        VStack {
            AreaMap(cameraPosition: $runTracker.cameraPosition)
                .ignoresSafeArea()
                .frame(height:300)
            HStack{
                VStack{
                    Text("\(runTracker.distance, specifier: "%.2f") ")
                        .font(.title)
                        .bold()
                    Text("Distance (km)")
                }.frame(maxWidth: .infinity)
                VStack{
                    Text("\(runTracker.pace, specifier: "%.2f") ")
                        .font(.title)
                        .bold()
                    Text("Pace")
                }.frame(maxWidth: .infinity)
                VStack{
                    Text("\(seconds_to_timer(totalSeconds: runTracker.elapsedTime))")
                        .font(.title)
                        .bold()
                    Text("Time")
                }.frame(maxWidth: .infinity)
            }.padding()
            HStack{
                VStack{
                    Text("0")
                        .font(.title)
                        .bold()
                    Text("Calories")
                }.frame(maxWidth: .infinity)
                VStack{
                    Text("0f")
                        .font(.title)
                        .bold()
                    Text("Elevation")
                }.frame(maxWidth: .infinity)
                VStack{
                    Text("0")
                        .font(.title)
                        .bold()
                    Text("BPM")
                }.frame(maxWidth: .infinity)
            }
            
            HStack{
                Button {
                    withAnimation{
                        runTracker.resumeRun()
                    }
                } label: {
                    Image(systemName: "play.fill")
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
            }.frame(maxHeight:.infinity, alignment: .bottom)
            
            
        }
        .frame(maxHeight:.infinity, alignment: .top)
    }
        
}

#Preview {
    PauseView()
        .environmentObject(RunTracker())
}
