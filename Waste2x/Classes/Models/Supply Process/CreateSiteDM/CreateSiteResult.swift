
import Foundation
import ObjectMapper

class ResultSiteCreation : Mappable {
    var farmName = ""
	var user = -1
	var waste_id = -1
	var farmer_medals = ""
	var stars_earned = -1
	var stars_redeemed = -1
    var percentage = 0.0

	required init?(map: Map) {

	}

	func mapping(map: Map) {

        farmName <- map["farm_name"]
		user <- map["user"]
		waste_id <- map["farm_id"]
		farmer_medals <- map["farmer_medals"]
		stars_earned <- map["stars_earned"]
		stars_redeemed <- map["stars_redeemed"]
		percentage <- map["percentage"]
        if waste_id == -1{
            waste_id <- map["waste_id"]
        }
	}

}
