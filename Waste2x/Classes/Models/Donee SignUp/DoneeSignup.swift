
import Foundation
import ObjectMapper

typealias DoneeSignUPCompletionHandler = (_ data: DoneeSignUp?, _ error: Error?, _ status: Int?) -> Void

class DoneeSignUp : Mappable {
	var message  = ""

	required init?(map: Map) { }

    func mapping(map: Map) {

		message <- map["message"]
	}
}
