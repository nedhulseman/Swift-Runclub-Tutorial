

//
//  HomeView.swift
//  runclub_tut
//
//  Created by Ned hulseman on 1/3/25.
//

import SwiftUI
import MapKit

class RunTracker: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var isRunning = false
    @Published var presentCountdown = false
    @Published var distance = 0.0
    @Published var pace = 0.0
    @Published var elapsedTime = 0
    @Published var presentRunView = false
    
    private var timer: Timer?
    
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 38.9072,
            longitude: -77.0369),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.2)
    )
    
    // Location  Tracking
    private var locationManager: CLLocationManager?
    private var startLocation: CLLocation?
    private var lastLocation: CLLocation?
    
    override init() {
        super.init()
        
        Task {
            await MainActor.run{
                locationManager = CLLocationManager()
                locationManager?.delegate = self
                locationManager?.requestWhenInUseAuthorization()
                locationManager?.startUpdatingLocation()
            }
        }
    }
    func startRun() {
        startLocation = nil
        lastLocation = nil
        distance = 0.0
        pace = 0.0
        presentRunView = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {[weak self] _ in
            guard let self else { return }
            self.elapsedTime += 1
            if self.distance > 0 {
                pace = (Double(self.elapsedTime) / 60)  / (self.distance / 1000)
            }
        }
        locationManager?.startUpdatingLocation()

    }
}

extension RunTracker {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        Task {
            await MainActor.run {
                region.center = location.coordinate
            }
        }
        
        if startLocation == nil {
            startLocation = location
            lastLocation = location
            return
        }
        lastLocation = location
    }
}
// fixing warning, using Stack overflow solution
// --> https://stackoverflow.com/questions/73813978/model-updates-trigger-publishing-changes-from-within-view-updates-is-not-allowe
struct AreaMap: View {
    @Binding var region: MKCoordinateRegion
    var body: some View {
        let binding = Binding(
            get: { self.region },
            set: { newValue in
                DispatchQueue.main.async {
                    self.region = newValue
                }
            }
        )
        return Map(coordinateRegion: binding,
                   showsUserLocation: true,userTrackingMode: .constant(.follow))
    }
}

struct HomeView: View {
    @StateObject var runTracker = RunTracker()
    var body: some View {
        NavigationStack{
            VStack{
                ZStack(alignment: .bottom) {
                    
                    
                    
                    AreaMap(region: $runTracker.region)
                    
                    // -- Testing to replace this with Areamap
                    /*
                     Map(coordinateRegion: $runTracker.region,
                        showsUserLocation: true,userTrackingMode: .constant(.follow))
                    */
                    // -- Very old
                    //Map(initialPosition: .region(runTracker.region))
                    Button{
                        runTracker.presentCountdown = true
                    } label:{
                        Text("Start")
                            .bold()
                            .font(.title)
                            .foregroundStyle(.black)
                            .padding(36)
                            .background(.yellow)
                            .clipShape(Circle())
                    }
                }

            }
            .frame(maxHeight: .infinity, alignment: .top)
            .navigationTitle("Run")
            .fullScreenCover(isPresented: $runTracker.presentCountdown, content: {
                CountdownView()
                    .environmentObject(runTracker)
            })
            .fullScreenCover(isPresented: $runTracker.presentRunView, content: {
                RunView()
                    .environmentObject(runTracker)
            })
        }
    }
}

#Preview {
    HomeView()
}


