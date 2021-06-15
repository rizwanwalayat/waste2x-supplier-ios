

import Foundation
import ObjectMapper

class HomeWaste_types : Mappable {
	var title : String?
	var icon_url : String?
	var share_icon_url : String?
	var questions : [HomeQuestions]?

	required init?(map: Map) {

	}

    func mapping(map: Map) {

		title <- map["title"]
		icon_url <- map["icon_url"]
		share_icon_url <- map["share_icon_url"]
		questions <- map["questions"]
	}

}
