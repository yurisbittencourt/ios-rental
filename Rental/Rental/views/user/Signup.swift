import SwiftUI
import FirebaseAuth

struct Signup: View {
    
    @Binding var rootScreen: RootView
    
    @EnvironmentObject var userAuthActions: UserAuthActions
    @EnvironmentObject var userDBActions: UserDBActions
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var type = UserTypeEnum.TENANT.rawValue
    @State private var name = ""
    
    //CONTROL
    @State private var success = false
    @State private var showAlert = false
    @State private var message = ""
    
    var body: some View {
        BackToButton(action: {rootScreen = .Main})
        
        VStack {
            Text("Sign up").font(.title).padding(.vertical)
            TextField("Name", text: $name)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            TextField("Email", text: $email)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            Picker("Property Type", selection: $type) {
                ForEach(UserTypeEnum.allCases, id: \.self) { userType in
                    Text(userType.rawValue).tag(userType.rawValue)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            ButtonView(label: "Sign Up", icon: "person.fill.badge.plus", action: signupUser).padding(.top, 10)
            
            Button("Already have an account? Log in"){ rootScreen = .Login }
                .padding(.top, 10)
            
            Spacer()
        }//VStack
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Sign Up!"), message: Text(message), dismissButton: .default(Text("OK")))
        }
        .padding()
    }
    
    func signupUser() {
        if (fieldsValidation()) {
            self.showAlert = false
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error as NSError? {
                    switch error.code {
                    case AuthErrorCode.emailAlreadyInUse.rawValue:
                        print(">>> ERROR: signUp - Email already exists!")
                    default:
                        print(">>> ERROR: signUp - Authentication failed!")
                    }
                    
                    print(error.localizedDescription)
                } else {
                    if let userId = Auth.auth().currentUser?.uid {
                        let newUser = AppUser(
                            id: userId,
                            name: name,
                            email: email,
                            password: password,
                            phone: "",
                            type: type,
                            favoritedProperties: [],
                            ownedProperties: []
                        )
                        userDBActions.create(newUser: newUser)
                        
                        DispatchQueue.main.async {
                            email = ""
                            password = ""
                            confirmPassword = ""
                            type = UserTypeEnum.TENANT.rawValue
                            name = ""
                            
                            success = true
                            showAlert = true
                            rootScreen = .Login
                        }
                    }
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if (!success) {
                    message = "Unable to create the account. Please, check email formation or try a different one, also check for password match and if it has six or more characteres!"
                    showAlert = true
                }
            }
        }
    }
    
    func fieldsValidation() -> Bool {
        showAlert = false
        
        if (name == "") { message = "Enter the name!" }
        else if (email == "") { message = "Enter the email!" }
        else if (password == "") { message = "Enter the password!" }
        else if (confirmPassword == "") { message = "Confirm password!" }
        else if (password != confirmPassword) { message = "Password mismatch!" }
        else {
            message = ""
            return true
        }
        
        showAlert = true
        
        return false
    }
}
