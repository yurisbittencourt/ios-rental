
import Foundation
import FirebaseAuth

class UserAuthActions: ObservableObject{
    
    @Published var user : User?{ didSet { objectWillChange.send() } }
    
    func listenToAuthState(){
        Auth.auth().addStateDidChangeListener{ [weak self] _, user in
            guard let self = self else { return }
            self.user = user
        }
    }
    
    func signUp(email : String, password : String){
        Auth.auth().createUser(withEmail: email, password: password){ [self] authResult, error in
            guard let result = authResult else{
                print(#function, ">>> ERROR: Error while creating account : \(error)")
                return
            }
            
            print(#function, "AuthResult : \(result)")
            
            switch authResult{
            case .none:
                print(#function, ">>> ERROR: Unable to create the account")
            case .some(_):
                print(#function, ">>> INFO: Successfully created user account")
                self.user = authResult?.user
            }
            
        }
    }
    
    func signIn(email : String, password : String, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global().async {
            Auth.auth().signIn(withEmail: email, password: password){ [self] authResult, error in
                guard let result = authResult else{
                    print(#function, ">>> ERROR: Error while logging in : \(String(describing: error))")
                    return
                }
                
                print(#function, ">>> INFO: AuthResult : \(result)")
                
                switch authResult {
                case .none:
                    print(#function, ">>> ERROR: Unable to sign in")
                case .some(_):
                    print(#function, ">>> INFO: Login Successful")
                    self.user = authResult?.user
                    
                    print(#function, ">>> INFO: Logged in user : \(self.user?.displayName ?? "NA" )")
                    
                    UserDefaults.standard.set(self.user?.email, forKey: "KEY_EMAIL")
                    UserDefaults.standard.set(password, forKey: "KEY_PASSWORD")
                    UserDefaults.standard.set(self.user?.uid, forKey: "KEY_ID")
                    
                    completion(.success(()))
                }
            }
        }
    }
    
    func signOut(){
        do{
            try Auth.auth().signOut()
        } catch let err as NSError{
            print(#function, ">>> ERROR: Unable to sign out the user : \(err)")
        }
    }
}
