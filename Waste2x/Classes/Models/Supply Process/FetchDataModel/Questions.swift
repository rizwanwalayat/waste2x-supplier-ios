
import Foundation
import ObjectMapper

struct QuestionsSuppyProcess : Mappable {
	var title = ""
	var options = [OptionsSupplyProcess]()
	var user_input = false

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		title <- map["title"]
		options <- map["options"]
		user_input <- map["user_input"]
	}

}
