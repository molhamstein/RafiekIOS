//
//  ApiManager.swift
//
//  Created by Molham Mahmoud on 25/04/16.
//  Copyright © 2016. All rights reserved.
//

import SwiftyJSON
import Alamofire
import UIKit

/// - Api store do all Networking stuff
///     - build server request 
///     - prepare params
///     - and add requests headers
///     - parse Json response to App data models
///     - parse error code to Server error object
///
class ApiManager: NSObject {

    typealias Payload = (MultipartFormData) -> Void
    
    /// frequent request headers
    var headers: HTTPHeaders{
        get{
            let httpHeaders = [
                "Authorization": "",
                "Accept-Language": AppConfig.currentLanguage.langCode
            ]
            return httpHeaders
        }
    }
    
    let baseURL = "http://104.217.253.15:3000/api"
    let error_domain = "GlobalPages"
    
    //MARK: Shared Instance
    static let shared: ApiManager = ApiManager()
    
    private override init(){
        super.init()
    }
    
    /*
     Alamofire.download(urlString).responseData { response in
     print("Temporary URL: \(response.temporaryURL)")
     }
     */
// get books  http://104.217.253.15:3000/api/books/
    func getBooks(completionBlock: @escaping (_ success: Bool, _ error: ServerError?, _ result:[Book]) -> Void) {
        // url & parameters
        let signInURL = "\(baseURL)/books"
        // build request
        Alamofire.request(signInURL, method: .get).responseString { (responseObject) -> Void in
            print(responseObject)
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                print(jsonResponse)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError, [])
                } else {
                    if let dic = jsonResponse.rawString()?.data(using: String.Encoding.utf8){
                        let json = JSON(dic)
                    if let array = json.array{
                        let books = array.map{Book(json: $0)}
                        completionBlock(true,nil,books)
                    }else{
                         completionBlock(false, ServerError.unknownError, [])
                        }
                        
                    }else{
                        completionBlock(false, ServerError.unknownError, [])
                    }
                
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError, [])
                } else {
                    completionBlock(false, ServerError.connectionError, [])
                }
            }
        }
    }
    
    ///api/books?filter[where][code][like]=code
    func getBooksBy(code:String,completionBlock: @escaping (_ success: Bool, _ error: ServerError?, _ result:[Book]) -> Void) {
        // url & parameters
        let signInURL = "\(baseURL)/books?filter[where][code][like]=\(code)"
        // build request
        Alamofire.request(signInURL, method: .get).responseString { (responseObject) -> Void in
            print(responseObject)
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                print(jsonResponse)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError, [])
                } else {
                    if let dic = jsonResponse.rawString()?.data(using: String.Encoding.utf8){
                        let json = JSON(dic)
                        if let array = json.array{
                            let books = array.map{Book(json: $0)}
                            completionBlock(true,nil,books)
                        }else{
                            completionBlock(false, ServerError.unknownError, [])
                        }
                        
                    }else{
                        completionBlock(false, ServerError.unknownError, [])
                    }
                    
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError, [])
                } else {
                    completionBlock(false, ServerError.connectionError, [])
                }
            }
        }
    }
    func downloadFile(file:String,fileName:String,completionBlock: @escaping (_ success: Bool, _ error: ServerError?,_ result:String?) -> Void) {
        let urlString = "\(baseURL)/books/download/\(file)"
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("\(fileName).zip")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(urlString, to: destination)
            .downloadProgress { progress in
                // / progress.totalUnitCount)  * 100
                print("Download total: \(progress.totalUnitCount)")
                print("Download progress: \(progress.completedUnitCount)")
                
                
            }
            .responseData { response in
                print(response)
                
                if response.error == nil, let imagePath = response.destinationURL?.path {
                    completionBlock(true,nil,imagePath)
                }else{
                    completionBlock(false,ServerError.unknownError,nil)
                }
            }
        }
}


/**
 Server error represents custome errors types from back end
 */
struct ServerError {
    
    static let errorCodeConnection = 50
    
    public var errorName:String?
    public var status: Int?
    public var code:Int!
    
    public var type:ErrorType {
        get{
            return ErrorType(rawValue: code) ?? .unknown
        }
    }
    
    /// Server erros codes meaning according to backend
    enum ErrorType:Int {
        case connection = 50
        case unknown = -111
        case authorization = 401
        case userNotActivated = 403
        case emailNotFound = 404
        case invalidUserName = 405
        case noBottleFound = 406
        case alreadyExists = 422
        case socialLoginFailed = -110
        case notRegistred = 102
        case missingInputData = 104
        case expiredVerifyCode = 107
        case invalidVerifyCode = 108
        case userNotFound = 109
        
        /// Handle generic error messages
        /// **Warning:** it is not localized string
        var errorMessage:String {
            switch(self) {
            case .unknown:
                return "ERROR_UNKNOWN"
            case .connection:
                return "ERROR_NO_CONNECTION"
            case .authorization:
                return "ERROR_NOT_AUTHORIZED"
            case .alreadyExists:
                return "ERROR_SIGNUP_EMAIL_EXISTS"
            case .emailNotFound:
                return "ERROR_EMAIL_NOT_EXISTS"
            case .notRegistred:
                return "ERROR_SIGNIN_WRONG_CREDIST"
            case .missingInputData:
                return "ERROR_MISSING_INPUT_DATA"
            case .expiredVerifyCode:
                return "ERROR_EXPIRED_VERIFY_CODE"
            case .invalidVerifyCode:
                return "ERROR_INVALID_VERIFY_CODE"
            case .userNotFound:
                return "ERROR_RESET_WRONG_EMAIL"
            case .userNotActivated:
                return "ERROR_UNACTIVATED_USER"
            case .invalidUserName:
                return "ERROR_INVALID_USERNAME"
            case .noBottleFound:
                return "ERROR_BOTTLE_NOT_FOUND"
                
            default:
                return "ERROR_UNKNOWN"
            }
        }
    }
    
    public static var connectionError: ServerError{
        get {
            var error = ServerError()
            error.code = ErrorType.connection.rawValue
            return error
        }
    }
    
    public static var unknownError: ServerError{
        get {
            var error = ServerError()
            error.code = ErrorType.unknown.rawValue
            return error
        }
    }
    
    public static var socialLoginError: ServerError{
        get {
            var error = ServerError()
            error.code = ErrorType.socialLoginFailed.rawValue
            return error
        }
    }
    
    public init() {
    }
    
    public init?(json: JSON) {
        guard let errorCode = json["statusCode"].int else {
            return nil
        }
        code = errorCode
        if let errorString = json["message"].string{ errorName = errorString}
        if let statusCode = json["statusCode"].int{ status = statusCode}
    }
}


