

import Foundation
import ObjectMapper


typealias createSiteCompletionHandler = (_ data: CreateSiteDataModel?, _ error: Error?, _ status: Int?) -> Void


class CreateSiteDataModel : Mappable
{
    
    
	var success = false
	var status_code = -1
	var message = ""
	var result : ResultSiteCreation?

    required init?(map: Map) {

	}

	func mapping(map: Map) {

		success <- map["success"]
		status_code <- map["status_code"]
		message <- map["message"]
		result <- map["result"]
	}
    
    
    class func postSiteCreateData(params : [String : AnyObject], _ completion: @escaping createSiteCompletionHandler) {
        Utility.showLoading()
        APIClient.shared.postSupplyProcessData(params: params, { response, error, code in
            
            Utility.hideLoading()
            
            if response != nil {
                
                let newResult  = ["result" : response!]
                if let data = Mapper<CreateSiteDataModel>().map(JSON: newResult as [String : Any] ) {
                    completion(data, nil, 200)
                } else {
                    completion(nil, nil, 201)
                }
                
            } else {
                completion(nil, error, 404)
            }
        })
    }

}
