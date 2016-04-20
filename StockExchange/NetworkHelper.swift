//
//  NetworkHelper.swift
//  StockExchange
//
//  Created by Archita Bansal on 20/04/16.
//  Copyright © 2016 Archita Bansal. All rights reserved.
//

import UIKit

protocol GraphDataDelegate{
    
    func getStringData(data:NSString)
    
}



class NetworkHelper: NSObject,NSURLSessionDataDelegate,NSURLSessionDelegate {
    
    static var sharedInstance = NetworkHelper()
    
    var delegate : GraphDataDelegate?
    
    func sendGetRequest(url:NSURL){
        
        let request = NSMutableURLRequest(URL:url)
        request.HTTPMethod = "GET"
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
        let task = session.dataTaskWithRequest(request)
        
        task.resume()
        
        
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        
        let stringData = NSString(data: data, encoding: NSUTF8StringEncoding)
        print(stringData)
        if let data = stringData{
            
            if delegate?.getStringData(data) != nil{
                
                delegate?.getStringData(data)
            }
            
        }
        
    }
    
    
    

}
