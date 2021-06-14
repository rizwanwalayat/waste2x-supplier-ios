
import Foundation
import ObjectMapper

struct OptionsSupplyProcess : Mappable {
	var title = ""
	var icon_url = ""

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		title <- map["title"]
		icon_url <- map["icon_url"]
	}

}
