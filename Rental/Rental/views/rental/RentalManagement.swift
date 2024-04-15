
import SwiftUI

struct RentalManagement: View {
    
    @Binding var rootScreen: RootView
    @Binding var selectedTab: Int
    @Binding var saveMode: String
    
    @EnvironmentObject var current: Current
    @EnvironmentObject var userDBActions: UserDBActions
    @EnvironmentObject var propertyDBActions: PropertyDBActions
    
    @State private var propertyListUpdated = false
    @State private var isShowingDetailView = false
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            PageTitle("Rental Management")
            
            List {
                ForEach(propertyDBActions.propertyList.filter{current.user.ownedProperties.contains($0.id)}) { property in
                    PropertyCard(property)
                        .onTapGesture {
                            current.setProperty(property)
                            rootScreen = .Details
                            selectedTab = 2
                        }
                }.onDelete(perform: removeProperty)
            }//List
            .listSectionSpacing(5)
            ButtonView(label: "Post Rental", color:4, icon:"arrow.up.doc", action: {rootScreen = .Save; selectedTab = 2; saveMode = "insert"}).padding(.horizontal).padding(.bottom, 10)
        }//VStack
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("Must be a Landlord to access Management"), dismissButton: .default(Text("OK")))
        }
        .onAppear(){
            if current.user.name == "Guest" {
                rootScreen = .Login
                selectedTab = 0
            }
            if current.user.type == "TENANT" {
                showAlert = true
                rootScreen = .Main
                selectedTab = 0
            }
            propertyDBActions.getAll()
        }
    }
    
    func removeProperty(at offsets: IndexSet) {
        let properties = propertyDBActions.propertyList.filter{
            current.user.ownedProperties.contains($0.id)
        }
        
        if let index = offsets.first {
            print(">>> INFO: Deleting property(\(properties[index].id))")
            
            //property, image
            propertyDBActions.delete(property: properties[index])
            
            //user
            if let propertyToDelete = current.user.ownedProperties.firstIndex ( where: {
                $0 == properties[index].id }) {
                current.user.ownedProperties.remove(at: propertyToDelete)
                current.user.favoritedProperties.remove(at: propertyToDelete)
                userDBActions.update(user: current.user)
            }
        }
    }
}
