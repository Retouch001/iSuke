//
//  MyNetworkLoggerPlugin.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/7/25.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import Foundation
import Moya
import Result
import SwiftyJSON

class MyNetworkLoggerPlugin: PluginType {
    fileprivate let loggerId = "Log"
    //fileprivate let dateFormatString = "dd/MM/yyyy HH:mm:ss"
    fileprivate let dateFormatString = "HH:mm:ss"
    fileprivate let dateFormatter = DateFormatter()
    fileprivate let separator = ", "
    fileprivate let terminator = "\n"
    fileprivate let cURLTerminator = "\\\n"
    fileprivate let output: (_ separator: String, _ terminator: String, _ items: Any...) -> Void
    fileprivate let requestDataFormatter: ((Data) -> (String))?
    fileprivate let responseDataFormatter: ((Data) -> (Data))?
    
    /// A Boolean value determing whether response body data should be logged.
    public let isVerbose: Bool
    public let cURL: Bool
    
    /// Initializes a NetworkLoggerPlugin.
    public init(verbose: Bool = true, cURL: Bool = false, output: ((_ separator: String, _ terminator: String, _ items: Any...) -> Void)? = nil, requestDataFormatter: ((Data) -> (String))? = nil, responseDataFormatter: ((Data) -> (Data))? = nil) {
        self.cURL = cURL
        self.isVerbose = verbose
        self.output = output ?? MyNetworkLoggerPlugin.reversedPrint
        self.requestDataFormatter = requestDataFormatter
        self.responseDataFormatter = responseDataFormatter
    }
    
    public func willSend(_ request: RequestType, target: TargetType) {
        if let request = request as? CustomDebugStringConvertible, cURL {
            output(separator, terminator, request.debugDescription)
            return
        }
        outputItems(logNetworkRequest(request.request as URLRequest?))
    }
    
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        if case .success(let response) = result {
            outputItems(logNetworkResponse(response.response, data: response.data, target: target))
        } else {
            outputItems(logNetworkResponse(nil, data: nil, target: target))
        }
    }
    
    fileprivate func outputItems(_ items: [String]) {
        if isVerbose {
            items.forEach { output(separator, terminator, $0) }
        } else {
            output(separator, terminator, items)
        }
    }
}

private extension MyNetworkLoggerPlugin {
    var date: String {
        dateFormatter.dateFormat = dateFormatString
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: Date())
    }
    
    func format(_ loggerId: String, date: String, identifier: String, message: String) -> String {
        return "\(loggerId): [\(date)] \(identifier): \(message)"
    }
    
    func logNetworkRequest(_ request: URLRequest?) -> [String] {
        
        var output = [String]()
        
        output += [format(loggerId, date: date, identifier: "Request Path", message: request?.description ?? "(invalid request)")]
        
        if let headers = request?.allHTTPHeaderFields {
            output += [format(loggerId, date: date, identifier: "Request Headers", message: headers.description)]
        }
        
        if let bodyStream = request?.httpBodyStream {
            output += [format(loggerId, date: date, identifier: "Request Body Stream", message: bodyStream.description)]
        }
        
//        if let httpMethod = request?.httpMethod {
//            output += [format(loggerId, date: date, identifier: "Request Method", message: httpMethod)]
//        }
        
        if let body = request?.httpBody, let stringOutput = requestDataFormatter?(body) ?? String(data: body, encoding: .utf8), isVerbose {
            output += [format(loggerId, date: date, identifier: "Request Body", message: stringOutput)]
        }
        
        return output
    }
    
    func logNetworkResponse(_ response: HTTPURLResponse?, data: Data?, target: TargetType) -> [String] {
        guard response != nil else {
            return [format(loggerId, date: date, identifier: "Response", message: "Received empty network response for \(target).")]
        }
        
        var output = [String]()
        
        //output += [format(loggerId, date: date, identifier: "Response", message: response.description)]
        

        let dataAsJSON = try! JSONSerialization.jsonObject(with: data!)// Data 转 JSON
        let prettyData =  try! JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        
        if let stringData = String(data: responseDataFormatter?(prettyData) ?? prettyData, encoding: String.Encoding.utf8), isVerbose {
            
            //output += [stringData]
            output += [format(loggerId, date: date, identifier: "Response", message: ("\n\(stringData)"))]

        }
        return output
    }
}

fileprivate extension MyNetworkLoggerPlugin {
    static func reversedPrint(_ separator: String, terminator: String, items: Any...) {
        for item in items {
            print(item, separator: separator, terminator: terminator)
        }
    }
}
