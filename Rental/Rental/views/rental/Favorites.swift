import SwiftUI

struct Favorites: View {
    
    @Binding var rootScreen: RootView
    @Binding var selectedTab: Int
    @EnvironmentObject var current: Current
    @EnvironmentObject var propertyDBActions: PropertyDBActions
    @EnvironmentObject var userDBActions: UserDBActions
    
    var body: some View {
        VStack {
            PageTitle("Favorites")
            
            List {
                ForEach(propertyDBActions.propertyList.filter{current.user.favoritedProperties.contains($0.id)}) { property in
                    PropertyCard(property)
                        .onTapGesture {
                            current.setProperty(property)
                            rootScreen = .Details
                            selectedTab = 1
                        }
                }
                .onDelete(perform: removeFavorite)
            }//List
            .listSectionSpacing(5)
        }//VStack
        .onAppear(){
            if current.user.name == "Guest" {
                rootScreen = .Login
                selectedTab = 0
            }
        }
    }
    
    func removeFavorite(at offsets: IndexSet) {
        let properties = propertyDBActions.propertyList.filter{current.user.favoritedProperties.contains($0.id)}
        
       if let index = offsets.first {
            print(">>> INFO: Deleting favorite property(\(properties[index].id))")

           if let propertyToDelete = current.user.favoritedProperties.firstIndex ( where: {
               $0 == properties[index].id }) {
               current.user.favoritedProperties.remove(at: propertyToDelete)
               userDBActions.update(user: current.user)
           }
        }
    }
}
