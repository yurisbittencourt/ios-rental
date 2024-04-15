
import SwiftUI
import PhotosUI

struct RentalSave: View {
    
    @Binding var rootScreen: RootView
    @Binding var selectedTab: Int
    @Binding var saveMode: String
    
    @EnvironmentObject var userDBActions: UserDBActions
    @EnvironmentObject var propertyDBActions: PropertyDBActions
    @EnvironmentObject var current: Current
    @EnvironmentObject var property: Property
    
    @State private var id: String = ""
    @State private var imageURL: URL?
    @State private var title: String = ""
    @State private var rent: String = ""
    @State private var type = PropertyTypeEnum.APARTMENT.rawValue
    @State private var owner: String = ""
    @State private var bedroom: String = ""
    @State private var bathroom: String = ""
    @State private var kitchen: String = ""
    @State private var closet: String = ""
    @State private var laundry: String = ""
    @State private var livingRoom: String = ""
    @State private var balcony: String = ""
    @State private var squareFeet: String = ""
    @State private var propertyDescription: String = ""
    @State private var address: String = ""
    @State private var city: String = ""
    @State private var postalCode: String = ""
    @State private var isRent: Bool = true
    @State private var additionalInformation: String = ""
    @State private var lat: String = ""
    @State private var lon: String = ""
    
    //CONTROL
    @State private var showAlert = false
    @State private var message = ""
    @State private var saveProperty = Property()
    
    //CAMERA
    @State private var profileImage : UIImage?
    @State private var showSheet: Bool = false
    @State private var permissionGranted: Bool = false
    @State private var showPicker : Bool = false
    @State private var isUsingCamera : Bool = false
    
    //LOCATION
    @EnvironmentObject var locationHelper : LocationHelper
    
    var body: some View {
        BackToButton { rootScreen = .Main }
        
        VStack {
            PageTitle(saveMode == "insert" ? "Post Rental" : "Update Rental")
           
            Form {
                Section(header: Text("Ad Photo:")){
                    if (saveMode == "insert") {
                        Image(uiImage: profileImage ?? UIImage(systemName: "photo")!)
                            .resizable()
                            .frame(width: 300, height: 200, alignment: .center)
                    } else if (saveMode == "update") {
                        Image(uiImage: profileImage ?? loadImageFromFirebaseStorage()!)
                            .resizable()
                            .frame(width: 300, height: 200, alignment: .center)
                    }
                    
                    Button(action:{
                        if (self.permissionGranted){
                            self.showSheet = true
                        } else {
                            self.requestPermission()
                        }
                    }){
                        Text("Upload Picture")
                            .padding()
                    }
                    .actionSheet(isPresented: self.$showSheet){
                        ActionSheet(title: Text("Select Photo"),
                                    message: Text("Choose profile picture to upload"),
                                    buttons: [
                                        .default(Text("Choose photo from library")){
                                            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                                                print(#function, "The PhotoLibrary isn't available")
                                                return
                                            }
                                            self.isUsingCamera = false
                                            self.showPicker = true
                                        },
                                        .default(Text("Take a new pic from Camera")){
                                            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                                                print(#function, "Camera isn't available")
                                                return
                                            }
                                            
                                            self.isUsingCamera = true
                                            self.showPicker = true
                                        },
                                        .cancel()
                                    ])
                    }
                }
                
                Section(header: Text("Ad Title: *")){
                    TextField("Enter the rental ad title", text: $title)
                }
                
                Section(header: Text("Rent ($ CAD): *")){
                    TextField("Enter the rent value ($ CAD)", text: $rent)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Property Type: *")) {
                    Picker(selection: $type, label: Text("Property Type")) {
                        ForEach(PropertyTypeEnum.allCases, id: \.self) { propertyType in
                            Text(propertyType.rawValue).tag(propertyType.rawValue)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        VStack {
                            Text("Bedroom")
                                .font(.callout)
                                .frame(height: 50)
                            TextField("0", text: $bedroom)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .frame(width: 60)
                        }
                        
                        VStack {
                            Text("Bathroom")
                                .font(.callout)
                                .frame(height: 50)
                            TextField("0", text: $bathroom)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .frame(width: 60)
                        }
                        
                        VStack {
                            Text("Kitchen")
                                .font(.callout)
                                .frame(height: 50)
                            TextField("0", text: $kitchen)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .frame(width: 60)
                        }
                        
                        VStack {
                            Text("Closet")
                                .font(.callout)
                                .frame(height: 50)
                            TextField("0", text: $closet)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .frame(width: 60)
                        }
                    }
                    
                    HStack {
                        VStack {
                            Text("Laundry")
                                .font(.callout)
                                .frame(height: 50)
                            TextField("0", text: $laundry)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .frame(width: 64)
                        }
                        
                        VStack {
                            Text("Living Room")
                                .font(.callout)
                                .frame(height: 50)
                            TextField("0", text: $livingRoom)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .frame(width: 64)
                        }
                        
                        VStack {
                            Text("Balcony")
                                .font(.callout)
                                .frame(height: 50)
                            TextField("0", text: $balcony)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .frame(width: 64)
                        }
                        
                        VStack {
                            Text("Square Feet")
                                .font(.callout)
                                .frame(height: 50)
                            TextField("0", text: $squareFeet)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                                .frame(width: 64)
                        }
                    }
                }
                
                Section {
                    Text("Address: *")
                        .font(.callout)
                    TextField("Enter the rental address", text: $address)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("ZIP Code: *")
                                .font(.callout)
                            TextField("Enter the ZIP code", text: $postalCode)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: UIScreen.main.bounds.width * 0.25)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("City: *")
                                .font(.callout)
                            TextField("Enter the city", text: $city)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: UIScreen.main.bounds.width * 0.55)
                        }
                    }.padding(.horizontal, UIScreen.main.bounds.width * 0.05)
                    ButtonView(label: "Foward Geocoding", color: 1, small: true, action: fowardGeocoding).padding(.horizontal)
                }
                
