import Foundation

struct FishingsData {
  let currentFishing: Fishing?
  let distance: Double?
  let location: String?
  
  static func badgesEarned(runs: [Fishing]) -> [FishingsData] {
      var badgeArray: [FishingsData] = []
      var curRun: Fishing?
      var dist: Double?
      var locat: String?
      
      for run in runs {
         if curRun == nil {
          curRun = run
        }
       
        let distance = run.distance
        let location = run.location
        
        dist = distance
        locat = location
        
        let newBadge = FishingsData(currentFishing: curRun, distance: dist, location: locat)
        
        badgeArray.append(newBadge)
      }
      
      return badgeArray
    }
}

