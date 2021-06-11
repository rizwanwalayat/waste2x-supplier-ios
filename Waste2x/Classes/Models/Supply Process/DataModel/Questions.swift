
import Foundation
import ObjectMapper

struct Questions : Mappable {
	var title : String?
	var options : [Options]?
	var user_input : Bool?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		title <- map["title"]
		options <- map["options"]
		user_input <- map["user_input"]
	}

}
