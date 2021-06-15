

import Foundation
import ObjectMapper

class HomeQuestions : Mappable {
	var title = ""
	var options : [HomeOptions]?
	var user_input = false

	required init?(map: Map) {

	}

    func mapping(map: Map) {

		title <- map["title"]
		options <- map["options"]
		user_input <- map["user_input"]
	}

}
