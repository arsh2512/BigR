//
//  ImageAPIClient.swift
//  Garnysh
//
//  Created by appcare on 18/09/18.
//  Copyright © 2018 appcare. All rights reserved.
//

import Foundation
import Alamofire

class ImageAPIClient: NSObject {
    
    class func requestWith(endUrl: URL, imageData: Data?, parameters: [String : Any], fileName: String, withName: String, success: @escaping (Data) -> Void, failure: @escaping (Error) -> Void){
        
        let headers: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "Content-type": "multipart/form-data"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = imageData{
                multipartFormData.append(data, withName: withName, fileName: fileName, mimeType: "image/jpeg")
            }
            
        }, usingThreshold: UInt64.init(), to: endUrl, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    if let err = response.error{
                        failure(err)
                        return
                    }
                    success(response.data!)
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                failure(error)
            }
        }
    }
}
class VideoAPIClient: NSObject {
    
    class func requestWith(endUrl: URL, videoUrl: URL, parameters: [String : Any], fileName: String, withName: String, success: @escaping (Data) -> Void, failure: @escaping (Error) -> Void){
        
        let headers: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "Content-type": "multipart/form-data"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
           // if let data = videoData{
                multipartFormData.append(videoUrl, withName: withName, fileName: fileName, mimeType: "video/mp4")
           // }
            
        }, usingThreshold: UInt64.init(), to: endUrl, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    if let err = response.error{
                        failure(err)
                        return
                    }
                    success(response.data!)
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                failure(error)
            }
        }
    }
}
