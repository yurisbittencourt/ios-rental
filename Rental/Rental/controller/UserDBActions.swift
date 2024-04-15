//
//  UserDBActions.swift
//  Rental
//
//  Created by Yuri Bittencourt on 2024-03-09.
//

import Foundation
import FirebaseFirestore

class UserDBActions : DBActions{
    
    private static var shared : UserDBActions?
    
    private let COLLECTION_USERS : String = "users"
    
    private let fieldId = "id"
    private let fieldName = "name"
    private let fieldEmail = "email"
    private let fieldPassword = "password"
    private let fieldPhone = "phone"
    private let fieldType = "type"
    private let fieldFavoritedProperties = "favoritedProperties"
    private let fieldOwnedProperties = "ownedProperties"
    
    static func getInstance() -> UserDBActions{
        if (shared == nil){
            shared = UserDBActions(db: Firestore.firestore())
        }
        
        return shared!
    }
    
    func getUserByID(userID: String, completion: @escaping (AppUser?, Error?) -> Void) {
        let userRef = db.collection(COLLECTION_USERS).document(userID)
        
        userRef.getDocument { (document, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let document = document, document.exists {
                do {
                    if let user = try document.data(as: AppUser?.self) {
                        completion(user, nil)
                    } else {
                        completion(nil, NSError(domain: "Parsing Error", code: 0, userInfo: nil))
                    }
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, NSError(domain: "User Not Found", code: 0, userInfo: nil))
            }
        }
    }
    
    func create(newUser: AppUser) {
        do {
            var data = [String: Any]()
            
            data[fieldId] = newUser.id
            data[fieldName] = newUser.name
            data[fieldEmail] = newUser.email
            data[fieldPassword] = newUser.password
            data[fieldPhone] = newUser.phone
            data[fieldType] = newUser.type
            data[fieldFavoritedProperties] = newUser.favoritedProperties
            data[fieldOwnedProperties] = newUser.ownedProperties
            
            db.collection(COLLECTION_USERS)
                .document(newUser.id)
                .setData(data) { error in
                    if let error = error {
                        print(">>> ERROR: signupNewUser - Failure! \(error)")
                    } else {
                        print(">>> INFO: signupNewUser - Success!")
                    }
                }
        } catch {
            print(">>> INFO: signupNewUser - Exception! \(error)")
        }
    }
    
    func update(user: AppUser) {
        //TODO: Take appropriate actions if user has already favorited/owned property
        do {
            var data = [String: Any]()
            
            data[fieldId] = user.id
            data[fieldName] = user.name
            data[fieldEmail] = user.email
            data[fieldPassword] = user.password
            data[fieldPhone] = user.phone
            data[fieldType] = user.type
            data[fieldFavoritedProperties] = user.favoritedProperties
            data[fieldOwnedProperties] = user.ownedProperties
            
            db.collection(COLLECTION_USERS)
                .document(user.id)
                .updateData(data) { error in
                    if let error = error {
                        print(">>> ERROR: signupNewUser - Failure! \(error)")
                    } else {
                        print(">>> INFO: signupNewUser - Success!")
                    }
                }
        } catch {
            print(">>> INFO: signupNewUser - Exception! \(error)")
        }
    }
}
