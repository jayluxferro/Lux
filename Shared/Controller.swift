//
//  Controller.swift
//  Lux (iOS)
//
//  Created by Jay on 09/01/2021.
//

import Foundation
import SwiftUI
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

class Controller: ObservableObject {
    @Published var log = ""
    @Published var isProcessing = false
    @Published var port = ""
    @Published var date = ""
    let plistConfig = Utils.parseConfig()
    
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
    }
    
    func verifyMomo(network: String, phone: String) {
        self.log = ""
        self.isProcessing = true
        
        // removing any spaces in phone number
        let phoneNumber = phone.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "+", with: "")
        let userId = plistConfig.object(forKey: "userid") as! String
        let phantom = plistConfig.object(forKey: "phantom") as! String
        let validateG = plistConfig.object(forKey: "validateG") as! String
        let csapi = plistConfig.object(forKey: "csapi") as! String
        let cs = plistConfig.object(forKey: "cs") as! String
        let cca = plistConfig.object(forKey: "cca") as! String
        
        let parameters = "{\"userid\":\"\(userId)\",\"phantom\":\"\(phantom)\",\"destinationbank\":\"\(network)\",\"accountnumber\":\"\(phoneNumber)\",\"type\":\"MOMO\",\"requestType\":\"\(validateG)\"}"
        let postData = parameters.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: csapi)!,timeoutInterval: Double.infinity)
        request.addValue(cs, forHTTPHeaderField: "Host")
        request.addValue("close", forHTTPHeaderField: "Connection")
        request.addValue("248", forHTTPHeaderField: "Content-Length")
        request.addValue("application/json, text/plain, */*", forHTTPHeaderField: "Accept")
        request.addValue("file://", forHTTPHeaderField: "Origin")
        request.addValue("Mozilla/5.0 (Linux; Android 10; 10.0 Build/QQ1D.200105.002; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/74.0.3729.186 Mobile Safari/537.36", forHTTPHeaderField: "User-Agent")
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.addValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
        request.addValue("en-US,en;q=0.9", forHTTPHeaderField: "Accept-Language")
        request.addValue("PHPSESSID=m7foji1ffc5h9lat02k4kgf13a", forHTTPHeaderField: "Cookie")
        request.addValue(cca, forHTTPHeaderField: "X-Requested-With")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async{
                if error != nil {
                    self.log = String(describing: error)
                }
                
                if let data = data {
                    self.log =  String(data: data, encoding: .utf8) ?? ""
                    
                }
                self.isProcessing = false
            }
        }
        
        task.resume()
    }
    
    func iConnect(){
        self.log = ""
        self.isProcessing = true
        
        var request = URLRequest(url: URL(string: plistConfig.object(forKey: "jt") as! String)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async{
                if error != nil {
                    self.log = String(describing: error)
                }
                
                if let data = data {
                    self.log =  String(data: data, encoding: .utf8) ?? ""
                    
                    // decoding response
                    if let decodedResponse = try? JSONDecoder().decode([iConnectResponse].self, from: data)  {
                        self.port = decodedResponse[0].url
                        self.date = decodedResponse[0].createdAt
                    }
                    
                }
                self.isProcessing = false
            }
        }
        
        task.resume()
    }
}
