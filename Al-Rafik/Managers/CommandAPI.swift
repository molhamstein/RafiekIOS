//
//  CommandAPI.swift
//  Al-Rafik
//
//  Created by Nour Araar on 11/7/19.
//  Copyright © 2019 Nour . All rights reserved.
//

import SwiftyJSON
import Alamofire
import UIKit

class CommandAPI: NSObject{
    typealias Payload = (MultipartFormData) -> Void
    
    /// frequent request headers
    var headers: HTTPHeaders{
        get {
            let httpHeaders = [
                "Authorization": "Bearer 6BRAOIEOBF7JCTMYXHKMR5PMKGTR7C3Z",
            ]
            return httpHeaders
        }
    }
    let baseURL = "https://api.wit.ai"
    static let shared: CommandAPI = CommandAPI()
    func getCommand(message:String,completionBlock: @escaping (_ success: Bool, _ error: ServerError?, _ result:VoiceCommand?) -> Void) {
        // url & parameters
        let signInURL = "\(baseURL)/message?v=20191107&q=\(message)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        // build request
        Alamofire.request(signInURL, method: .get,headers:headers).responseString { (responseObject) -> Void in
            print(responseObject)
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                print(jsonResponse)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError, nil)
                } else {
                    if let data = responseObject.data {
                        do {
                            let decoder = JSONDecoder()
                            let gitData = try decoder.decode(VoiceCommand.self, from: data)
                            completionBlock(true,nil,gitData)
                        } catch let err {
                            print("Err", err)
                            completionBlock(false, ServerError.unknownError, nil)
                        }
                    }else{
                        completionBlock(false, ServerError.unknownError, nil)
                    }
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError, nil)
                } else {
                    completionBlock(false, ServerError.connectionError, nil)
                }
            }
        }
    }
}
