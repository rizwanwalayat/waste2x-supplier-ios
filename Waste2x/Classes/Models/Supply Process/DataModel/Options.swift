
import Foundation
import ObjectMapper

struct Options : Mappable {
	var title : String?
	var icon_url : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		title <- map["title"]
		icon_url <- map["icon_url"]
	}

}
