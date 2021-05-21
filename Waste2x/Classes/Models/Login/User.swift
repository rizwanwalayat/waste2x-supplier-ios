
import Foundation
import ObjectMapper

class User : Mappable {
    var id = -1
    var fullName = ""
    var email = ""
    var phoneNumber = ""
    var paypalEmail = ""
    var nationalId = ""
    var socialSecurityNumber = -1
    var occupation = ""
    var paymentMethod = ""
    var userType = ""
    var imageUrl = ""
    var createdAt = ""
    var updatedAt = ""
    var stripeCustId = ""
    var stripeEmail = ""
    var defaultPaymentGateway = ""
    var userStatus = "ACTIVE"

	required init?(map: Map) { }

    func mapping(map: Map) {

        id                  <- map["id"]
        fullName            <- map["full_name"]
        email               <- map["email"]
        phoneNumber         <- map["phone_number"]
        paypalEmail         <- map["paypal_email"]
        nationalId          <- map["national_id"]
        socialSecurityNumber <- map["social_security_number"]
        occupation          <- map["occupation"]
        paymentMethod       <- map["payment_method"]
        userType            <- map["user_type"]
        imageUrl            <- map["image_url"]
        createdAt           <- map["created_at"]
        updatedAt           <- map["updated_at"]
        stripeCustId        <- map["stripe_cust_id"]
        stripeEmail         <- map["stripe_email"]
        defaultPaymentGateway <- map["payment_method"]
	}
}
