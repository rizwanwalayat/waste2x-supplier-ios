
import Foundation
import ObjectMapper

class UserDetailDataModel : Mappable {
	var success = false
    var message = ""
    var result : UserDetailResult?

	required init?(map: Map) {

	}

	func mapping(map: Map) {

		success <- map["success"]
		result <- map["result"]
		message <- map["message"]
	}

}


class UserDetailResult : Mappable {
    var name = ""
    var phone = ""
    var image = ""
    var email = ""

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        name <- map["name"]
        phone <- map["phone"]
        image <- map["image"]
        email <- map["email"]
    }

}


//MARK: - SingltonClass for User Detail
class UserDetial: NSObject {
    
    static var shared = UserDetial()
    
    var name = ""
    var phone = ""
    var email = ""
    var image = ""
    
    override init() {
        super.init()
    }
    
    func saveNewValues(_ userName: String, _ userPhone: String, _ userEmail: String, _ userImage: String) {
        self.name = userName
        self.image = userImage
        self.email = userEmail
        self.phone = userPhone
    }
}
