//
//  ViewController.swift
//  AllTesting
//
//  Created by willie on 25/06/2016.
//  Copyright © 2016 willie. All rights reserved.
//

import UIKit
import Alamofire


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchAllRooms(completion: ([RemoteRoom]?) -> Void) {
        Alamofire.request(
            .GET,
            "http://localhost:5984/rooms/_all_docs",
            parameters: ["include_docs": "true"],
            encoding: .URL)
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(response.result.error)")
                    completion(nil)
                    return
                }
                
                guard let value = response.result.value as? [String: AnyObject],
                    rows = value["rows"] as? [[String: AnyObject]] else {
                        print("Malformed data received from fetchAllRooms service")
                        completion(nil)
                        return
                }
                
                var rooms = [RemoteRoom]()
                for roomDict in rows {
                    rooms.append(RemoteRoom(jsonData: roomDict))
                }
                
                completion(rooms)
        }
    }

}

