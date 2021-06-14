

import Foundation
import ObjectMapper

struct SupplyProcessResponse : Mappable {
	var title = ""
	var icon_url = ""
	var share_icon_url = ""
	var questions = [QuestionsSuppyProcess]()

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		title <- map["title"]
		icon_url <- map["icon_url"]
		share_icon_url <- map["share_icon_url"]
		questions <- map["questions"]
	}

}
