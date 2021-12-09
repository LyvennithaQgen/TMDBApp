//
//  NetWorkLayer.swift
//  SubscriptionModule
//
//  Created by Lyvennitha on 01/12/21.
//

import Foundation
import Alamofire

public protocol NetworkConstants{
    var baseURL: String {get set}
    var method: String {get set}
}


public class NetWorkHandler: NSObject{
    public static let shared = NetWorkHandler()
    public var delegate: NetworkConstants?
    
    public func getRequest<T: Codable>(parameters: [String: Any],endPoint: MovieURL, onResponse: @escaping (Result<T, AFError>) -> ()){
        var components = URLComponents(string: delegate!.baseURL + endPoint.rawValue)!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value as? String ?? "")
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let response = AF.request(request)
        response.responseDecodable(of: T.self, decoder: decoder ){(response) in
            let json = try? JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: Any]
            let jsonData = try? JSONSerialization.data(withJSONObject: json!, options: [.prettyPrinted, .withoutEscapingSlashes])
            print("prettyPrint",String(decoding: jsonData!, as: UTF8.self))
            onResponse(response.result)
        }
    }
    
    public func postRequest<T: Codable>(parameters: [String: Any],endPoint: MovieURL, onResponse: @escaping (Result<T, Error>) -> ()){
        
    }
    
}

public enum MovieURL:String {
    case movieList = ""
    
}
