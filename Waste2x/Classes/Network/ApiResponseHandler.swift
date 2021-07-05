
import Foundation
import ObjectMapper

class VTResponseHandler: Mappable {

    // MARK: - Properties

    var status = false
    var isError = false
    var message = ""
    var data: AnyObject? // data can be nil
    var error = ""
    var errorDescription: String?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        status                     <- (map["success"])
        isError                    <- map["error"]
        message                 <- map["message"]
        data                        <- map["result"]
        error                       <- map["error"]
        errorDescription    <- map["error_description"]

    }

    // MARK: Transforms

    let transform = TransformOf<Bool, Int>(fromJSON: { (value: Int?) -> Bool? in

        if value == 200 {
            return true
        }

        return false

    }, toJSON: { (value: Bool?) -> Int? in

        if let value = value {

            if value == true {
                return 200
            }

            return 404
        }

        return 404
    })
}

