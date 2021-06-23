

import Foundation
import ObjectMapper

struct MessageResult : Mappable {
	var access_token : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		access_token <- map["access_token"]
	}

}
