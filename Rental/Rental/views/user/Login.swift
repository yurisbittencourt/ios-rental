import SwiftUI

struct Login: View {
    
    @Binding var rootScreen: RootView
    
    @EnvironmentObject var current: Current
    @EnvironmentObject var userAuthActions: UserAuthActions
    @EnvironmentObject var userDBActions: UserDBActions
    
    @State private var email = ""
    @State private var password = ""
    
    //CONTROL
    @State private var success = false
    @State private var showAlert = false
    @State private var message = ""
    
    var body: some View {
        BackToButton(action: {rootScreen = .Main})
        VStack {
            Text("Log in").font(.title).padding(.vertical)
            TextField("Email", text: $email)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            ButtonView(label: "Login", color: 1, icon: "person.badge.shield.checkmark.fill") {
                loginUser(email: email, password: password)
            }.padding(.top, 10)
            
            Button("Don't have an account? Sign up") {
                self.rootScreen = .Signup
            }
            .padding(.top, 10)
            Spacer()
        }//VStack
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Login!"), message: Text(message), dismissButton: .default(Text("OK")))
        }
        .padding()
        .padding(.horizontal)
    }
    
    func loginUser(email: String, password: String) {
        if (fieldsValidation()) {
            self.showAlert = false
            
            userAuthActions.signIn(email: email, password: password) { result in
                switch result {
                case .success:
                    let userId = UserDefaults.standard.string(forKey: "KEY_ID")
                    if (userId != "") {
                        userDBActions.getUserByID(userID: userId!) { user, error in
                            if let user = user {
                                current.setUser(user)
                                print(">>> INFO: User found:", user)
                            } else if let error = error {
                                print(">>> ERROR: Not possible to perform user search! - ", error.localizedDescription)
                            } else {
                                print(">>> ERROR: User not found!")
                            }
                        }
                        
                        success = true
                        print(">>> INFO: Logged user: \(current.user.name)")
                        rootScreen = .Main
                    }
                case .failure(let error):
                    print(">>> ERROR: Not possible to perform async task! - \(error)")
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if (!success) {
                    message = "User not found!"
                    showAlert = true
                }
            }
        }
    }
    
    func fieldsValidation() -> Bool {
        showAlert = false
        
        if (email == "") { message = "Enter the email!" }
        else if (password == "") { message = "Enter the password!" }
        else {
            message = ""
            return true
        }
        
        showAlert = true
        
        return false
    }
}
