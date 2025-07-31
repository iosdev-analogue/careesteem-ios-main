//
//  ApiManager.swift
//  CareEsteem
//
//  Created by Nitin Chauhan on 26/06/25.
//

import UIKit

class ApiManager: NSObject {
    private func header() -> [String : String] {
        return [HTTPHeaderString.accept.string: HTTPHeaderString.jsonTypeValue.string,
                HTTPHeaderString.contentType.string: HTTPHeaderString.jsonTypeValue.string]
    }
     static func postApiRequest(url: String,parameters:[String: Any],completion: @escaping([String: Any])-> Void) {
        let session = URLSession.shared
         let url1 = url + "?hash_token:ZjY5NGU2MGMzM2M0NDQyODlmOGUwODdjOjJlNGRlNmU1M2VlZTQ4YmY5ZDZjMTkwNToxNzUwOTE5MTA5MTQw"
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
         request.allHTTPHeaderFields = [HTTPHeaderString.accept.string: HTTPHeaderString.jsonTypeValue.string,
                                        HTTPHeaderString.contentType.string: HTTPHeaderString.jsonTypeValue.string]
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
            let task = session.dataTask(with: request as URLRequest as URLRequest, completionHandler: {(data, response, error) in
                if let response = response {
                    let nsHTTPResponse = response as! HTTPURLResponse
                    let statusCode = nsHTTPResponse.statusCode
                    print ("status code = \(statusCode)")
                }
                if let error = error {
                    print ("\(error)")
                }
                if let data = data {
                    do{
                        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
                        print ("data = \(jsonResponse)")
                    }catch _ {
                        print ("OOps not good JSON formatted response")
                    }
                }
            })
            task.resume()
        }catch _ {
            print ("Oops something happened buddy")
        }
        
    }
}
