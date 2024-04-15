
import SwiftUI

func PageTitle(_ title: String) -> some View {
    return HStack {
        Spacer()
        Text(title)
            .font(.title3)
            .bold()
        Spacer()
    }
}

func BackToButton(action: @escaping () -> Void) -> some View{
    return Button(action: {
        action()
    }) {
        HStack{
            Image(systemName: "chevron.left")
            Text("Back")
        }
    }
    .padding(.horizontal, 10)
    .frame(maxWidth: .infinity, alignment: .leading)
}

func PropertyCard(_ property: Property) -> some View {
    return Section {
        HStack{
            VStack{
                if let imageUrl = property.image, let url = URL(string: imageUrl) {
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
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
                } else {
                    Image(systemName: "photo")
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                }
            }//Stack
            .frame(width: 50)
            .padding(.trailing, 10)
            VStack(alignment: .leading){
                HStack(){
                    Text(property.title).font(.title3).bold().lineLimit(1)
                    Spacer()
                    Text("$\(String(format: "%.2f", property.rent))").bold().lineLimit(1)
                }
                Text(property.propertyDescription).font(.caption).lineLimit(2)
            }
        }//HStack
    }
    .contentShape(Rectangle())
}
