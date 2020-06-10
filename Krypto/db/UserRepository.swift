//
//  UserRepository.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/6/10.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import Foundation
import RealmSwift

class UserRepository {
    func isLoginValid(name: String, password: String) -> Bool {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "loginId = %@ AND password = %@", name, password)
        let result = realm.objects(User.self).filter(predicate)
        if result.count == 0 {
            return false
        } else {
            return true
        }
    }
    
    func checkSampleUser() {
        let realm = try! Realm()
        if realm.objects(User.self).count == 0 {
            let user = User()
            user.firstName = "Gary"
            user.lastName = "Bereren"
            user.loginId = "bereren1234"
            user.password = "88888888"
            try! realm.write {
                realm.add(user)
            }
        }
    }
}
