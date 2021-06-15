

import Foundation
import ObjectMapper

class HomeFarms : Mappable {
	var id = -1
	var name = ""

	required init?(map: Map) {

	}

    func mapping(map: Map) {

		id <- map["id"]
		name <- map["name"]
	}

}
