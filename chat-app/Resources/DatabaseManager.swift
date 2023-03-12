//
//  DatabaseManager.swift
//  chat-app
//
//  Created by Nurzhamal Shaliyeva on 11.03.2023.
//

import Foundation
import Firebase
// in ChatViewController we want to pull out the messages

//wraps all the value that we want to insert
struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
//    let profilePiCUrl: String
}

//this class can not be subclassed
// singleton, just fir the easy-read-and-write access
final class DatabaseManager {
    static let shared = DatabaseManager()
    
    //reference the databse, private - so that no one can pull this externally
    private let database = Database.database().reference()
    
    
}

//MARK: Account Management
extension DatabaseManager {
    //this will return TRUE if the user's email DOESN'T exist, FALSE otherwise
    public func userExists(with email: String, completion: @escaping((Bool) -> Void)) {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
    
        //snapshot has a value that can be optional if the email doesn't exist
        //snapshot is Any, we need to cast it to String
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion (true)
        }
    }
    
    
    //once the func is called, its gonna insert into the db
    /// Inserts the new User
    public func insertUser(with user: ChatAppUser) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ])
    }
}
