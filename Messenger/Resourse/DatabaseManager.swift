//
//  DatabaseManager.swift
//  Messenger
//
//  Created by Valerian   on 19/11/2020.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
}

//MARK: - Account Management

extension DatabaseManager {
    public func userExist(with email: String, completion: @escaping ((Bool) -> Void)) {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        database.child(safeEmail).observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)        }
    }
    
    public func insertUser(with user:ChapAppUser) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ])
    }
}

struct ChapAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    
    var safeEmail: String {
        var safemail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safemail = safemail.replacingOccurrences(of: "@", with: "-")
        return safemail
    }
}
