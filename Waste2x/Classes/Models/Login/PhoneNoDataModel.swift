

import Foundation
import ObjectMapper

typealias phoneNoCompletionHandler = (_ data: PhoneNoDataModel?, _ error: Error?, _ status: Int?) -> Void


class PhoneNoDataModel : Mappable {
	var success : Bool?
	var status_code : Int?
	var message : String?
	var result : Result?

	required init?(map: Map) {

	}

    func mapping(map: Map) {

		success <- map["success"]
		status_code <- map["status_code"]
		message <- map["message"]
		result <- map["result"]
	}
}

class Result : Mappable {
    var code : Int?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        code <- map["code"]
    }

}
