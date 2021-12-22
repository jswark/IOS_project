import UIKit
import MapKit

class FishingDetailsViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  
  var run: Fishing!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }


  private func configureView() {
    let distance = Measurement(value: run.distance, unit: UnitLength.meters)
    let seconds = Int(run.duration)
    let formattedDistance = FormatDisplay.distance(distance)
    let formattedDate = FormatDisplay.date(run.timestamp)
    let formattedTime = FormatDisplay.time(seconds)
    
    distanceLabel.text = "Distance:  \(formattedDistance)"
    dateLabel.text = formattedDate
    timeLabel.text = "Time:  \(formattedTime)"
    locationLabel.text = "Location:  \(run.location!)"
    
    loadMap()
  }
  
  private func mapRegion() -> MKCoordinateRegion? {
    guard
      let locations = run.locations,
      locations.count > 0
    else {
      return nil
    }
    
    let latitudes = locations.map { location -> Double in
      let location = location as! Location
      return location.latitude
    }
    
    let longitudes = locations.map { location -> Double in
      let location = location as! Location
      return location.longitude
    }
    
    let maxLat = latitudes.max()!
    let minLat = latitudes.min()!
    let maxLong = longitudes.max()!
    let minLong = longitudes.min()!
    
    let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                        longitude: (minLong + maxLong) / 2)
    let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3,
                                longitudeDelta: (maxLong - minLong) * 1.3)
    return MKCoordinateRegion(center: center, span: span)
  }
  

  
  private func loadMap() {
    guard
      let locations = run.locations,
      locations.count > 0,
      let region = mapRegion()
    else {
        let alert = UIAlertController(title: "Error",
                                      message: "Sorry, this run has no locations saved",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
        return
    }
    
    mapView.setRegion(region, animated: true)
    mapView.addAnnotations(annotations())
  }
  
  private func annotations() -> [FishingAnnotation] {
    var annotations: [FishingAnnotation] = []
    let locations = run.locations?.array as! [Location]
    var distance = 0.0
    
    for (first, second) in zip(locations, locations.dropFirst()) {
      let start = CLLocation(latitude: first.latitude, longitude: first.longitude)
      let end = CLLocation(latitude: second.latitude, longitude: second.longitude)
      distance += end.distance(from: start)
      let badgeAnnotation = FishingAnnotation(imageName: "fish")
      badgeAnnotation.coordinate = end.coordinate
      badgeAnnotation.title = run.location
      annotations.append(badgeAnnotation)
      break
    }
    
    return annotations
  }
}

// MARK: - Map View Delegate

extension FishingDetailsViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let annotation = annotation as? FishingAnnotation else { return nil }
    let reuseID = "checkpoint"
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
    if annotationView == nil {
      annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
      annotationView?.image = #imageLiteral(resourceName: "mapPin")
      annotationView?.canShowCallout = true
    }
    annotationView?.annotation = annotation
    
    let badgeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    badgeImageView.image = UIImage(named: annotation.imageName)
    badgeImageView.contentMode = .scaleAspectFit
    annotationView?.leftCalloutAccessoryView = badgeImageView
    
    return annotationView
  }
}
