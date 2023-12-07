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
            TabView(selection: $selectedTab) {
                Group {
                    HomeBuilder().build(with: context.container)
                        .tag(0)

                    TopCryptosBuilder().build(with: context.container)
                        .tag(1)

                    MyPortfolioBuilder().build(with: context.container)
                        .tag(2)

                    TopCryptosBuilder().build(with: context.container)
                        .tag(3)
                }.toolbarBackground(.hidden, for: .tabBar)
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
                .aspectRatio(contentMode: .fit)
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

