

import Foundation
import ObjectMapper

class HomeOptions : Mappable {
	var title = ""
	var icon_url = ""

	required init?(map: Map) {

	}

    func mapping(map: Map) {

		title <- map["title"]
		icon_url <- map["icon_url"]
	}

}
