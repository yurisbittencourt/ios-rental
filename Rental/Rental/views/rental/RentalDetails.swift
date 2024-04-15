import SwiftUI

struct RentalDetails: View {
    
    @Binding var rootScreen: RootView
    @Binding var selectedTab: Int
    @Binding var saveMode: String
    
    @EnvironmentObject var current: Current
    @EnvironmentObject var property: Property
    @EnvironmentObject var userDBActions: UserDBActions
    @EnvironmentObject var propertyDBActions: PropertyDBActions
    
    @State private var isShowingDetailView = false
    @State private var navigateToSave = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        BackToButton { rootScreen = .Main }
        
        VStack {
            PageTitle("Rental Details")
            
            Form{
                VStack{
                    if let imageUrl = current.property.image, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                Image(systemName: "photo")
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            case .failure:
                                Image(systemName: "photo")
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .padding(10)
                        .cornerRadius(8)
                    } else {
                        Image(systemName: "photo")
                            .padding(10)
                            .cornerRadius(8)
                    }
                }//Stack
                propertyRow(label: "Ad Title", value: current.property.title)
                propertyRow(label: "Rent ($ CAD)", value: String(current.property.rent))
                propertyRow(label: "Property Type", value: current.property.type)
                propertyRow(label: "Bedroom", value: String(current.property.bedroom))
                propertyRow(label: "Bathroom", value: String(current.property.bathroom))
                propertyRow(label: "Kitchen", value: String(current.property.kitchen))
                propertyRow(label: "Closet", value: String(current.property.closet))
                propertyRow(label: "Laundry", value: String(current.property.laundry))
                propertyRow(label: "Living Room", value: String(current.property.livingRoom))
                propertyRow(label: "Balcony", value: String(current.property.balcony))
                propertyRow(label: "Square Feet", value: String(current.property.squareFeet))
                propertyRow(label: "Address", value: current.property.address)
                propertyRow(label: "ZIP Code", value: current.property.postalCode)
                propertyRow(label: "City", value: current.property.city)
                propertyRow(label: "Description", value: current.property.propertyDescription)
                propertyRow(label: "Additional Information", value: current.property.additionalInformation)
            }
            
            HStack{
                if current.user.name != "Guest" {
                    if !current.user.favoritedProperties.contains(current.property.id) {
                        ButtonView(label: "Add to Favorites", color: 3, small: true, action: addToFavorites)
                    }
                }
                
                if current.user.ownedProperties.contains(current.property.id) {
                    ButtonView(label: "Update", color: 4, small: true, action: {rootScreen = .Save; selectedTab = 0; saveMode = "update"})
                }
            }.padding()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func propertyRow(label: String, value: String) -> some View {
        return Text("\(label): \(value)")
            .font(.subheadline)
            .bold()
            .padding(.horizontal, 10)
    }
    
    func addToFavorites(){
        if current.user.favoritedProperties.contains(where: {$0 == current.property.id}){
            showAlert = true
            alertTitle = "Error"
            alertMessage = "Property is already favorited"
        } else {
            current.user.favoritedProperties.append(current.property.id)
            userDBActions.update(user: current.user)
            showAlert = true
            alertTitle = "Success"
            alertMessage = "Property was added to favorites"
        }
    }
}
