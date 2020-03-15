//
//  ModelUser.swift
//  TestTask
//
//  Created by Sergey Vorobey on 06/03/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import Foundation
import UIKit


struct UsersAuth {
    
     var login: String
     var password: String
}

struct UserProvider {
    
    var user: UsersAuth {
        return admin
    }
}

let admin = UsersAuth(login: "Admin", password: "123456")
