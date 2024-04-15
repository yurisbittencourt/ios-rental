import Foundation

class Current: ObservableObject {
    
    @Published var user: AppUser = AppUser()
    @Published var property: Property = Property()
    
    func setUser(_ currentUser: AppUser) {
        user = currentUser
    }
    
    func setProperty(_ currentProperty: Property) {
        property = currentProperty
    }
}
