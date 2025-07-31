
import UIKit
import Combine
import Network
class WebServiceManager: ObservableObject {
    
    static let sharedInstance = WebServiceManager()
    private var cancellable = Set<AnyCancellable>()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    init() {
        monitor.start(queue: queue)
    }
    func startNetworkingCheck(){
        monitor.cancel()
        monitor.start(queue: queue)
    }
    // MARK: - Check Internet Connection
    func isConnected() -> Bool {
        return monitor.currentPath.status == .satisfied
    }
    
    
    /*------------------------------------------------------------------------
     //  MARK:- Get Auth Headers
     ------------------------------------------------------------------------*/
    private func getAuthHeader() -> [String: String] {
        
        var headers: [String: String]
        headers = [HTTPHeaderString.contentType.string: HTTPHeaderString.jsonTypeValue.string,
                   HTTPHeaderString.accept.string: HTTPHeaderString.jsonTypeValue.string]
        
        return headers
    }
    
    /*------------------------------------------------------------------------
     SIMPLE HEADER
     ------------------------------------------------------------------------*/
    private func header() -> [String : String] {
        return [HTTPHeaderString.accept.string: HTTPHeaderString.jsonTypeValue.string,
                HTTPHeaderString.contentType.string: HTTPHeaderString.jsonTypeValue.string]
    }
    
    // MARK: - API REQUEST
    func sendAPIRequest<T: Codable>(
        url: APIType,
        queryParams: [String: String]? = nil,
        method: HTTPMethod,
        params: [String: Any] = [:],
        isAuthenticate: Bool = false,
        model: T.Type,
        completionClosure: @escaping (Result<T, ErrorModel>, String) -> Void
    ) {
        guard var urlComponents = URLComponents(string: url.url) else {
            DebugLogs.shared.printLog("Invalid URL: \(url)")
            completionClosure(.failure(.invalidURL),
                              ErrorModel.invalidURL.description())
            return
        }

        if let queryParams = queryParams, !queryParams.isEmpty {
            urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }

        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = isAuthenticate ? self.getAuthHeader() : self.header()

        if method != .get {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            } catch {
                DebugLogs.shared.printLog("JSON Serialization Error: \(error.localizedDescription)")
                completionClosure(.failure(.parsingError), ErrorModel.parsingError.description())
                return
            }
        }

