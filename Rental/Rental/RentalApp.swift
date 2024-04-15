
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore

@main
struct RentalApp: App {
    
    private let current = Current()
    private let userAuthActions = UserAuthActions()
    private let locationHelper = LocationHelper()
    
    
    init(){
        FirebaseApp.configure()
        let userDBActions = UserDBActions.getInstance()
    }
    
    var body: some Scene {
        WindowGroup {
            Main()
                .environmentObject(current)
                .environmentObject(userAuthActions)
                .environmentObject(locationHelper)
        }
    }
}
