//
//  Network.swift
//  iSuke
//
//  Created by Tang Retouch on 2018/9/11.
//  Copyright © 2018 Tang Retouch. All rights reserved.
//

import Foundation
import Moya

typealias Success = (_ data: Any?) -> Void
typealias Fail = (_ error: MoyaError) -> Void

typealias Success1 = (_ data: Any) -> Void

class Network {
    @discardableResult
    func request<T: TargetType>(target: T,
                                success: @escaping Success,
                                fail: Fail? = .none ) -> Cancellable? {
        let cancelLabel = createProvider(type: target).request(target) { (response) in
            switch response {
            case let .success(response):
                if let baseResponse:BaseResponse =  BaseResponse.deserialize(from: try? response.mapString()) {
                    if baseResponse.code == SUCCESS {
                        //assert(baseResponse.data != nil, "data from server cann’t be nil")
                        success(baseResponse.data)
                    }else{
                        if let message = baseResponse.msg {
                            MBProgressHUD.showMessage(message: message)
                        }
                        if let failBlock = fail {
                            failBlock(MoyaError.jsonMapping(response))
                        }
                    }
                }
            case let .failure(error):
                if let failBlock = fail {
                    failBlock(error)
                }
                MBProgressHUD.showMessage(message: error.errorDescription ?? "未知错误")
            }
        }
        return cancelLabel
    }
    
    private func createProvider<M: TargetType>(type: M) -> MoyaProvider<M> {
        let provider = MoyaProvider<M>(plugins: [MyNetworkLoggerPlugin(), RequestLoadingPlugin()])
        return provider
    }
    


}
