

import Foundation
import ObjectMapper

class Commodity_farms : Mappable {
	var crop_type : String?
	var crop_type_id : Int?
	var crop_type_image : String?
	var farms : [HomeFarms]?

	required init?(map: Map) {

	}

    func mapping(map: Map) {

		crop_type <- map["crop_type"]
		crop_type_id <- map["crop_type_id"]
		crop_type_image <- map["crop_type_image"]
		farms <- map["farms"]
	}

}
