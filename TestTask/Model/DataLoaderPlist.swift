//
//  DataLoaderPlist.swift
//  TestTask
//
//  Created by Sergey Vorobey on 12/03/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation

class DataLoaderPlist {
    
    var userData = [UserDataPlist]()
    
    init() {
            load()
            sort()
        }
    
    func load() {
        
        guard let path = Bundle.main.path(forResource: "DataUsers", ofType: "plist") else { return }
        guard let dict = NSDictionary(contentsOfFile: path) else { return }

            for (_, value) in (dict["Users"] as? [String: Any])! {
                
                var oneUser: UserDataPlist = UserDataPlist()
                
                for (localKey, localValue) in ((value as? [String: Any])!) {
                    
                    switch localKey {
                        
                    case "firstName":
                        oneUser.firstName = localValue as? String
                    case "lastName":
                        oneUser.lastName = localValue as? String
                    case "age":
                        oneUser.age = localValue as? String
                    case "userId":
                        oneUser.userId = localValue as? String
                    default:
                        break
                    }
                }
            userData.append(oneUser)
        }
    }
    
    func sort() {
        self.userData = self.userData.sorted(by: { $0.userId! < $1.userId! })
    }
}
