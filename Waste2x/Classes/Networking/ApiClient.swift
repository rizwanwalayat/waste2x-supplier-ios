
import UIKit
import Alamofire
import ObjectMapper


class Connectivity {
    
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

let APIClientDefaultTimeOut = 40.0

class APIClient: APIClientHandler {
    
    fileprivate var clientDateFormatter: DateFormatter
    var isConnectedToNetwork: Bool?
    
    static var shared: APIClient = {
        let baseURL = URL(fileURLWithPath: APIRoutes.baseUrl)
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = APIClientDefaultTimeOut
        
        let instance = APIClient(baseURL: baseURL, configuration: configuration)
        
        return instance
    }()
    
    // MARK: - init methods
    
    override init(baseURL: URL, configuration: URLSessionConfiguration, delegate: SessionDelegate = SessionDelegate(), serverTrustPolicyManager: ServerTrustPolicyManager? = nil) {
        clientDateFormatter = DateFormatter()
        
        super.init(baseURL: baseURL, configuration: configuration, delegate: delegate, serverTrustPolicyManager: serverTrustPolicyManager)
        
        //        clientDateFormatter.timeZone = NSTimeZone(name: "UTC")
        clientDateFormatter.dateFormat = "yyyy-MM-dd" // Change it to desired date format to be used in All Apis
    }
    
    
    // MARK: Helper methods
    
    func apiClientDateFormatter() -> DateFormatter {
        return clientDateFormatter.copy() as! DateFormatter
    }
    
    fileprivate func normalizeString(_ value: AnyObject?) -> String {
        return value == nil ? "" : value as! String
    }
    
    fileprivate func normalizeDate(_ date: Date?) -> String {
        return date == nil ? "" : clientDateFormatter.string(from: date!)
    }
    
    var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    func getUrlFromParam(apiUrl: String, params: [String: AnyObject]) -> String {
        var url = apiUrl + "?"
        
        for (key, value) in params {
            url = url + key + "=" + "\(value)&"
        }
        url.removeLast()
        return url
    }
    
    // MARK: - Onboarding
    func signInMethod(email: String , password: String, _ completionBlock: @escaping APIClientCompletionHandler) {
        let params = ["email": email, "password": password] as [String:String]
        _ = sendRequest(APIRoutes.login , parameters: params as [String : AnyObject],httpMethod: .post , headers: nil, completionBlock: completionBlock)
    }
    
    func verificationCode(number: String, _ completionBlock: @escaping APIClientCompletionHandler) {
        let params = ["phone": number] as [String:String]
        _ = sendRequest(APIRoutes.login , parameters: params as [String : AnyObject],httpMethod: .post , headers: nil, completionBlock: completionBlock)
    }
    func weatherAPi( _ completionBlock: @escaping APIClientCompletionHandler) {
        let params = [String:AnyObject]()
        print(APIRoutes.weatherAPi)
        
        rawRequest(url: APIRoutes.weatherAPi, method: .get, parameters: params, headers: nil, completionBlock: completionBlock)
    }
    
    func emailVerification(email: String, _ completionBlock: @escaping APIClientCompletionHandler) {
        let params = ["email": email] as [String:String]
        _ = sendRequest(APIRoutes.emailVerification , parameters: params as [String : AnyObject],httpMethod: .post , headers: nil, completionBlock: completionBlock)
    }
    
    func userRegistration(phone: String,code: String,latitude: Double,longitude: Double,firebase_token: String,phone_imei: Int,phone_os: String,phone_model: String, _ completionBlock: @escaping APIClientCompletionHandler) {
        let params = ["phone":phone,"code":code,"latitude":latitude,"longitude":longitude,"firebase_token":firebase_token,"phone_imei":phone_imei,"phone_os":phone_os,"phone_model":phone_model] as [String:Any]
        _ = sendRequest(APIRoutes.registration , parameters: params as [String : AnyObject],httpMethod: .post , headers: nil, completionBlock: completionBlock)
    }
    
    
    func createUser(params: [String: String],_ completionBlock: @escaping APIClientCompletionHandler) {
        _ = sendRequest(APIRoutes.createUser , parameters: params as [String : AnyObject],httpMethod: .post , headers: nil, completionBlock: completionBlock)
    }
    
    func createUser2(params: [String: String], avs: String ,_ completionBlock: @escaping APIClientCompletionHandler) {
        _ = sendRequest(APIRoutes.createUser , parameters: params as [String : AnyObject],httpMethod: .post , headers: nil, completionBlock: completionBlock)
    }
    
    func forgotPasswordMethod(email: String, _ completionBlock: @escaping APIClientCompletionHandler) {
        let params = ["email_id": email, "base_url": "https://doro.codesorbit.com/home"]
        _ = sendRequest(APIRoutes.forgotPassword , parameters: params as [String : AnyObject],httpMethod: .post , headers: nil, completionBlock: completionBlock)
    }
    
    func updateUser(params: [String: String],_ completionBlock: @escaping APIClientCompletionHandler) {
        _ = sendRequest(APIRoutes.updateUser , parameters: params as [String : AnyObject],httpMethod: .put , headers: nil, completionBlock: completionBlock)
    }
    
//    func updateUserProfile(image: UIImage, name: String, email: String, phoneNo: String, nationalId: String, ssn: String, occupation: String, type: Int, _ completionBlock: @escaping APIClientCompletionHandler) {
//        let headers = ["Authorization": "Bearer "+DataManager.shared.getUser()!.token]
//        let params = ["image": image, "full_name": name, "email": email, "phone_number": phoneNo, "national_id": nationalId, "social_security_number": ssn, "occupation": occupation ,"type": type] as [String : Any]
//        sendRequestUsingMultipart(APIRoutes.baseUrl+APIRoutes.updateUser, parameters: params as [String : AnyObject] , httpMethod: .put, headers: headers, completionBlock: completionBlock)
//    }
    func updateUserProfile(image: UIImage, name: String, email: String, phoneNo: String, nationalId: String, ssn: String, occupation: String, type: Int, _ completionBlock: @escaping APIClientCompletionHandler) {
        let headers = ["Authorization": "Bearer "+DataManager.shared.getUser()!.token]
        let params = ["image": image, "full_name": name, "email": email, "phone_number": phoneNo, "national_id": nationalId, "social_security_number": ssn, "occupation": occupation ,"type": type] as [String : Any]
        sendRequestUsingMultipart(APIRoutes.baseUrl+APIRoutes.updateUser, parameters: params as [String : AnyObject] , httpMethod: .put, headers: headers, completionBlock: completionBlock)
    }
    
    
    // NH : for fetch data for supply process
    
    func fetchSupplyProcessData(_ completionBlock: @escaping APIClientCompletionHandler) {
        
        let headers = ["Authorization": "token b94662d8340a0c3d56c829a1d0902a96efe88be7"]// + Global.shared.tok]
        _ = sendRequest(APIRoutes.fetchSupplyProcessData , parameters: nil ,httpMethod: .get , headers: headers, completionBlock: completionBlock)
    }
    
    func postSupplyProcessData(params : [String: AnyObject], _ completionBlock: @escaping APIClientCompletionHandler) {
        
        let headers = ["Authorization": "token b94662d8340a0c3d56c829a1d0902a96efe88be7"]
        _ = sendRequest(APIRoutes.postSupplyProcessDataNewUser , parameters: params ,httpMethod: .post , headers: headers, completionBlock: completionBlock)
    }
}

