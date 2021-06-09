
import Foundation
import ObjectMapper

typealias LoginUserCompletionHandler = (_ data: UserData?, _ error: Error?, _ status: Int?) -> Void
typealias ForgotPasswordCompletionHandler = (_ data: CodeVerification?, _ error: Error?, _ status: Int?) -> Void
typealias RegistrationCompletionHandler = (_ data: AnyObject?, _ error: Error?, _ status: Int?) -> Void
typealias EmailRegistrationCompletionHandler = (_ data: AnyObject?, _ error: Error?, _ status: Int?) -> Void


class UserData : Mappable {
    static var shared = Mapper<UserData>().map(JSON: [:])!
    var user = Mapper<User>().map(JSON: [:])!
    var doneeIdForWithdrawal = -1
    var priceForGuest = 0.0
	var token = ""
	var status = ""

	required init?(map: Map) { }

    func mapping(map: Map) {

		user <- map["user"]
		token <- map["token"]
		status <- map["status"]
	}
    
    class func login(email: String, password: String, _ completion: @escaping LoginUserCompletionHandler) {
    
        APIClient.shared.signInMethod(email: email, password: password) { (result, error, status) in
            Utility.hideLoading()
            
            if error == nil && status != 401{
        
                if let data = Mapper<UserData>().map(JSON: result as! [String : Any]) {
                    DataManager.shared.setUser(user: data.toJSONString() ?? "")
                    completion(data, nil, 200)
                    
                } else {
                    completion(nil, nil, 201)
                }
                
            } else {
                 completion(nil, error, 404)
            }
        }
    }
}
    
//    class func createUser(user: [String: String], _ completion: @escaping LoginUserCompletionHandler) {
//
//        APIClient.shared.createUser(params: user) { (result, error, status) in
//            Utility.hideLoading()
//
//            if error == nil {
//
//                if let data = Mapper<UserData>().map(JSON: result as! [String : Any]) {
//                    DataManager.shared.setUser(user: data.toJSONString() ?? "")
//                    UserData.shared = data
//                    completion(data, nil, 200)
//
//                } else {
//                    completion(nil, nil, 201)
//                }
//
//            } else {
//                 completion(nil, error, 404)
//            }
//        }
//    }
    
//    class func forgotPassword(email: String, _ completion: @escaping ForgotPasswordCompletionHandler) {
//
//        Utility.showLoading()
//        APIClient.shared.forgotPasswordMethod(email: email) { (result, error, status) in
//            Utility.hideLoading()
//
//
//            if error == nil {
//
//                if let data = result as AnyObject? {
//                    completion(data, nil, 200)
//
//                } else {
//                    completion(nil, nil, 201)
//                }
//
//            } else {
//                 completion(nil, error, 404)
//            }
//        }
//    }
//}
