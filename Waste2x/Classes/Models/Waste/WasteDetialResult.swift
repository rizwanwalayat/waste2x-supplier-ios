

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
	var activities = [String]()

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
	}

}
