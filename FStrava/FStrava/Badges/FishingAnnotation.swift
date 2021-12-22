import MapKit

class FishingAnnotation: MKPointAnnotation {
  let imageName: String
  
  init(imageName: String) {
    self.imageName = imageName
    super.init()
  }
}
