
import SwiftUI

struct ButtonView: View {
    
    let icon: String?
    let label: String
    let action: () -> Void
    let color: Color
    let small: Bool
    
    init(
        label: String,
        color: Int? = nil,
        icon: String? = nil,
        small: Bool = false,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.color = switch(color){
        case 1: Color.blue
        case 2: Color.red
        case 3: Color.green
        case 4: Color.orange
        default: Color.blue
        }
        self.icon = icon
        self.action = action
        self.small = small
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 8) {
                if let icon {
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                }
                Text(label)
            }
            .font(small ? .subheadline : .title2).bold()
            .padding(small ? 5 : 10)
            .foregroundColor(Color.white)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.8))
            }
        }
    }
}