                Section {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Latitude: *")
                                .font(.callout)
                            TextField("0", text: $lat)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .frame(width: UIScreen.main.bounds.width * 0.40)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Longitude: *")
                                .font(.callout)
                            TextField("0", text: $lon)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .frame(width: UIScreen.main.bounds.width * 0.40)
                        }
                    }.padding(.horizontal, UIScreen.main.bounds.width * 0.05)
                    ButtonView(label: "Reverse Geocoding", color: 4, small: true, action: reverseGeocoding).padding(.horizontal)
                }
                
                Section(header: Text("Description: *")){
                    TextField("Enter the rental description", text: $propertyDescription)
                }
                
                Section(header: Text("Additional Information: *")){
                    TextField("Enter the rental additional information", text: $additionalInformation)
                }
                
                Section {
                    Toggle("Active Rent?", isOn:$isRent)
                        .toggleStyle(SwitchToggleStyle(tint:Color.black))
                }
            }
            
            ButtonView(label: "Save", color: 3, icon:"checkmark.rectangle.stack", action: saveButtonAction).padding(.horizontal)
            Spacer()
        }//VStack
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Rent!"), message: Text(message), dismissButton: .default(Text("OK")))
        }
        .fullScreenCover(isPresented: self.$showPicker){
            if (isUsingCamera) {
                CameraPicker(selectedImage: self.$profileImage)
            } else {
                LibraryPicker(selectedImage: self.$profileImage)
            }
        }
        .onAppear{
            setMode()
            self.checkPermission()
        }
    }
    
    /* ################## */
    /* ### PERMISSION ### */
    /* ################## */
    
    func checkPermission(){
        switch PHPhotoLibrary.authorizationStatus(){
        case .authorized:
            self.permissionGranted = true
        case .notDetermined, .denied:
            self.permissionGranted = false
            self.requestPermission()
        case .limited, .restricted: break
        @unknown default:
            return
        }
    }
    
    func requestPermission(){
        PHPhotoLibrary.requestAuthorization{ status in
            switch status{
            case .authorized:
                self.permissionGranted = true
            case .notDetermined, .denied:
                self.permissionGranted = false
            case .limited, .restricted: break
            @unknown default:
                return
            }
        }
    }
    
    /* ################# */
    /* #### CAMERA ##### */
    /* ################# */
    
    func loadImageFromFirebaseStorage() -> UIImage? {
        if let url = imageURL {
            if let imageData = try? Data(contentsOf: url) {
                if let uiImage = UIImage(data: imageData) {
                    return uiImage
                }
            }
        }
        
        return UIImage(systemName: "photo")
    }
    
    func cameraSave(completion: @escaping (String) -> Void) {
        var imageName = "\(UUID().uuidString).jpg"
        
        if let imageData = profileImage?.jpegData(compressionQuality: 0.5) {
            let imageRef = propertyDBActions.storage.reference().child("images/\(imageName)")
            
            let _ = imageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    print(">>> ERROR: Image upload failed - \(error.localizedDescription)")
                    completion("NA")
                } else {
                    print(">>> INFO: Image sent successfully!")
                    
                    imageRef.downloadURL { url, error in
                        if let error = error {
                            print(">>> ERROR: Error getting download URL - \(error.localizedDescription)")
                            completion("NA")
                        } else if let url = url {
                            let imageUrl = url.absoluteString
                            print(">>> INFO: Image URL - \(imageUrl)")
                            completion(imageUrl)
                        }
                    }
                }
            }
        }
    }
    
    /* ################# */
    /* ### GEOCODING ### */
    /* ################# */
    
    func fowardGeocodingFieldsValidation() -> Bool {
        showAlert = false
        
        if (address == "") { message = "Foward Geocoding: Enter the address!" }
        else if (postalCode == "") { message = "Foward Geocoding: Enter the zip code!" }
        else if (city == "") { message = "Foward Geocoding: Enter the city!" }
        else {
            message = ""
            return true
        }
        
        showAlert = true
        
        return false
    }
    
    func reverseGeocodingFieldsValidation() -> Bool {
        showAlert = false
        
        if ((lat == "") || (lat == "0.0")) { message = "Reverse Geocoding: Enter the latitude!" }
        else if ((lon == "") || (lon == "0.0")) { message = "Reverse Geocoding: Enter the longitude!" }
        else {
            message = ""
            return true
        }
        
        showAlert = true
        
        return false
    }
    
    func fowardGeocoding() {
        if (fowardGeocodingFieldsValidation()) {
            locationHelper.doForwardGeocoding(address: "\(address) \(postalCode) \(city)", completionHandler: {(coord, error) in
                if (error == nil && coord != nil) {
                    self.lat = String((coord?.coordinate.latitude)!)
                    self.lon = String((coord?.coordinate.longitude)!)
                }
            })
        }
    }
    
    func reverseGeocoding() {
        if (reverseGeocodingFieldsValidation()) {
            locationHelper.doReverseGeocoding(location: CLLocation(latitude: Double(self.lat)!, longitude: Double(self.lon)!)
                                              ,completionHandler: {(coord, error) in
                if (error == nil && coord != nil) {
                    self.address = String((coord?.street)!)
                    self.postalCode = String((coord?.postalCode)!)
                    self.city = String((coord?.city)!)
                }
            })
        }
    }
    
    /* ################# */
    /* ##### SAVE ###### */
    /* ################# */
    
    func reset() {
        title = ""
        rent = ""
        type = PropertyTypeEnum.APARTMENT.rawValue
        owner = ""
        bedroom = ""
        bathroom = ""
        kitchen = ""
        closet = ""
        laundry = ""
        livingRoom = ""
        balcony = ""
        squareFeet = ""
        propertyDescription = ""
        address = ""
        city = ""
        postalCode = ""
        isRent = true
        additionalInformation = ""
    }
    
    func setMode() {
        if (saveMode == "update") {
            id = current.property.id
            imageURL = URL(string: current.property.image ?? "")
            title = current.property.title
            type = current.property.type
            owner = current.property.owner
            bedroom = String(current.property.bedroom)
            bathroom = String(current.property.bathroom)
            kitchen = String(current.property.kitchen)
            closet = String(current.property.closet)
            laundry = String(current.property.laundry)
            livingRoom = String(current.property.livingRoom)
            balcony = String(current.property.balcony)
            squareFeet = String(current.property.squareFeet)
            rent = String(current.property.rent)
            propertyDescription = current.property.propertyDescription
            address = current.property.address
            city = current.property.city
            postalCode = current.property.postalCode
            lat = String(current.property.lat)
            lon = String(current.property.lon)
            isRent = current.property.isRent
            additionalInformation = current.property.additionalInformation
        }
    }
    
    func setProperty(id: String) -> Property {
        var image = ""
        
        if (profileImage == nil) { image = current.property.image! }
        
        return Property(
            id: id,
            image: image,
            title: title,
            type: type,
            owner: current.user.id,
            bedroom: Int(bedroom) ?? 0,
            bathroom: Int(bathroom) ?? 0,
            kitchen: Int(kitchen) ?? 0,
            closet: Int(closet) ?? 0,
            laundry: Int(laundry) ?? 0,
            livingRoom: Int(livingRoom) ?? 0,
            balcony: Int(balcony) ?? 0,
            squareFeet: Double(squareFeet) ?? 0.0,
            rent: Double(rent) ?? 0.0,
            propertyDescription: propertyDescription,
            address: address,
            city: city,
            postalCode: postalCode,
            isRent: isRent,
            additionalInformation: additionalInformation,
            lat: Double(lat) ?? 0.0,
            lon: Double(lon) ?? 0.0
        )
    }
    
    func fieldsValidation() -> Bool {
        showAlert = false
        
        if ((saveMode == "insert") && (profileImage == nil)){ message = "Enter the rental photo!" }
        else if (title == "") { message = "Enter the rental ad title!" }
        else if (Double(rent) ?? 0.0 <= 0.0) { message = "Enter the rent value ($ CAD)!" }
        else if (type == "") { message = "Enter the property type!" }
        else if ((Int(bedroom) ?? 0 < 0) || (bedroom.isEmpty)) { message = "Enter the bedroom quantity!" }
        else if (Int(bathroom) ?? 0 < 0 || (bathroom.isEmpty)) { message = "Enter the bathroom quantity!" }
        else if (Int(kitchen) ?? 0 < 0 || (kitchen.isEmpty)) { message = "Enter the kitchen quantity!" }
        else if (Int(closet) ?? 0 < 0 || (closet.isEmpty)) { message = "Enter the closet quantity!" }
        else if (Int(laundry) ?? 0 < 0 || (laundry.isEmpty)) { message = "Enter the laundry quantity!" }
        else if (Int(livingRoom) ?? 0 < 0 || (livingRoom.isEmpty)) { message = "Enter the living room quantity!" }
        else if (Int(balcony) ?? 0 < 0 || (balcony.isEmpty)) { message = "Enter the balcony quantity!" }
        else if (Double(squareFeet) ?? 0.0 < 0.0 || (squareFeet.isEmpty)) { message = "Enter the square feet!" }
        else if (address == "") { message = "Enter the address!" }
        else if (postalCode == "") { message = "Enter the ZIP code!" }
        else if (city == "") { message = "Enter the city!" }
        else if (lon == "") { message = "Enter the longitude!" }
        else if (lat == "") { message = "Enter the latitude!" }
        else if (propertyDescription == "") { message = "Enter the property description!" }
        else if (additionalInformation == "") { message = "Enter the additional information!" }
        else {
            message = ""
            return true
        }
        
        showAlert = true
        
        return false
    }
    
    func saveButtonAction() {
        if (fieldsValidation()) {
            save()
            showAlert = true
            message = "Property saved!"
            
            rootScreen = .Main
            reset()
        }
    }
    
    func save() {
        if (saveMode == "insert") {
            saveProperty = setProperty(id: "")
            cameraSave { imageUrl in
                saveProperty.image = imageUrl
                self.propertyDBActions.create(property: saveProperty) { createdProperty, error in
                    if let error = error {
                        print(">>> INFO: Enable to create property: error -> \(error)")
                    } else if let createdProperty = createdProperty {
                        current.user.ownedProperties.append(createdProperty.id)
                        self.userDBActions.update(user: current.user)
                    }
                }
            }
        } else if (saveMode == "update") {
            saveProperty = setProperty(id: current.property.id)
            
            if (profileImage == nil) {
                self.propertyDBActions.update(property: saveProperty)
                current.property = saveProperty
            } else {
                cameraSave {
                    imageUrl in saveProperty.image = imageUrl
                    
                    self.propertyDBActions.update(property: saveProperty)
                    current.property = saveProperty
                }
            }
        }
    }
}
