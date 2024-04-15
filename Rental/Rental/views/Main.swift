import SwiftUI

struct Main: View {
    
    @State private var goToLogin = false
    @State private var rootScreen: RootView = .Main
    @State private var selectedTab = 0
    @State private var saveMode = ""
    @State private var showMap = false
    @State private var showAlert = false
    
    @EnvironmentObject var current: Current
    @EnvironmentObject var userAuthActions: UserAuthActions
    
    private let userDBActions = UserDBActions.getInstance()
    private let propertyDBActions = PropertyDBActions.getInstance()
    
    var body: some View {
        NavigationStack {
            switch(rootScreen) {
            case .Login:
                Login(rootScreen: self.$rootScreen)
                    .environmentObject(userDBActions)
            case .Signup:
                Signup(rootScreen: self.$rootScreen)
                    .environmentObject(userDBActions)
            case .Details:
                RentalDetails(rootScreen: self.$rootScreen, selectedTab: self.$selectedTab, saveMode: self.$saveMode)
                    .environmentObject(propertyDBActions)
                    .environmentObject(userDBActions)
            case .Save:
                RentalSave(rootScreen: self.$rootScreen, selectedTab: self.$selectedTab, saveMode: self.$saveMode)
                    .environmentObject(propertyDBActions)
                    .environmentObject(userDBActions)
            case .Main:
                TabView(selection: $selectedTab) {
                    Home(rootScreen: self.$rootScreen, selectedTab: self.$selectedTab, showMap: showMap)
                        .environmentObject(propertyDBActions)
                        .environmentObject(userDBActions)
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }
                        .tag(0)
                        .toolbarBackground(Color.white, for: .tabBar)
                        .toolbarBackground(.visible, for: .tabBar)
                    Favorites(rootScreen: self.$rootScreen, selectedTab: self.$selectedTab)
                        .environmentObject(propertyDBActions)
                        .environmentObject(userDBActions)
                        .tabItem {
                            Label("Favorites", systemImage: "star.fill")
                        }
                        .tag(1)
                        .toolbarBackground(Color.white, for: .tabBar)
                        .toolbarBackground(.visible, for: .tabBar)
                    RentalManagement(rootScreen: self.$rootScreen, selectedTab: self.$selectedTab, saveMode: self.$saveMode)
                        .environmentObject(propertyDBActions)
                        .environmentObject(userDBActions)
                        .tabItem {
                            Label("Management", systemImage: "pencil.and.list.clipboard")
                        }
                        .tag(2)
                        .toolbarBackground(Color.white, for: .tabBar)
                        .toolbarBackground(.visible, for: .tabBar)
                }
                .toolbar{
                    ToolbarItemGroup(placement: .navigationBarTrailing){
                        if selectedTab == 0 {
                            Button(showMap == true ? "List" : "Map"){showMap = !showMap}.padding(.horizontal)
                        }
                        LogInOrOutButton()
                    }
                }
                .onAppear() {
                    guard let email = UserDefaults.standard.string(forKey: "KEY_EMAIL"),
                          let password = UserDefaults.standard.string(forKey: "KEY_PASSWORD") else {
                        return
                    }
                    loginUser(email: email, password: password)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Logged out"), dismissButton: .default(Text("OK")))
                }
            }//Navigation Stack
        }
    }
    
    func LogInOrOutButton() -> some View {
        if current.user.name != "Guest" {
            return HStack{
                Button("Logout"){
                    userAuthActions.signOut()
                    current.setUser(AppUser())
                    UserDefaults.standard.set("", forKey: "KEY_EMAIL")
                    UserDefaults.standard.set("", forKey: "KEY_PASSWORD")
                    UserDefaults.standard.set("", forKey: "KEY_ID")
                    
                    rootScreen = .Main
                    selectedTab = 0
                    showAlert = true
                }
            }
        } else {
            return HStack{ Button("Login"){ rootScreen = .Login } }
        }
    }
    
    func loginUser(email: String, password: String) {
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
                    print(">>> INFO: Logged user: \(current.user.name)")
                    rootScreen = .Main
                }
            case .failure(let error):
                print(">>> ERROR: Not possible to perform async task! - \(error)")
            }
        }
    }
}

#Preview { Main() }
