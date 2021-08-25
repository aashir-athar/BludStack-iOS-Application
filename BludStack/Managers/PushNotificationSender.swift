


import Foundation
import UIKit
class PushNotificationSender {
    
    func sendPushNotification(to token: String, title: String, body: String) {

        print(token)
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "content_available" : true,
                                           "data" : [
                                                     "body" : "\(body) ",
                                                     "title" : "GetDonor"]
        ]
        
       
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAz_RkAEM:APA91bEqx7Xs4tuHPQ1hasgkz_4Ws9CmJa-JXoA8msKFB1tvvka94lT4Im_nh_mtQ9U5AvCJP6NHEzsFIiCp8U2EJKLoAYpmBU2PoULcPInVMZ91c9UAYVjWbjekDrFQwQsvwJT-eT8h", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}

