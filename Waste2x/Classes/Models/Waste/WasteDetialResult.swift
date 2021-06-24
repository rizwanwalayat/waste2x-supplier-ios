

import Foundation
import ObjectMapper

class WasteDetialResult : Mappable
{
	var farm_id = -1
	var farm_name = ""
	var commodity = ""
	var commodity_image = ""
	var farm_size = -1
	var address = ""
	var activities = [WasteDetailActivities]()
    var latitude = Double()
    var longitude = Double()

	required init?(map: Map) {

	}

	func mapping(map: Map) {

		farm_id <- map["farm_id"]
		farm_name <- map["farm_name"]
		commodity <- map["commodity"]
		commodity_image <- map["commodity_image"]
		farm_size <- map["farm_size"]
		address <- map["address"]
		activities <- map["activities"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
	}

}

class WasteDetailActivities : Mappable {
    var address = ""
    var image = ""
    var timestamp = ""

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        address <- map["address"]
        image <- map["image"]
        timestamp <- map["timestamp"]
    }
}


class ImagesCollectionViewData : NSObject
{
    var image = UIImage()
    var time = ""
    
    override init() {
        super.init()
    }
    init(_ image : UIImage, _ time : String) {
        self.image = image
        self.time = time
    }
}


