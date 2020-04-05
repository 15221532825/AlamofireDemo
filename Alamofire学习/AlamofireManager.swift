//
//  AlamofireManager.swift
//  Alamofire学习
//
//  Created by 飞翔 on 2020/4/5.
//  Copyright © 2020 飞翔. All rights reserved.
//

import UIKit
import Alamofire


enum MethodType{
    
    case GET,POST
}

enum NetworkStatus{
    
    case unknown,notReachable,WLAN,wifi
}

//响应成功的闭包
typealias FXResponseSuccess = (_ response:String)->()
//响应失败的闭包
typealias FXResponseFailure = (_ error:String)->()
//监测网络状况的闭包
typealias FXNetworkClosure =  (_ status:NetworkStatus)->()

class AlamofireManager: NSObject {
    
    static let share = AlamofireManager()
    
    private var sessionManager:Session?
    ///默认是wifi
    private var networkStatus: NetworkStatus = NetworkStatus.wifi
    
    override init() {
        super.init()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 45
        
        sessionManager = Session.init(configuration: configuration, delegate: SessionDelegate.init(),serverTrustManager: nil)
    }
    
    func loadUrl( _ type:MethodType, url:String,params:[String:Any],success:@escaping FXResponseSuccess,failure:@escaping FXResponseFailure ) {
        
        let method:HTTPMethod = (type==MethodType.GET ? HTTPMethod.get: .post)
        
        self.detachNetwork { (status) in
            
            ///成功进行网络请求 失败则弹框提示
            if status == NetworkStatus.notReachable {return}
            AF.request(url, method:method, parameters: params, encoding: URLEncoding.default, headers: HTTPHeaders(), interceptor: nil).response { (resp) in
                
                if resp.response?.statusCode==200{
                    //成功
                    let json = String(data: resp.data!, encoding: String.Encoding.utf8)
                    success(json ?? "")
                    
                }else{
                    //失败
                    let statusCode = resp.response?.statusCode
                    failure("\(statusCode ?? 0)请求失败")
                }
            }
            
        }
        
    }
    
    /** 上传图片*/
    
    public func postImage(url:String,params:[String:Any]?,_ data:Data,_ name:String,_ fileName:String,_ mineType:String,success:@escaping FXResponseSuccess,failure:@escaping FXResponseFailure){
        
        
        self.detachNetwork { (status) in
            
            if status==NetworkStatus.notReachable{return}
            
            var header = HTTPHeaders()
            header.add(name: "content-type", value: "multipart/form-data")
            AF.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(data, withName: name, fileName: fileName, mimeType: mineType)
            }, to: url,usingThreshold: MultipartFormData.encodingMemoryThreshold,method: .post,fileManager: .default).response { (resp) in
                
                if resp.response?.statusCode==200{
                    //成功
                    let json = String(data: resp.data!, encoding: String.Encoding.utf8)
                    success(json ?? "")
                    
                }else{
                    //失败
                    let statusCode = resp.response?.statusCode
                    failure("\(statusCode ?? 0)请求失败")
                }
            }
            
            
        }
    }
}

extension AlamofireManager{
    
    func detachNetwork(_ networkClosure:@escaping FXNetworkClosure) {
        let reachability = NetworkReachabilityManager()
        
        reachability?.startListening(onUpdatePerforming: { [weak self](status) in
            guard let weakSelf = self else { return }
            if reachability?.isReachable ?? false {
                
                switch status {
                case  .notReachable:
                    weakSelf.networkStatus = .notReachable
                case .unknown:
                    weakSelf.networkStatus = .unknown
                    
                case .reachable(.cellular):
                    weakSelf.networkStatus = .WLAN
                    
                case .reachable(.ethernetOrWiFi):
                    weakSelf.networkStatus = .wifi
                }
            }else{
                self?.networkStatus = .notReachable
            }
        })
        
        networkClosure(self.networkStatus)
    }
}
