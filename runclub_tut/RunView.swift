//
//  RunView.swift
//  runclub_tut
//
//  Created by Ned hulseman on 1/18/25.
//

import SwiftUI

struct RunView: View {
    @EnvironmentObject var runTracker: RunTracker
    var body: some View {
        VStack{
            HStack{
                VStack{
                    Text("\(runTracker.distance) meters")
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
                    Text("\(runTracker.pace) km/minute")
                        .font(.title3)
                        .bold()
                    Text("Pace")
                }
                .frame(maxWidth: .infinity)
            }
            
            VStack {
                Text("\(runTracker.elapsedTime)")
                    .font(.system(size:64))
                Text("Time")
                    .foregroundStyle(.gray)
            }
            .frame(maxHeight: .infinity)
            HStack{
                Button {
                    
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
            }
            
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(.yellow)
    }
}

#Preview {
    RunView()
}
