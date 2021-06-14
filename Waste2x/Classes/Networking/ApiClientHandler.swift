
import UIKit
import Alamofire
import ObjectMapper

typealias APIClientCompletionHandler = (_ result: AnyObject?, _ error: NSError?,_ statusCode: Int) -> Void
typealias APIClientCompletionHandler1 = (_ result: [String : Any]?, _ error: NSError?,_ statusCode: Int) -> Void

enum APIClientHandlerErrorCode: Int {
    case general = 30001
    case noNetwork = 30002
    case timeOut = 30003
    case invalidToken = 401
}

let APIClientHandlerErrorDomain = "com.VT.webserviceerror"
let APIClientHandlerDefaultErrorDescription = "Operation failed" //"Operation failed"

class APIClientHandler: TSAPIClient {

    func sendRequestUsingMultipart (_ url: String, parameters: [String : AnyObject]?, httpMethod: HTTPMethod = .post, headers: [String : String]?, completionBlock: @escaping APIClientCompletionHandler) {
        var parameters = parameters
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters ?? [:] {
                
                if key == "image" {
                    let image = value as! UIImage
                    let data = image.jpeg(.lowest)
                    multipartFormData.append(data!, withName: "image", fileName: "profilePicture.jpeg", mimeType: "image/jpeg")
                    parameters?.removeValue(forKey: "photo")
                } else {
                    multipartFormData.append(String(describing: value).data(using: .utf8)!, withName: key)
                }
            }
            
        }, usingThreshold: 0, to: url, method: httpMethod, headers: headers, encodingCompletion: { (encodingResult) in
            
            switch encodingResult {
                
            case .success(let upload, _ , _):
                upload.uploadProgress(closure: { (progress) in
                    print(progress)
                })
                
                upload.responseJSON { response in
                    
                    switch response.result {
                    case .success(let resultData):
                        completionBlock(resultData as AnyObject, nil, 200)
                        
                    case .failure(let error):
                        completionBlock(error as AnyObject, error as NSError, 200)
                    }
                    
                }
            case .failure:
                break
            }
        })
    }
    
    func rawRequest(url: String, method: HTTPMethod, parameters: [String:AnyObject]?, headers: [String : String]?, completionBlock: @escaping APIClientCompletionHandler) {
        
        let request = Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers)
        
        request.responseJSON { (response) in
            switch response.result {
                
            case .success(let data):
                print(data)
                completionBlock(data as AnyObject, nil, 200)
            case .failure(let error):
                print(error.localizedDescription)
                completionBlock(nil, error as NSError, 404)
            }
        }
    }
    
    
    func sendRequest(_ methodName: String,
                     parameters: [String : AnyObject]?,
                     httpMethod: HTTPMethod = .get,
                     headers: [String : String]?,
                     completionBlock: @escaping APIClientCompletionHandler) -> Request {

        let request = self.serverRequest(APIRoutes.baseUrl + methodName, parameters: parameters, httpMethod: httpMethod, headers: headers) { (response, result, error) in

            if error != nil {
                var apiError = error

                if error?.code == NSURLErrorNotConnectedToInternet {
                    let userInfo : [String: Any] = [NSLocalizedDescriptionKey : "No network found"]
                    apiError = self.createErrorWithErrorCode(APIClientHandlerErrorCode.noNetwork.rawValue, andErrorInfo: userInfo)

                } else if error?.code == 401 {
                    let userInfo : [String: Any] = [NSLocalizedDescriptionKey : "Token problem"]
                    apiError = self.createErrorWithErrorCode(APIClientHandlerErrorCode.invalidToken.rawValue, andErrorInfo: userInfo)
                    
                } else {
                    let userInfo : [String: Any] = [NSLocalizedDescriptionKey : "Connecting to network ...."]
                    apiError = self.createErrorWithErrorCode(APIClientHandlerErrorCode.timeOut.rawValue, andErrorInfo: userInfo)
                }

                DispatchQueue.main.async { // Correct
                    completionBlock(nil, apiError, response?.statusCode ?? 200)
                }

            } else {

                var sendError = false
                var sendMessage = false
                var status = false
                var isError = false
                var errorMessage = ""
                var message = ""
                var resultError: NSError?
                var resultData: AnyObject?

                if let responseHandler = Mapper<VTResponseHandler>().map(JSONObject:result) {
                    status = responseHandler.status
                    isError = responseHandler.isError
                    errorMessage = responseHandler.error
                    message = responseHandler.message
                    resultData = responseHandler.data

                    if   !isError {
                        resultData = responseHandler.data

                        if resultData == nil {
                            resultData = true as AnyObject?
                        }

                    } else if isError && message != "" {
                        sendMessage = true

                    } else {
                        sendError = true
                    }

                } else {
                    sendError = true
                }

                if sendError {
                    resultError = self.createError(errorMessage)

                    DispatchQueue.main.async { // Correct
                        completionBlock(nil, resultError, response!.statusCode)
                    }

                } else if sendMessage {
                    resultError = self.createError(message)

                    if resultData == nil {
                        resultData = true as AnyObject?
                    }

                    DispatchQueue.main.async { // Correct
                        completionBlock(resultData, resultError, response!.statusCode)
                    }
 
                } else {

                    DispatchQueue.main.async { // Correct
                        completionBlock(resultData, nil, response!.statusCode)
                    }
                }
            }
        }

        return request
    }

    // MARK: - Private methods

    func createError(_ errorDescription: String) -> NSError {
        var description = APIClientHandlerDefaultErrorDescription

        //print(errorDescription)
        if errorDescription.count > 0 {
            description = errorDescription
        }

        let userInfo : [String: Any] = [NSLocalizedDescriptionKey : description]

        return createErrorWithErrorCode(APIClientHandlerErrorCode.general.rawValue, andErrorInfo: userInfo)
    }

    func createErrorWithErrorCode(_ code: Int, andErrorInfo info: [String: Any]?) -> NSError {
        return NSError(domain: APIClientHandlerErrorDomain, code: code, userInfo: info)
    }
}
