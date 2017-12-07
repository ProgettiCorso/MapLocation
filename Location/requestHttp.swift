//
//  requestHttp.swift
//  test
//
//  Created by Fabio on 30/01/17.
//  Copyright © 2017 Fabio. All rights reserved.
//

import UIKit

class requestHttp{
    
    var url: String?
    var objParam:[String: String]?
    var token:String?
    
    func post(completation: @escaping (Int,NSDictionary) -> ()){
        
        var request = URLRequest(url: URL(string: url!)!)
        
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        if((token) != nil)
        {
            request.setValue(token!, forHTTPHeaderField: "Authorization")
        }
        
        if((objParam) != nil)
        {
            request.httpBody = try! JSONSerialization.data(withJSONObject: objParam as Any, options: [])
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Errore POST")
                return
            }
            
            
            let httpStatus = response as? HTTPURLResponse;
            
            completation((httpStatus?.statusCode ?? 500)!,self.json_parseData(data)!)
            
        }
        
        task.resume()
        
    }
    
    func get(completation: @escaping (Int,NSDictionary) -> ()){
        
        var parametri=""
        
        if((objParam) != nil)
        {
            for (key, value) in objParam!
            {
                parametri=parametri+key+"="+value+"&"
            }
            
            if(parametri.characters.count>0)
            {
                
                parametri=parametri.substring(to: parametri.index(parametri.startIndex, offsetBy: (parametri.characters.count)-1))
                
            }
        }
        
        let urlWithParams:String = url! + "?"+parametri
        
        
        let myUrl = NSURL(string: urlWithParams);
        let myUrl1 = URL(string: urlWithParams)
        let myUr2 = URL.init(string: urlWithParams)
        let request = NSMutableURLRequest(url:myUrl! as URL);
        
        request.httpMethod = "GET"
        
        if((token) != nil)
        {
            request.setValue(token!, forHTTPHeaderField: "Authorization")
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            
            data, response, error in
            guard let data = data, error == nil else {
                print("Errore GET")
                return
            }
            
            let httpStatus = response as? HTTPURLResponse;
            
            completation((httpStatus?.statusCode ?? 500)!,self.json_parseData(data)!)
            
        }
        
        task.resume()
        
    }
    
    func put(completation: @escaping (Int,NSDictionary) -> ()){
        
        
        var request = URLRequest(url: URL(string: url!)!)
        
        request.httpMethod = "PUT"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        if((token) != nil)
        {
            request.setValue(token!, forHTTPHeaderField: "Authorization")
            
        }
        
        if((objParam) != nil)
        {
            request.httpBody = try! JSONSerialization.data(withJSONObject: objParam as Any, options: [])
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Errore PUT")
                return
            }
            
            
            let httpStatus = response as? HTTPURLResponse;
            
            completation((httpStatus?.statusCode ?? 500)!,self.json_parseData(data)!)
            
            
        }
        
        task.resume()
        
    }
    
    func delete(completation: @escaping (Int,NSDictionary) -> ()){
        
        
        var request = URLRequest(url: URL(string: url!)!)
        
        request.httpMethod = "DELETE"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        if((token) != nil)
        {
            request.setValue(token!, forHTTPHeaderField: "Authorization")
        }
        
        if((objParam) != nil)
        {
            request.httpBody = try! JSONSerialization.data(withJSONObject: objParam as Any, options: [])
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Errore DELETE")
                return
            }
            
            let httpStatus = response as? HTTPURLResponse;
            
            completation((httpStatus?.statusCode ?? 500)!,self.json_parseData(data)!)
            
        }
        
        task.resume()
        
    }
    
    private func json_parseData(_ data: Data) -> NSDictionary? {
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers)
            return (json as? NSDictionary)
        } catch _ {
            print("Errore JSONPARSE")
            return nil
        }
        
    }
}

