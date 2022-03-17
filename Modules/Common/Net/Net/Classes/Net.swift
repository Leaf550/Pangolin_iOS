//
//  Net.swift
//  Net
//
//  Created by 方昱恒 on 2022/2/28.
//

import Foundation
import Alamofire
import Provider

public class Net {
    
    private var host: RequestHost = .develop
    private var path: RequestPath = .root
    private var url: String { host.rawValue + path.rawValue }
    private var header: [String : String]? = [
        "Authorization" : PGProviderManager.shared.provider { AccountProvider.self }?.getToken() ?? ""
    ]
    private var body: [String : String]? = nil
    private var interceptor: RequestInterceptor? = nil
    private var request: DataRequest?
    
    public static func build() -> Net {
        return Net()
    }
    
    public func configHost(_ host: RequestHost) -> Self {
        self.host = host
        return self
    }
    
    public func configPath(_ path: RequestPath) -> Self {
        self.path = path
        return self
    }
    
    public func configHeader(_ header: [String : String]) -> Self {
        for (key, value) in header {
            self.header?[key] = value
        }
        return self
    }
    
    public func configBody(_ body: [String : String]) -> Self {
        self.body = body
        return self
    }
    
    public func configInterceptor(_ interceptor: RequestInterceptor) -> Self {
        self.interceptor = interceptor
        return self
    }
    
    public func `get`(completion: @escaping (Any) -> Void,
                      error: @escaping (Error) -> Void) -> Self {
        request(method: .get, interceptor: interceptor, completion: completion, error: error)
        return self
    }
    
    public func post(completion: @escaping (Any) -> Void,
                     error: @escaping (Error) -> Void) -> Self {
        request(method: .post, interceptor: interceptor, completion: completion, error: error)
        return self
    }
    
    public func cancel() {
        request?.cancel()
    }
    
    private func request(method: HTTPMethod,
                         interceptor: RequestInterceptor?,
                         completion: @escaping (Any) -> Void,
                         error: @escaping (Error) -> Void) {
        let requestHeaders = header == nil ? nil : HTTPHeaders(header ?? [:])
        request = AF.request(url,
                   method: method,
                   parameters: body,
                   headers: requestHeaders,
                   interceptor: interceptor,
                   requestModifier: { $0.timeoutInterval = 5 })
            .responseJSON { response in
            switch response.result {
                case .success(let json):
                    completion(json)
                case .failure(let err):
                    error(err)
            }
        }
    }
    
}
