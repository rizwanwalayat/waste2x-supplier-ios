

import Foundation
import ObjectMapper

class HomeWaste_type_questions : Mappable {
	var waste_types : [HomeWaste_types]?

	required init?(map: Map) {

	}

    func mapping(map: Map) {

		waste_types <- map["waste_types"]
	}

}
