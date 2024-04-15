import SwiftUI
import MapKit

struct Home: View {
    
    @Binding var rootScreen: RootView
    @Binding var selectedTab: Int
    
    @EnvironmentObject var current: Current
    @EnvironmentObject var userAuthActions: UserAuthActions
    @EnvironmentObject var propertyDBActions: PropertyDBActions
    @EnvironmentObject var userDBActions: UserDBActions
    @EnvironmentObject var locationHelper : LocationHelper
    
    var showMap: Bool
    
    @State private var showAlert: Bool = false
    @State private var radius: String = ""
    @State private var searchInput: String = ""
    @State private var searchedCoordinates: CLLocation?
    
    var body: some View {
        VStack{
            if showMap == true {
                mapComponent()
            } else {
                listComponent()
            }
        }//VStack
        .onAppear(){
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { propertyDBActions.getAll() }
            self.locationHelper.checkPermission()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("Unable to find coordinates for the given address"), dismissButton: .default(Text("OK")))
        }
    }
    
    func listComponent() -> some View {
        return VStack{
            PageTitle("Properties for Rent")
            List(propertyDBActions.propertyList.filter{$0.isRent}){ property in
                PropertyCard(property)
                    .onTapGesture {
                        current.setProperty(property)
                        rootScreen = .Details
                        selectedTab = 0
                    }
            }//List
            .listSectionSpacing(5)
        }
    }
    
    func mapComponent() -> some View {
        return VStack {
            if (self.locationHelper.currentLocation != nil) {
                HStack{
                    TextField("All Rentals", text: $searchInput).padding(.leading)
                    TextField("Radius(m)", text: $radius)
                    ButtonView(label: "Search", small: true, action: getCoordinatesFrom)
                }.padding(.horizontal)
                MapRepresentable(mapViewModel: MapViewModel(location: searchedCoordinates ?? locationHelper.currentLocation, properties: propertyDBActions.propertyList, radius: CLLocationDistance(Double(radius) ?? 1000)))
            } else {
                Text("Obtaining user location...")
            }
        }
    }
    
    func getCoordinatesFrom() {
        locationHelper.doForwardGeocoding(address: searchInput, completionHandler: {(coord, error) in
            if(error == nil && coord != nil) {
                self.searchedCoordinates = coord
            } else {
                showAlert = true
            }
        })
    }
}
