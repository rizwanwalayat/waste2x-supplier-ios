

import Foundation

import ObjectMapper

class Json4Swift_Base : Mappable
{
	var success = Bool()
	var result = [SupplyProcessResponse]()
	var status_code = -1

    required init?(map: Map) {
        
    }

    func mapping(map: Map) {

		success <- map["success"]
		result <- map["result"]
		status_code <- map["status_code"]
	}

    
    class func fetchSupplyProcessData(_ completion: @escaping ForgotPasswordCompletionHandler) {
        Utility.showLoading()
        APIClient.shared.fetchSupplyProcessData { result, error, statusCode in
            
            Utility.hideLoading()
            if error == nil {
                
                print(result)
                
            } else {
                completion(nil, error, 404)
            }
        }
    }
    
}
