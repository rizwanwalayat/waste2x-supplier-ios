
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
    let headers = ["Authorization": "token " + (DataManager.shared.getUser()?.result?.auth_token ?? "")]
    
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
    
    func verificationCode(number: String, _ completionBlock: @escaping APIClientCompletionHandler) {
        let params = ["phone": number] as [String:String]
        _ = sendRequest(APIRoutes.login , parameters: params as [String : AnyObject],httpMethod: .post , headers: nil, completionBlock: completionBlock)
    }
    func weatherAPi( _ completionBlock: @escaping APIClientCompletionHandler) {
        let params = [String:AnyObject]()
        print("WeatherAPI",APIRoutes.weatherAPi)
        rawRequest(url: APIRoutes.weatherAPi, method: .get, parameters: params, headers: nil, completionBlock: completionBlock)
    }
    func NewsApiCall(_ completionBlock: @escaping APIClientCompletionHandler) {
        let params = [String : AnyObject]()
        _ = sendRequest(APIRoutes.newsUrl, parameters: params,httpMethod: .get , headers: headers, completionBlock: completionBlock)
    }
    
    func emailVerification(email: String, _ completionBlock: @escaping APIClientCompletionHandler) {
        let params = ["email": email] as [String:String]
        _ = sendRequest(APIRoutes.emailVerification , parameters: params as [String : AnyObject],httpMethod: .post , headers: nil, completionBlock: completionBlock)
    }
    
    func userRegistration(phone: String,code: String,latitude: Double,longitude: Double,firebase_token: String,phone_imei: Int,phone_os: String,phone_model: String, _ completionBlock: @escaping APIClientCompletionHandler) {
        let params = ["phone":phone,"code":code,"latitude":latitude,"longitude":longitude,"firebase_token":firebase_token,"phone_imei":phone_imei,"phone_os":phone_os,"phone_model":phone_model] as [String:Any]
        _ = sendRequest(APIRoutes.registration , parameters: params as [String : AnyObject],httpMethod: .post , headers: nil, completionBlock: completionBlock)
    }
    
    // NH : for fetch data for supply process
    
    func fetchSupplyProcessData(_ completionBlock: @escaping APIClientCompletionHandler) {
//
//        let headers = ["Authorization": "token " + (DataManager.shared.getUser()?.result?.auth_token ?? "")]// + Global.shared.tok]
        _ = sendRequest(APIRoutes.fetchSupplyProcessData , parameters: nil ,httpMethod: .get , headers: headers, completionBlock: completionBlock)
    }
    
    func postSupplyProcessData(params : [String: AnyObject], _ completionBlock: @escaping APIClientCompletionHandler) {
        
        
        
        DataManager.shared.getUser()?.result?.isNewUser ?? true ? (_ = sendRequest(APIRoutes.postSupplyProcessDataNewUser , parameters: params ,httpMethod: .post , headers: headers, completionBlock: completionBlock)) : (_ = sendRequest(APIRoutes.postSupplyProcessDataUser , parameters: params ,httpMethod: .post , headers: headers, completionBlock: completionBlock))
    }
    
    func fetchSitesForHomeData(_ completionBlock: @escaping APIClientCompletionHandler)
    {
        let headers = ["Authorization": "token " + (DataManager.shared.getUser()?.result?.auth_token ?? "")]
        _ = sendRequest(APIRoutes.fetchSitesHomeProcessDataUser , parameters: nil ,httpMethod: .get , headers: headers, completionBlock: completionBlock)
    }
}

