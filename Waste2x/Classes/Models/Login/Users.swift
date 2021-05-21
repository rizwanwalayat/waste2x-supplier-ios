
import Foundation
import ObjectMapper


class Users : Mappable {
	var error = false
	var message = ""
	var data = Mapper<UserData>().map(JSON: [:])
	var errors = [""]

	required init?(map: Map) { }

    func mapping(map: Map) {

		error   <- map["error"]
		message <- map["message"]
		data    <- map["data"]
		errors  <- map["errors"]
	}
    
    
}
