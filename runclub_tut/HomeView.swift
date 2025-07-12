

//
//  HomeView.swift
//  runclub_tut
//
//  Created by Ned hulseman on 1/3/25.
//

import SwiftUI
import MapKit


struct IdentifiableCoordinate: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

@MainActor
class RunTracker: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var isRunning = false
    @Published var presentCountdown = false
    @Published var distance = 0.0
    @Published var pace = 0.0
    @Published var elapsedTime = 0
    @Published var presentRunView = false
    @Published var presentPauseView = false
    @Published var locationPath: [IdentifiableCoordinate] = []

    
    private var timer: Timer?
    
    /*
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 38.9072,
            longitude: -77.0369),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.2)
    )*/
    @Published var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 38.9072, longitude: -77.0369),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.2)
        )
    )
    
    // Location  Tracking
    private var locationManager: CLLocationManager?
    private var startLocation: CLLocation?
    private var lastLocation: CLLocation?
    
    override init() {
        super.init()

        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }
    func startRun() {
        presentRunView = true
        isRunning = true
        startLocation = nil
        lastLocation = nil
        distance = 0.0
        pace = 0.0
        elapsedTime = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {[weak self] _ in
            guard let self else { return }
            self.elapsedTime += 1
            if self.distance > 0 {
                pace = (Double(self.elapsedTime) / 60)  / (self.distance / 1000)
            }
        }
        locationManager?.startUpdatingLocation()

    }
    func stopRun(){
        isRunning = false
        presentRunView = false
        presentPauseView = false
        locationManager?.stopUpdatingLocation()
        timer?.invalidate()
        timer = nil
        postToDatabase()

    }

    func pauseRun(){
        presentPauseView = true
        presentRunView = false
        isRunning = false
        locationManager?.stopUpdatingLocation()
        timer?.invalidate()
    }
    func resumeRun(){
        isRunning = true
        startLocation = nil
        lastLocation = nil
        presentPauseView = false
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
    func postToDatabase() {
        Task {
            do {
                guard let userId = AuthService.shared.currentSession?.user.id else { return }
                let run = RunPayload(createdAt: Date.now, distance: self.distance, pace: self.pace, time: self.elapsedTime, userId: userId, route: ConvertToGeoJson(locations: self.locationPath))
                try await DatabaseService.shared.saveWorkout(run: run)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

}

extension RunTracker {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let newCoord = IdentifiableCoordinate(coordinate: location.coordinate)
        locationPath.append(newCoord)

        // Update the map camera position
        cameraPosition = .region(
            MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        )

        // Handle start location logic
        if startLocation == nil {
            startLocation = location
            lastLocation = location
            return
        }

        // Calculate and accumulate distance
        if let last = lastLocation {
            let delta = location.distance(from: last)
            distance += delta
        }

        // Update the last location
        lastLocation = location
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            // Optionally handle denied permission (e.g., show alert)
            break
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
}
    

func ConvertToGeoJson(locations: [IdentifiableCoordinate]) -> [GeoJson] {
    return locations.map { GeoJson(longitude: $0.coordinate.longitude, latitude: $0.coordinate.latitude)  }
}
    

// fixing warning, using Stack overflow solution
// --> https://stackoverflow.com/questions/73813978/model-updates-trigger-publishing-changes-from-within-view-updates-is-not-allowe
struct AreaMap: View {
    @Binding var cameraPosition: MapCameraPosition
    @ObservedObject var runTracker: RunTracker

    var showPath: Bool

    init(cameraPosition: Binding<MapCameraPosition>, runTracker: RunTracker? = nil) {
        self._cameraPosition = cameraPosition
        
        if let tracker = runTracker {
            self._runTracker = ObservedObject(wrappedValue: tracker)
            self.showPath = true
        } else {
            self._runTracker = ObservedObject(wrappedValue: RunTracker())
            self.showPath = false
        }
    }
    
    
    var body: some View {
        Map(position: $runTracker.cameraPosition) {
            UserAnnotation()
            if showPath {
                //ForEach(runTracker.locationPath) { item in
                //    Marker("", coordinate: item.coordinate)
                //}
            }

            if runTracker.locationPath.count > 1 {
                MapPolyline(coordinates: runTracker.locationPath.map { $0.coordinate })
                    .stroke(.blue, lineWidth: 3)
            }
        }
        .ignoresSafeArea()
    }
}

struct HomeView: View {
    @StateObject var runTracker = RunTracker()
    var body: some View {
        NavigationStack{
            VStack{
                ZStack(alignment: .bottom) {
                    
                    
                    
                    AreaMap(cameraPosition: $runTracker.cameraPosition)
                    
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
            .fullScreenCover(isPresented: $runTracker.presentPauseView, content: {
                PauseView()
                    .environmentObject(runTracker)
            })
        }
    }
}

#Preview {
    HomeView()
}


