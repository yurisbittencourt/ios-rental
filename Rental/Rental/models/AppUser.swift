import Foundation

struct AppUser: Codable {
    
    var id: String
    var name: String
    var email: String
    var password: String
    var phone: String
    var type: String
    var favoritedProperties: [String]
    var ownedProperties: [String]
    
    init(
        id: String,
        name: String,
        email: String,
        password: String,
        phone: String,
        type: String,
        favoritedProperties: [String],
        ownedProperties: [String]) {
            self.id = id
            self.name = name
            self.email = email
            self.password = password
            self.phone = phone
            self.type = type
            self.favoritedProperties = favoritedProperties
            self.ownedProperties = ownedProperties
        }
    
    init() {
        self.id = "id"
        self.name = "Guest"
        self.email = "N/A"
        self.password = "N/A"
        self.phone = "N/A"
        self.type = UserTypeEnum.TENANT.rawValue
        self.favoritedProperties = []
        self.ownedProperties = []
    }
}

enum UserTypeEnum: String, CaseIterable {
    case TENANT
    case LANDLORD
}
