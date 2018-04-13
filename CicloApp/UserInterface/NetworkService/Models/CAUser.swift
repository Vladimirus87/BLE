//
//  CAUser.swift
//  CicloApp
//
//  Created by Владимир Моисеев on 12.04.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import Foundation

struct CAUser {

    var email: String
    var password: String
    var repeatPassword: String
    
    init(email: String, password: String, repeatPassword: String) {
        self.email = email
        self.password = password
        self.repeatPassword = repeatPassword
    }
    
    init(login: String, password: String) {
        self.email = login
        self.password = password
        self.repeatPassword = password
    }

}
