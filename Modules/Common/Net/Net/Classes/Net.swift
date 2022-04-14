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
    
    static var host: RequestHost = .cqupt5g
    
    private var host: RequestHost = Net.host
    private var path: RequestPath = .root
    private var url: String { host.rawValue + path.rawValue }
    private var header: [String : String]? = [
        "Authorization" : PGProviderManager.shared.provider { PersistenceProvider.self }?.getToken() ?? ""
    ]
    private var body: [String : String]? = nil
    private var interceptor: RequestInterceptor? = nil
    private var request: DataRequest?
    
    public static func build() -> Net {
        return Net()
    }
    
    @discardableResult
    public func configPath(_ path: RequestPath) -> Self {
        self.path = path
        return self
    }
    
    @discardableResult
    public func configHeader(_ header: [String : String]) -> Self {
        for (key, value) in header {
            self.header?[key] = value
        }
        return self
    }
    
    @discardableResult
    public func configBody(_ body: [String : String]) -> Self {
        self.body = body
        return self
    }
    
    @discardableResult
    public func configInterceptor(_ interceptor: RequestInterceptor) -> Self {
        self.interceptor = interceptor
        return self
    }
    
    @discardableResult
    public func `get`(completion: @escaping (Any) -> Void,
                      error: @escaping (Error) -> Void) -> Self {
        request(method: .get, interceptor: interceptor, completion: completion, error: error)
        return self
    }
    
    @discardableResult
    public func post(completion: @escaping (Any) -> Void,
                     error: @escaping (Error) -> Void) -> Self {
        request(method: .post, interceptor: interceptor, completion: completion, error: error)
        return self
    }
    
    public func cancel() {
        request?.cancel()
    }
    
    public static func netWorkStatus() -> NetworkStatus {
        switch NetworkReachabilityManager.default?.status ?? .unknown {
            case .unknown:
                return .unknown
            case .notReachable:
                return .notReachable
            case .reachable(let connectionType):
                return connectionType == .cellular ? .cellular : .ethernetOrWiFi
        }
    }
    
    public static func isReachableToServer() -> Bool {
        NetworkReachabilityManager(host: Net.host.rawValue)?.isReachable ?? false
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