        DebugLogs.shared.printLog("URL: \(request.url?.absoluteString ?? "")")
        DebugLogs.shared.printLog("Method: \(method.rawValue)")
        DebugLogs.shared.printLog("Headers: \(request.allHTTPHeaderFields ?? [:])")
        DebugLogs.shared.printLog("Params: \(params)")

        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                guard output.response is HTTPURLResponse else {
                    throw ErrorModel.serverError
                }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    DebugLogs.shared.printLog("Error: \(error.localizedDescription)")
                    completionClosure(.failure(.internetConnectionError), ErrorModel.internetConnectionError.description())
                }
            }, receiveValue: {[weak self] data in
                self?.convertResponse(url: url, data: data, model: model, completionClosure: completionClosure)
            })
            .store(in: &cancellable)
    }
    // MARK: - Image Upload API Request
    func imageUploadAPIRequest<T: Codable>(
        url: APIType,
        queryParams: [String: String]? = nil,
        method: HTTPMethod,
        formFields: [String: Any],
        model: T.Type,
        completionClosure: @escaping (Result<T, ErrorModel>, String) -> Void
    ) {
        guard isConnected() else {
            completionClosure(.failure(.internetConnectionError), ErrorModel.internetConnectionError.description())
            return
        }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        
        guard var urlComponents = URLComponents(string: url.url) else {
            DebugLogs.shared.printLog("Invalid URL: \(url)")
            completionClosure(.failure(.invalidURL), ErrorModel.invalidURL.description())
            return
        }
        var queryParam = queryParams ?? [:]
//#if DEBUG
//        queryParam[APIParameters.hashToken] = "ZjY5NGU2MGMzM2M0NDQyODlmOGUwODdjOjJlNGRlNmU1M2VlZTQ4YmY5ZDZjMTkwNToxNzUwMDc2OTgxNjQx"
//#endif
        if let hashToken = UserDetails.shared.loginModel?.hashToken{
            queryParam[APIParameters.hashToken] = hashToken
        }
        if !queryParam.isEmpty {
            urlComponents.queryItems = queryParam.map { URLQueryItem(name: $0.key, value: $0.value) }
        }

        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = method.rawValue
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Generate the multipart form body
        request.httpBody = makeHttpBody(formFields: formFields, boundary: boundary)

        DebugLogs.shared.printLog("URL: \(request.url?.absoluteString ?? "")")
        DebugLogs.shared.printLog("Method: \(method.rawValue)")
        DebugLogs.shared.printLog("Form Fields: \(formFields)")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw ErrorModel.serverError
                }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    DebugLogs.shared.printLog("Error: \(error.localizedDescription)")
                    completionClosure(.failure(.internetConnectionError), ErrorModel.internetConnectionError.description())
                }
            }, receiveValue: {[weak self] data in
                self?.convertResponse(url: url, data: data, model: model, completionClosure: completionClosure)
            })
            .store(in: &cancellable)
    }
    func callAPI<T>(apiPath: APIType, queryParams: [String: String]? = nil, method: HTTPMethod, params: [String: Any] = [:], isAuthenticate: Bool = false, model : T.Type, complitionClosure : @escaping (Result<T, ErrorModel>, _ successMsgStr : String) -> Void) where T : Codable {
        
        if(self.isConnected()) {
            var queryParam = queryParams ?? [:]
//#if DEBUG
//            queryParam[APIParameters.hashToken] = "ZjY5NGU2MGMzM2M0NDQyODlmOGUwODdjOjJlNGRlNmU1M2VlZTQ4YmY5ZDZjMTkwNToxNzUwMDc2OTgxNjQx"
//#endif
            if let hashToken = UserDetails.shared.loginModel?.hashToken{
                queryParam[APIParameters.hashToken] = hashToken
            }
            self.sendAPIRequest(url: apiPath, queryParams: queryParam, method: method, params: params, isAuthenticate: isAuthenticate, model: model, completionClosure: complitionClosure)
        }
        else{
            CustomLoader.shared.hideLoader()
            let alert = UIAlertController(title: "No Internet Connection", message: "Connect to the internet and try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            AppDelegate.shared.topViewController()?.present(alert, animated: true, completion: nil)
            // complitionClosure(.failure(.internetConnectionError), ErrorModel.internetConnectionError.description())
        }
    }
    
    func setDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }
    
    func makeHttpBody(formFields: [String:Any], boundary: String) -> Data {
        let httpBody = NSMutableData()
        for (key, value) in formFields {
            
            if (key) == "attachment" && value as? Data != nil {
                
                let videoData = value as? Data ?? Data()
                
                let fileName = "video\(UUID().uuidString).MP4"
                let mimeType = "video/MP4"
                
                DispatchQueue.main.async { [weak self] in
                    httpBody.append(self!.convertFileData(fieldName: key, fileName: fileName, mimeType: mimeType, fileData: videoData, using: boundary))

                }
                
            } else if let image = value as? UIImage {
                
                let fileName = "image\(UUID().uuidString).jpg"
                let mimeType = "image/jpg"
                let fileData = image.jpeg(.medium) ?? Data() //  img.pngData()!
                
                httpBody.append(convertFileData(fieldName: key, fileName: fileName, mimeType: mimeType, fileData: fileData, using: boundary))
                
            } else if let imageArr = value as? [UIImage] {
                
                for img in imageArr {
                    let img = img
                    let fileName = "image\(UUID().uuidString).jpg"
                    let mimeType = "image/jpg"
                    let fileData = img.jpeg(.medium) ?? Data()//  img.pngData()!
                    DebugLogs.shared.printLog(fileData)
                    
                    httpBody.append(convertFileData(fieldName: key, fileName: fileName, mimeType: mimeType, fileData: fileData, using: boundary))
                }
            } else {
                httpBody.append(convertFormField(named: key, value: value, using: boundary).data(using: .utf8) ?? Data())
            }
        }
        
        httpBody.append("--\(boundary)--".data(using: .utf8) ?? Data())
        
        return httpBody as Data
    }
    
    func makeImageVideoHttpBody(formFields: NSDictionary, boundary: String) -> Data {
        
        let httpBody = NSMutableData()
        
        for (key, value) in formFields {
            
            if (key as? String ?? "") == "attachment" && value as? URL != nil {
                
                let strVideoURL = value as! URL
                
                let fileName = "video\(UUID().uuidString).MOV"
                let mimeType = "video/MOV"
                
                httpBody.append(convertImageVideoFileData(fieldName: key as? String ?? "", fileName: fileName, mimeType: mimeType, strFile: strVideoURL, using: boundary).data(using: .utf8) ?? Data())
                
            } else if let image = value as? UIImage {
                
                let fileName = "image\(UUID().uuidString).jpg"
                let mimeType = "image/jpg"
                let fileData = image.jpegData(compressionQuality: 0.5) ?? Data() //  img.pngData()!
                
                httpBody.append(convertFileData(fieldName: key as? String ?? "", fileName: fileName, mimeType: mimeType, fileData: fileData, using: boundary))
                
            } else {
                httpBody.append(convertFormField(named: key as? String ?? "", value: value as! String, using: boundary).data(using: .utf8) ?? Data())
            }
        }
        
        httpBody.append("--\(boundary)--".data(using: .utf8) ?? Data())
        
        return httpBody as Data
    }
    
    func convertFormField(named name: String, value: Any, using boundary: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"
        
        return fieldString
    }
    
    func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
        let data = NSMutableData()
        
        data.append("--\(boundary)\r\n".data(using: .utf8) ?? Data())
        data.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8) ?? Data())
        data.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8) ?? Data())
        data.append(fileData)
        data.append("\r\n".data(using: .utf8) ?? Data())
        
        return data as Data
    }
    
    func convertImageVideoFileData(fieldName: String, fileName: String, mimeType: String, strFile: URL, using boundary: String) -> String {
        var data: String = ""
        
        data.append("--\(boundary)\r\n")
        data.append("Content-Disposition:form-data; name=\"\(fieldName)\"; filename=\"\(strFile)\"\r\n")
        data.append("Content-Type: \(mimeType)\r\n\r\n")
        
        let fileData = try! NSData(contentsOf: strFile, options: NSData.ReadingOptions.alwaysMapped) as Data
        let fileContent = String(data: fileData, encoding: .utf8)!
        
        data.append(fileContent)
        data.append("\r\n")
        
        return data as String
    }
    
    func convertResponse<T>(url: APIType, data: Data, model: T.Type, completionClosure: @escaping (Result<T, ErrorModel>, String) -> Void) where T: Codable {
        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                if let errors = jsonObject["error"] as? [String:[String]]{
                    DebugLogs.shared.printLog("API response error:",errors)
                }else{
                    DebugLogs.shared.printLog("API response ",jsonObject)
                    if let code: Int = jsonObject["statusCode"] as? Int, code == 401 {
                        AppDelegate.shared.logOut()
                    }
                }
            }
        } catch {
            DebugLogs.shared.printLog("Error converting data to JSON: \(error)")
            DebugLogs.shared.printLog(String(data: data, encoding: .utf8) ?? "")
        }
        do {
            let decoder = setDecoder()
            let responseData = try decoder.decode(T.self, from: data)
            // If decoding is successful, treat it as a success.
            completionClosure(.success(responseData), "Default Success Msg")
        } catch let DecodingError.keyNotFound(key, context) {
            DebugLogs.shared.printLog("Decoding error (keyNotFound): \(key) not found in \(context.debugDescription)")
            DebugLogs.shared.printLog("Coding path: \(context.codingPath)")
            completionClosure(.failure(.unknown(error: context.debugDescription)), ErrorModel.unknown(error: context.debugDescription).description())
        } catch let DecodingError.dataCorrupted(context) {
            DebugLogs.shared.printLog("Decoding error (dataCorrupted): data corrupted in \(context.underlyingError.debugDescription)")
            DebugLogs.shared.printLog("Decoding error (dataCorrupted): data corrupted in \(context.debugDescription)")
            DebugLogs.shared.printLog("Coding path: \(context.codingPath)")
            if let error = context.underlyingError{
                completionClosure(.failure(.unknown(error: error.localizedDescription)), ErrorModel.unknown(error: error.localizedDescription).description())
            }else{
                completionClosure(.failure(.unknown(error: context.debugDescription)), ErrorModel.unknown(error: context.debugDescription).description())
            }
        } catch let DecodingError.typeMismatch(type, context) {
            DebugLogs.shared.printLog("Decoding error (typeMismatch): type mismatch of \(type) in \(context.debugDescription)")
            DebugLogs.shared.printLog("Coding path: \(context.codingPath)")
            completionClosure(.failure(.unknown(error: context.debugDescription)), ErrorModel.unknown(error: context.debugDescription).description())
        } catch let DecodingError.valueNotFound(type, context) {
            DebugLogs.shared.printLog("Decoding error (valueNotFound): value not found for \(type) in \(context.debugDescription)")
            DebugLogs.shared.printLog("Coding path: \(context.codingPath)")
            completionClosure(.failure(.unknown(error: context.debugDescription)), ErrorModel.unknown(error: context.debugDescription).description())
        } catch (let error){
            completionClosure(.failure(.unknown(error: error.localizedDescription)), ErrorModel.unknown(error: error.localizedDescription).description())
        }
    }
    
    
    //MARK: - Download file to document directory
    func download(to directory: FileManager.SearchPathDirectory, overwrite: Bool = false, url: URL, completion: @escaping (URL?, Error?) -> Void) throws {
        let directory = try! FileManager.default.url(for: directory, in: .userDomainMask, appropriateFor: nil, create: true)
        let destination: URL
        
        destination = directory.appendingPathComponent(url.lastPathComponent)
        
        if !overwrite, FileManager.default.fileExists(atPath: destination.path) {
            completion(destination, nil)
            return
        }
        URLSession.shared.downloadTask(with: url) { location, _, error in
            guard let location = location else {
                completion(nil, error)
                return
            }
            do {
                if overwrite, FileManager.default.fileExists(atPath: destination.path) {
                    try FileManager.default.removeItem(at: destination)
                }
                try FileManager.default.moveItem(at: location, to: destination)
                completion(destination, nil)
            } catch {
                DebugLogs.shared.printLog(error)
            }
        }.resume()
    }
}


//class ImageDownloader {
//    var url = URL(string: "https://example.com/image.jpg")!
//
//    func downloadImage(completion: @escaping (UIImage?, Error?) -> Void) {
//        DispatchQueue.global(qos: .background).async {
//            do {
//                let data = try Data(contentsOf: self.url)
//                let image = UIImage(data: data)
//                DispatchQueue.main.async {
//                    completion(image, nil)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(nil, error)
//                }
//            }
//        }
//    }
//}
