import Foundation
import FirebaseFirestoreSwift

class Property: Codable, Hashable, Identifiable, ObservableObject {
    
    var id: String
    var image: String?
    let title: String
    let type: String
    let owner: String
    let bedroom: Int
    let bathroom: Int
    let kitchen: Int
    let closet: Int
    let laundry: Int
    let livingRoom: Int
    let balcony: Int
    let squareFeet: Double
    let rent: Double
    let propertyDescription: String
    let address: String
    let city: String
    let postalCode: String
    let isRent: Bool
    let additionalInformation: String
    let lat: Double
    let lon: Double
    
    init() {
        self.id = ""
        self.image = ""
        self.title = ""
        self.type = PropertyTypeEnum.APARTMENT.rawValue
        self.owner = ""
        self.bedroom = 0
        self.bathroom = 0
        self.kitchen = 0
        self.closet = 0
        self.laundry = 0
        self.livingRoom = 0
        self.balcony = 0
        self.squareFeet = 0.0
        self.rent = 0.0
        self.propertyDescription = ""
        self.address = ""
        self.city = ""
        self.postalCode = ""
        self.isRent = true
        self.additionalInformation = ""
        self.lat = 0.0
        self.lon = 0.0
    }
    
    init(
        id: String,
        image: String,
        title: String,
        type: String,
        owner: String,
        bedroom: Int,
        bathroom: Int,
        kitchen: Int,
        closet: Int,
        laundry: Int,
        livingRoom: Int,
        balcony: Int,
        squareFeet: Double,
        rent: Double,
        propertyDescription: String,
        address: String,
        city: String,
        postalCode: String,
        isRent: Bool,
        additionalInformation: String,
        lat: Double,
        lon: Double) {
            self.id = id == "" ? UUID().uuidString : id
            self.image = image
            self.title = title
            self.type = type
            self.owner = owner
            self.bedroom = bedroom
            self.bathroom = bathroom
            self.kitchen = kitchen
            self.closet = closet
            self.laundry = laundry
            self.livingRoom = livingRoom
            self.balcony = balcony
            self.squareFeet = squareFeet
            self.rent = rent
            self.propertyDescription = propertyDescription
            self.address = address
            self.city = city
            self.postalCode = postalCode
            self.isRent = isRent
            self.additionalInformation = additionalInformation
            self.lat = lat
            self.lon = lon
        }
    
    static func getEnum(value : String) -> PropertyTypeEnum {
        if let index = PropertyTypeEnum.allCases.firstIndex(where: { $0.rawValue == value }) {
            return PropertyTypeEnum.allCases[index]
        }
        
        return .APARTMENT
    }
    
    static func == (lhs: Property, rhs: Property) -> Bool { return lhs.id == rhs.id }
    
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

enum PropertyTypeEnum: String, CaseIterable {
    case APARTMENT
    case HOUSE
    case CONDO
    case TOWNHOUSE
}
