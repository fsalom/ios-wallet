import SwiftUI

enum TabbedItems: Int, CaseIterable{
    case home = 0
    case favorite
    case chat
    case profile

    var title: String{
        switch self {
        case .home:
            return "Home"
        case .favorite:
            return "Favorite"
        case .chat:
            return "Chat"
        case .profile:
            return "Profile"
        }
    }

    var iconName: String{
        switch self {
        case .home:
            return "house"
        case .favorite:
            return "star"
        case .chat:
            return "gearshape"
        case .profile:
            return "person"
        }
    }
}

struct MainTabbedView: View {

    @State var selectedTab = 0

    var body: some View {

        ZStack(alignment: .bottom){
            TabView(selection: $selectedTab) {
                Group {
                    HomeBuilder().build()
                        .tag(0)

                    TopCryptosBuilder().build()
                        .tag(1)

                    HomeBuilder().build()
                        .tag(2)

                    TopCryptosBuilder().build()
                        .tag(3)
                }.toolbarBackground(.hidden, for: .tabBar)
            }

            ZStack{
                HStack{
                    ForEach((TabbedItems.allCases), id: \.self){ item in
                        Button{
                            withAnimation {
                                selectedTab = item.rawValue
                            }
                        } label: {
                            CustomTabItem(imageName: item.iconName, title: item.title, isActive: (selectedTab == item.rawValue))
                        }
                    }
                }
                .padding(6)
            }
            .frame(height: 70)
            .background(.white.opacity(1))
            .cornerRadius(35)
            .padding(.horizontal, 26)
            .shadow(radius: 1)
        }
    }
}

extension MainTabbedView{
    func CustomTabItem(imageName: String, title: String, isActive: Bool) -> some View{
        HStack(spacing: 10){
            Spacer()
            Image(systemName: imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(isActive ? .black : .gray)
                .frame(width: 20, height: 20)

            Spacer()
        }
        .frame(width: isActive ? 60 : 60, height: 60)
        .background(isActive ? .active.opacity(1) : .clear)
        .cornerRadius(30)
    }
}

#Preview {
    MainTabbedView()
}
