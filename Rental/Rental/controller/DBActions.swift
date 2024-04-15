import Foundation
import FirebaseFirestore
import FirebaseStorage

class DBActions : ObservableObject{
    
    let db : Firestore
    
    init(db : Firestore) { self.db = db }
    
    let storage = Storage.storage()
}
