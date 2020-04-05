//
//  AlamofireObj.swift
//  Alamofire学习
//
//  Created by 飞翔 on 2020/4/5.
//  Copyright © 2020 飞翔. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class AlamofireObj: NSObject {
    
    var comment:Int = 0
    var down:Int = 0
    var forward:Int = 0
    var header:String = ""
    var name:String = ""
    var passtime:String = ""
    var sid:Int = 0
    var text:String = ""
    var type:String = ""
    var up:Int = 0
    var uid:Int = 0;
    
    init(dict:[String:JSON]) {
        
        self.comment = dict["comment"]!.intValue;
        self.down = dict["down"]!.intValue
        self.forward = dict["forward"]!.intValue;
        self.header = dict["header"]!.stringValue
        self.name = dict["name"]!.stringValue
        self.passtime = dict["passtime"]!.stringValue
        self.sid = dict["sid"]!.intValue
        self.text = dict["text"]!.stringValue
        self.type = dict["type"]!.stringValue
        self.up = dict["up"]!.intValue
        self.uid = dict["uid"]!.intValue
    }
}

extension AlamofireObj{
    
    static  func loadHttpData( _ urlString:String,_ index:Int,_ originAry:NSMutableArray, _ dataClosure:@escaping (NSMutableArray)->()){
        AF.request(urlString).responseJSON { (resp) in
            
            if let response = resp.value{
                
                let responseDict = response as! [String:AnyObject]
                
                let jsonData = JSON.init(rawValue: responseDict["result"]!)
                if let data = jsonData{
                    if index==1 {
                        originAry.removeAllObjects()
                    }
                    for (_,subJson) in data {
                        
                        let obj = AlamofireObj.init(dict: subJson.dictionary!)
                        originAry.add(obj)
                    }
                    
                    dataClosure(originAry)
                }
                
            }
        }
        
    }
}
