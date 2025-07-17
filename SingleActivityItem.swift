//
//  SingleActivityView.swift
//  runclub_tut
//
//  Created by Ned hulseman on 7/11/25.
//

import SwiftUI
import MapKit

struct SingleActivityView: View {
    var  run: RunPayload
    var body: some View {
        VStack(alignment: .leading) {
            Text("Morning Run")
                .bold()
                .font(.title3)
            Text("\(run.createdAt.DateToString()  )")
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
            .padding()
            Map {
                MapPolyline(coordinates: convertRouteToCoordinate(geoJson: run.route))
                    .stroke(.yellow, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
            }
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity, alignment: .leading)
    }
    func convertRouteToCoordinate(geoJson: [GeoJson]) -> [CLLocationCoordinate2D] {
        return geoJson.map {
            CLLocationCoordinate2D(latitude: $0.latitude,   longitude: $0.longitude)
        }
    }
}

#Preview {
    SingleActivityView(run: RunPayload(createdAt: Date.now, distance: 1232, pace: 232, time: 213123, userId: .init(), route: []))
}
