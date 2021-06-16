

import Foundation
import ObjectMapper


typealias SupplyProcessCompletionHandler = (_ data: SupplyProcessDataModel?, _ error: Error?, _ status: Int?, _ message:String) -> Void


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
        APIClient.shared.fetchSupplyProcessData { result, error, statusCode,message in
            
            Utility.hideLoading()
            
            if result != nil {
                
                let newResult  = ["result" : result!]
                if let data = Mapper<SupplyProcessDataModel>().map(JSON: newResult as [String : Any] ) {
                    completion(data, nil, 200,message)
                } else {
                    completion(nil, nil, 201,message)
                }
                
            } else {
                 completion(nil, error, 404,message)
            }
        }
    }
}
