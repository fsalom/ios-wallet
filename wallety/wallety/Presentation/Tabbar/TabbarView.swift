import SwiftUI

enum TabbedItems: Int, CaseIterable{
    case home = 0
    case favorite
    case portfolio
    case profile

    var title: String{
        switch self {
        case .home:
            return "Home"
        case .favorite:
            return "Favorite"
        case .portfolio:
            return "Portfolio"
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
        case .portfolio:
            return "folder"
        case .profile:
            return "person"
        }
    }
}

struct MainTabbedView: View {
    @Environment(\.modelContext) private var context
    @State var selectedTab = 0

    var body: some View {

        ZStack(alignment: .bottom){
            switch selectedTab {
            case 0:
                Container.shared.getHomeView(with: context.container)
                    .opacity(selectedTab == 0 ? 1 : 0)
            case 1:
                NavigationStack {
                    Container.shared.getTopCryptosView(with: context.container)
                        .opacity(selectedTab == 1 ? 1 : 0)
                }
            case 2:
                NavigationStack {
                    MyPortfolioBuilder().build(with: context.container)
                        .opacity(selectedTab == 2 ? 1 : 0)
                }
            case 3:
                NavigationStack {
                    Container.shared.getTopCryptosView(with: context.container)
                        .opacity(selectedTab == 3 ? 1 : 0)
                }
            default:
                Container.shared.getHomeView(with: context.container)
                    .opacity(selectedTab == 0 ? 1 : 0)
            }

            ZStack{
                HStack{
                    ForEach((TabbedItems.allCases), id: \.self){ item in
                        Button{
                            selectedTab = item.rawValue
                        } label: {
                            CustomTabItem(imageName: item.iconName,
                                          title: item.title,
                                          isActive: (selectedTab == item.rawValue))
                        }
                    }
                }
                .padding(6)
            }
            .frame(height: 60)
            .background(.white.opacity(1))
            .cornerRadius(30)
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
                .aspectRatio(contentMode: .fit)
                .foregroundColor(isActive ? .black : .gray)
                .frame(width: 20, height: 20)

            Spacer()
        }
        .frame(width: isActive ? 100 : 50, height: 50)
        .background(isActive ? .active.opacity(1) : .clear)
        .cornerRadius(25)
    }
}

#Preview {
    MainTabbedView()
}

