

import Foundation
import ObjectMapper

class HomeResultDataModel : Mappable {
	var commodity_farms = [Commodity_farms]()
	var stars_earned = -1
	var stars_redeemed = -1
    var percentage : Double = -1
	var phone = ""
	var waste_type_image = ""
	var waste_type = ""
    var pendingCollection = Bool()
    var farmer_medals : HomeFarmer_medals?
    var waste_type_questions : HomeWaste_type_questions?

	required init?(map: Map) {

	}

    func mapping(map: Map) {

		commodity_farms <- map["commodity_farms"]
		stars_earned <- map["stars_earned"]
		stars_redeemed <- map["stars_redeemed"]
		percentage <- map["percentage"]
		phone <- map["phone"]
		waste_type_image <- map["waste_type_image"]
		waste_type <- map["waste_type"]
		farmer_medals <- map["farmer_medals"]
		waste_type_questions <- map["waste_type_questions"]
        pendingCollection  <- map["pending_collection"]
	}

}
