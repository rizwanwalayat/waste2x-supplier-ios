
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
//    let headers = ["Authorization": "token " + (DataManager.shared.getUser()?.result?.auth_token ?? "")]
    
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
        
        let headers = ["Cookie": ""]
        _ = sendRequest(APIRoutes.login , parameters: params as [String : AnyObject],httpMethod: .post , headers: headers, completionBlock: completionBlock)
    }
    func weatherAPi( _ completionBlock: @escaping APIClientCompletionHandler) {
        let params = [String:AnyObject]()
        print("WeatherAPI",APIRoutes.weatherAPi)
        print("Weather one call api",APIRoutes.weatherAPi)
        rawRequest(url: APIRoutes.weatherAPi, method: .get, parameters: params, headers: nil, completionBlock: completionBlock)
    }
    func googleLocationPolyLineAPi( _ completionBlock: @escaping APIClientCompletionHandler) {
        let params = [String:AnyObject]()
        print("WeatherAPI",APIRoutes.weatherAPi)
        rawRequest(url: APIRoutes.polyLineUrl, method: .get, parameters: params, headers: nil, completionBlock: completionBlock)
    }
    func NewsApiCall(_ completionBlock: @escaping APIClientCompletionHandler) {
        let params = [String : AnyObject]()
        let headers = ["Authorization": "token " + (DataManager.shared.getUser()?.result?.auth_token ?? "")]
        _ = sendRequest(APIRoutes.newsUrl, parameters: params,httpMethod: .get , headers: headers, completionBlock: completionBlock)
    }
    func PaymentApiCall(_ completionBlock: @escaping APIClientCompletionHandler) {
        let params = [String : AnyObject]()
        let headers = ["Authorization": "token " + (DataManager.shared.getUser()?.result?.auth_token ?? "")]
        _ = sendRequest(APIRoutes.paymentUrl, parameters: params,httpMethod: .get , headers: headers, completionBlock: completionBlock)
    }
    func createPaymentApiCall(_ completionBlock: @escaping APIClientCompletionHandler) {
        let params = [String : AnyObject]()
        let headers = ["Authorization": "token " + (DataManager.shared.getUser()?.result?.auth_token ?? "")]
        _ = sendRequest(APIRoutes.createPaymentUrl, parameters: params,httpMethod: .get , headers: headers, completionBlock: completionBlock)
    }
    func notificationApiCall(_ completionBlock: @escaping APIClientCompletionHandler) {
        
        let params = [String : AnyObject]()
        let headers = ["Authorization": "token " + (DataManager.shared.getUser()?.result?.auth_token ?? "")]
        _ = sendRequest(APIRoutes.notificationUrl, parameters: params,httpMethod: .get , headers: headers, completionBlock: completionBlock)
    }
    func notifiationResponceApiCall(id: Int,responce:String, _ completionBlock: @escaping APIClientCompletionHandler) {
        let headers = ["Authorization": "token " + (DataManager.shared.getUser()?.result?.auth_token ?? "")]
        let params = ["notification_id": id,"response":responce] as [String:AnyObject]
        _ = sendRequest(APIRoutes.notificationResponceUrl , parameters: params as [String : AnyObject],httpMethod: .post , headers: headers, completionBlock: completionBlock)
    }
    func pendingResponceApiCall(id: Int,_ completionBlock: @escaping APIClientCompletionHandler) {
        let headers = ["Authorization": "token " + (DataManager.shared.getUser()?.result?.auth_token ?? "")]
        let params = ["pending_collection_id": id] as [String:AnyObject]
        _ = sendRequest(APIRoutes.pendingDetailUrl , parameters: params as [String : AnyObject],httpMethod: .post , headers: headers, completionBlock: completionBlock)
    }
    
    
    func emailVerification(email: String, _ completionBlock: @escaping APIClientCompletionHandler) {
        let params = ["email": email] as [String:String]
        
        let headers = ["Cookie": ""]
        _ = sendRequest(APIRoutes.emailVerification , parameters: params as [String : AnyObject],httpMethod: .post , headers: headers, completionBlock: completionBlock)
    }
    func FaqApiFunctionCall(_ completionBlock: @escaping APIClientCompletionHandler) {
        let headers = ["Authorization": "token " + (DataManager.shared.getUser()?.result?.auth_token ?? "")]
        _ = sendRequest(APIRoutes.faqUrl , parameters: nil ,httpMethod: .get , headers: headers, completionBlock: completionBlock)
    }
    func pendingCollectionApiFunctionCall(_ completionBlock: @escaping APIClientCompletionHandler) {
        let headers = ["Authorization": "token " + (DataManager.shared.getUser()?.result?.auth_token ?? "")]
        _ = sendRequest(APIRoutes.pendingCollectionFetchUrl , parameters: nil ,httpMethod: .get , headers: headers, completionBlock: completionBlock)
    }
    func contactFetchApiFunctionCall(_ completionBlock: @escaping APIClientCompletionHandler) {
        let headers = ["Authorization": "token " + (DataManager.shared.getUser()?.result?.auth_token ?? "")]
        _ = sendRequest(APIRoutes.contacFetchUrl , parameters: nil ,httpMethod: .get , headers: headers, completionBlock: completionBlock)
    }
    func contactSendApiFunctionCall(name: String,number: String, _ completionBlock: @escaping APIClientCompletionHandler) {
        let headers = ["Authorization": "token " + (DataManager.shared.getUser()?.result?.auth_token ?? "")]
        let params = ["contact_name":name,"contact_number":number] as [String:Any]
        _ = sendRequest(APIRoutes.contacSendUrl , parameters: params as [String : AnyObject],httpMethod: .post , headers: headers, completionBlock: completionBlock)
    }
    func deleteSiteApiFunctionCall(id: Int, resone: String, _ completionBlock: @escaping APIClientCompletionHandler) {
        let headers = ["Authorization": "token " + (DataManager.shared.getUser()?.result?.auth_token ?? "")]
        let params = ["farm_id":id,"reason":resone] as [String:Any]
        _ = sendRequest(APIRoutes.siteDeleteSendUrl , parameters: params as [String : AnyObject],httpMethod: .post , headers: headers, completionBlock: completionBlock)
    }
    
    
    func userRegistration(phone: String,code: String,latitude: Double,longitude: Double,firebase_token: String,phone_imei: String,phone_os: String,phone_model: String, _ completionBlock: @escaping APIClientCompletionHandler) {
        
        let params = ["phone":phone,"code":code,"latitude":latitude,"longitude":longitude,"firebase_token":firebase_token,"phone_imei":phone_imei,"phone_os":phone_os,"phone_model":phone_model] as [String:Any]
        
        let headers = ["Cookie": ""]
        _ = sendRequest(APIRoutes.registration , parameters: params as [String : AnyObject],httpMethod: .post , headers: headers, completionBlock: completionBlock)
    }
    
    // NH : for fetch data for supply process
    
    func fetchSupplyProcessData(_ completionBlock: @escaping APIClientCompletionHandler) {
//
        let headers = ["Authorization": "token " + (DataManager.shared.getUser()?.result?.auth_token ?? "")]
        print("postSupplyProcessData : \(headers)")
        _ = sendRequest(APIRoutes.fetchSupplyProcessData , parameters: nil ,httpMethod: .get , headers: headers, completionBlock: completionBlock)
    }
    
    func postSupplyProcessData(params : [String: AnyObject], _ completionBlock: @escaping APIClientCompletionHandler) {
        
        
        let headers = ["Authorization": "token " + (DataManager.shared.getUser()?.result?.auth_token ?? "")]
        print("postSupplyProcessData : \(headers)")
        var API = ""
        if Global.shared.apiCurve{
            
            API = APIRoutes.postSupplyProcessDataUser
        }
        else{
            API = APIRoutes.postSupplyProcessDataNewUser
        }
        (_ = sendRequest(API , parameters: params ,httpMethod: .post , headers: headers, completionBlock: completionBlock))
    }
    
    func fetchSitesForHomeData(_ completionBlock: @escaping APIClientCompletionHandler)
    {
        let headers = ["Authorization": "token " + (DataManager.shared.getUser()?.result?.auth_token ?? "")]
        print("fetchSitesForHomeData : \(headers)")
        _ = sendRequest(APIRoutes.fetchSitesHomeProcessDataUser , parameters: nil ,httpMethod: .get , headers: headers, completionBlock: completionBlock)
    }
    
    func postPickupScheduleData(params : [String: AnyObject], _ completionBlock: @escaping APIClientCompletionHandler)
    {
        let headers = ["Authorization": "token " + (DataManager.shared.getUser()?.result?.auth_token ?? "")]
        print("postPickupScheduleData : \(headers)")
        _ = sendRequest(APIRoutes.pickupSchedulePostData , parameters: params ,httpMethod: .post , headers: headers, completionBlock: completionBlock)
    }
    
    
    func fetchWasteDetailData(params : [String: AnyObject],_ completionBlock: @escaping APIClientCompletionHandler) {
//
        let headers = ["Authorization": "token " + (DataManager.shared.getUser()?.result?.auth_token ?? "")]
        print("fetchWasteDetailData : \(headers)")
        _ = sendRequest(APIRoutes.wasteDetailData , parameters: params ,httpMethod: .post , headers: headers, completionBlock: completionBlock)
    }
    
    func saveWasteimages(params : [String: AnyObject],_ completionBlock: @escaping APIClientCompletionHandler) {

        let headers = ["Authorization": "token " + (DataManager.shared.getUser()?.result?.auth_token ?? "")]
        print("saveWasteimages : \(headers)")
        
        sendRequestUsingMultipart(APIRoutes.wasteDetailImageUpload, parameters: params, headers: headers, completionBlock: completionBlock)
        
    }
    
    func updateWasteSize(params : [String: AnyObject],_ completionBlock: @escaping APIClientCompletionHandler) {
//
        let headers = ["Authorization": "token " + (DataManager.shared.getUser()?.result?.auth_token ?? "")]
        print("updateWasteSize : \(headers)")
        _ = sendRequest(APIRoutes.wasteDetailSizeUpdate , parameters: params ,httpMethod: .post , headers: headers, completionBlock: completionBlock)
    }
    
    func updateWasteLocation(params : [String: AnyObject],_ completionBlock: @escaping APIClientCompletionHandler) {

        let headers = ["Authorization": "token " + (DataManager.shared.getUser()?.result?.auth_token ?? "")]
        print("updateWasteSize : \(headers)")
        _ = sendRequest(APIRoutes.wasteDetailLocationUpdate , parameters: params ,httpMethod: .post , headers: headers, completionBlock: completionBlock)
    }
    
    
    func fetchTwillioAccessToken(identity: String, _ completionBlock: @escaping APIClientCompletionHandler)
    {
        let headers = ["Authorization": "token " + (DataManager.shared.getUser()?.result?.auth_token ?? "")]
        
        print("fetchTwillioAccessToken : \(headers)")
        _ = sendRequest("\(APIRoutes.fetchTwilioTokenUrl)\(identity)", parameters: nil ,httpMethod: .get , headers: headers, completionBlock: completionBlock)
    }
}

