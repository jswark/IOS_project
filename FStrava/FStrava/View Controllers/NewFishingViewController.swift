import UIKit
import CoreLocation
import MapKit
import AVFoundation

class NewFishingViewController: UIViewController {
  
  @IBOutlet weak var launchPromptStackView: UIStackView!
  @IBOutlet weak var dataStackView: UIStackView!
  @IBOutlet weak var startButton: UIButton!
  @IBOutlet weak var stopButton: UIButton!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var mapContainerView: UIView!
  @IBOutlet weak var mapView: MKMapView!
  
  private var run: Fishing?
  private let locationManager = LocationManager.shared.manager
  private var seconds = 0
  private var timer: Timer?
  private var distance = Measurement(value: 0, unit: UnitLength.meters)
  private var locationList: [CLLocation] = []
  private var curLocation: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    dataStackView.isHidden = true
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    timer?.invalidate()
    locationManager.stopUpdatingLocation()
  }
  
  @IBAction func startTapped() {
    startRun()
  }
  
  @IBAction func stopTapped() {
    let alertController = UIAlertController(title: "End fishing?",
                                            message: "Do you wish to end your fishing?",
                                            preferredStyle: .actionSheet)
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
      self.stopRun()
      self.saveRun()
      self.performSegue(withIdentifier: .details, sender: nil)
    })
    alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
      self.stopRun()
      _ = self.navigationController?.popToRootViewController(animated: true)
    })
    
    present(alertController, animated: true)
  }
  
  private func startRun() {
    launchPromptStackView.isHidden = true
    dataStackView.isHidden = false
    startButton.isHidden = true
    stopButton.isHidden = false
    mapContainerView.isHidden = false
    mapView.removeOverlays(mapView.overlays)
    
    seconds = 0
    distance = Measurement(value: 0, unit: UnitLength.meters)
    locationList.removeAll()
    updateDisplay()
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
      self.eachSecond()
    }
    startLocationUpdates()
  }
  
  private func stopRun() {
    launchPromptStackView.isHidden = false
    dataStackView.isHidden = true
    startButton.isHidden = false
    stopButton.isHidden = true
    mapContainerView.isHidden = true
  
    locationManager.stopUpdatingLocation()
  }
  
  func eachSecond() {
    seconds += 1
    updateDisplay()
  }
  
  private func updateDisplay() {
    let formattedDistance = FormatDisplay.distance(distance)
    let formattedTime = FormatDisplay.time(seconds)
    
    distanceLabel.text = "Distance:  \(formattedDistance)"
    timeLabel.text = "Time:  \(formattedTime)"
    locationLabel.text = curLocation != nil ? "Location: \(curLocation!)" : ""
  }
  
  private func startLocationUpdates() {
    locationManager.delegate = self
    locationManager.activityType = .fitness
    locationManager.distanceFilter = 10
    locationManager.startUpdatingLocation()
  }
  
  private func saveRun() {
    let newRun = Fishing(context: CoreDataStack.context)
    newRun.distance = distance.value
    newRun.duration = Int16(seconds)
    newRun.timestamp = Date()
    newRun.location = curLocation!
    
    for location in locationList {
      let locationObject = Location(context: CoreDataStack.context)
      locationObject.timestamp = location.timestamp
      locationObject.latitude = location.coordinate.latitude
      locationObject.longitude = location.coordinate.longitude
      newRun.location = curLocation!
      newRun.addToLocations(locationObject)
    }
    
    CoreDataStack.saveContext()

    run = newRun
  }
}

// MARK: - Navigation

extension NewFishingViewController: SegueHandlerType {
  enum SegueIdentifier: String {
    case details = "RunDetailsViewController"
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segueIdentifier(for: segue) {
    case .details:
      let destination = segue.destination as! FishingDetailsViewController
      destination.run = run
    }
  }
}

// MARK: - Location Manager Delegate

extension NewFishingViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    for newLocation in locations {
      let howRecent = newLocation.timestamp.timeIntervalSinceNow
      guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
      
      if let lastLocation = locationList.last {
        LocationManager.shared.resolveLocationName(with: lastLocation)
        curLocation =  LocationManager.shared.locationName != nil ? LocationManager.shared.locationName! : ""
        
        let delta = newLocation.distance(from: lastLocation)
        distance = distance + Measurement(value: delta, unit: UnitLength.meters)
        let coordinates = [lastLocation.coordinate, newLocation.coordinate]
        mapView.add(MKPolyline(coordinates: coordinates, count: 2))
        let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500)
        mapView.setRegion(region, animated: true)
      }
      
      locationList.append(newLocation)
    }
  }
}

// MARK: - Map View Delegate

extension NewFishingViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    guard let polyline = overlay as? MKPolyline else {
      return MKOverlayRenderer(overlay: overlay)
    }
    let renderer = MKPolylineRenderer(polyline: polyline)
    renderer.strokeColor = .blue
    renderer.lineWidth = 3
    return renderer
  }
}
