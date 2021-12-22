import CoreLocation
import Foundation

class LocationManager: NSObject, CLLocationManagerDelegate{
  static let shared = LocationManager()
  
  let manager = CLLocationManager()
  
  var completion: ((CLLocation) -> Void)?
  var locationName: String?
  
  public func getUserLocation(completion: (CLLocation) -> Void) {
      manager.requestWhenInUseAuthorization()
      manager.delegate = self
      manager.startUpdatingLocation()
  }
  
  public func resolveLocationName(with location: CLLocation) {
      let geocoder = CLGeocoder()
      var name = ""
    
      geocoder.reverseGeocodeLocation(location, preferredLocale: .current) { placemarks, error in
          guard let place = placemarks?.first, error == nil else {
              return
          }
          name = place.name ?? "Unknown"
          self.locationName = name
      }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      guard let location = locations.first else { return }
      completion?(location)
  }
}
