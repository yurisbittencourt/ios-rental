
import Foundation
import FirebaseFirestore

class PropertyDBActions : DBActions{
    
    @Published var propertyList = [Property]()
    
    private static var shared : PropertyDBActions?
    
    private let COLLECTION_PROPERTIES : String = "properties"
    
    private let fieldId = "id"
    private let fieldImage = "image"
    private let fieldTitle = "title"
    private let fieldType = "type"
    private let fieldOwner = "owner"
    private let fieldBedroom = "bedroom"
    private let fieldBathroom = "bathroom"
    private let fieldKitchen = "kitchen"
    private let fieldCloset = "closet"
    private let fieldLaundry = "laundry"
    private let fieldLivingRoom = "livingRoom"
    private let fieldBalcony = "balcony"
    private let fieldSquareFeet = "squareFeet"
    private let fieldRent = "rent"
    private let fieldPropertyDescription = "propertyDescription"
    private let fieldAddress = "address"
    private let fieldCity = "city"
    private let fieldPostalCode = "postalCode"
    private let fieldIsRent = "isRent"
    private let fieldAdditionalInformation = "additionalInformation"
    private let fieldLat = "lat"
    private let fieldLon = "lon"
    
    static func getInstance() -> PropertyDBActions{
        if (shared == nil){
            shared = PropertyDBActions(db: Firestore.firestore())
        }
        
        return shared!
    }
    
    func update(property: Property) {
        do {
            var data = [String: Any]()
            
            data[fieldId] = property.id
            data[fieldImage] = property.image
            data[fieldTitle] = property.title
            data[fieldType] = property.type
            data[fieldOwner] = property.owner
            data[fieldBedroom] = property.bedroom
            data[fieldBathroom] = property.bathroom
            data[fieldKitchen] = property.kitchen
            data[fieldCloset] = property.closet
            data[fieldLaundry] = property.laundry
            data[fieldLivingRoom] = property.livingRoom
            data[fieldBalcony] = property.balcony
            data[fieldSquareFeet] = property.squareFeet
            data[fieldRent] = property.rent
            data[fieldPropertyDescription] = property.propertyDescription
            data[fieldAddress] = property.address
            data[fieldCity] = property.city
            data[fieldPostalCode] = property.postalCode
            data[fieldIsRent] = property.isRent
            data[fieldAdditionalInformation] = property.additionalInformation
            data[fieldLat] = property.lat
            data[fieldLon] = property.lon
            
            db.collection(COLLECTION_PROPERTIES)
                .document(property.id)
                .updateData(data) { error in
                    if let error = error {
                        print(">>> ERROR: rentalSave - update - Failure! \(error)")
                    } else {
                        print(">>> INFO: rentalSave - update - Success!")
                    }
                }
        } catch {
            print(">>> ERROR: rentalSave - Exception! \(error)")
        }
    }
    
    func create(property: Property, completion: @escaping (Property?, Error?) -> Void) {
        do {
            var data = [String: Any]()
            
            data[fieldId] = property.id
            data[fieldImage] = property.image
            data[fieldTitle] = property.title
            data[fieldType] = property.type
            data[fieldOwner] = property.owner
            data[fieldBedroom] = property.bedroom
            data[fieldBathroom] = property.bathroom
            data[fieldKitchen] = property.kitchen
            data[fieldCloset] = property.closet
            data[fieldLaundry] = property.laundry
            data[fieldLivingRoom] = property.livingRoom
            data[fieldBalcony] = property.balcony
            data[fieldSquareFeet] = property.squareFeet
            data[fieldRent] = property.rent
            data[fieldPropertyDescription] = property.propertyDescription
            data[fieldAddress] = property.address
            data[fieldCity] = property.city
            data[fieldPostalCode] = property.postalCode
            data[fieldIsRent] = property.isRent
            data[fieldAdditionalInformation] = property.additionalInformation
            data[fieldLat] = property.lat
            data[fieldLon] = property.lon
            
            db.collection(COLLECTION_PROPERTIES)
                .document(property.id)
                .setData(data) { error in
                    if let error = error {
                        print(">>> INFO: rentalSave - Failure! \(error)")
                        completion(nil, error)
                    } else {
                        print(">>> INFO: rentalSave - Success!")
                        self.getAll()
                        completion(property, nil)
                    }
                }
        } catch {
            print(">>> INFO: rentalSave - Exception! \(error)")
            completion(nil, error)
        }
    }
    
    func getAll() {
        var properties: [Property] = []
        db.collection(COLLECTION_PROPERTIES).getDocuments { (querySnapshot, error) in
            if let error = error {
                print(">>> ERROR: Error getting documents: \(error)")
                return
            } else {
                do {
                    for document in querySnapshot!.documents {
                        if let property: Property? = try document.data(as: Property.self) {
                            properties.append(property!)
                        }
                    }
                    self.propertyList = properties
                } catch let error {
                    print(">>> ERROR: Error decoding document: \(error)")
                }
            }
        }
    }
    
    func delete(property: Property) {
        let propertyRef = db.collection(COLLECTION_PROPERTIES).document(property.id)
        
        propertyRef.delete { error in
            if let error = error {
                print(">>> ERROR: Error deleting document: \(error)")
            } else {
                self.getAll()
                print(">>> INFO: Document successfully deleted!")
            }
        }

        guard let fileName = URL(string: property.image!)?.lastPathComponent else {
            print(">>> ERROR: deletePropertyImage - Failed to extract file name from URL")
            return
        }

        storage.reference(forURL: property.image!).delete { error in
            if let error = error {
                print(">>> ERROR: deletePropertyImage - Deleting file: \(error)")
            } else {
                self.getAll()
                print(">>> INFO: deletePropertyImage - File deleted successfully")
            }
        }
    }
}
