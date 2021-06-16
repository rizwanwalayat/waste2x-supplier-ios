

import Foundation
import ObjectMapper


typealias SupplyProcessCompletionHandler = (_ data: SupplyProcessDataModel?, _ error: Error?, _ status: Bool?, _ message:String) -> Void


class SupplyProcessDataModel : Mappable
{
	var success = Bool()
	var result = [SupplyProcessResponse]()
	var statusCode = -1

    required init?(map: Map) {
        
    }

    func mapping(map: Map) {

		success <- map["success"]
		result <- map["result"]
		statusCode <- map["status_code"]
	}

    
    class func fetchSupplyProcess(_ completion: @escaping SupplyProcessCompletionHandler) {
        Utility.showLoading()
        APIClient.shared.fetchSupplyProcessData { result, error, status,message in
            
            Utility.hideLoading()
            
            if result != nil {
                
                let newResult  = ["result" : result!]
                if let data = Mapper<SupplyProcessDataModel>().map(JSON: newResult as [String : Any] ) {
                    completion(data, nil, status,message)
                } else {
                    completion(nil, nil, status,message)
                }
                
            } else {
                 completion(nil, error, status,message)
            }
        }
    }
}
