import SwiftUI

enum TabSelection {
    case initial
    case calendar
}

final class AppEnviroment: ObservableObject {
    @Published var selectionTab: TabSelection = .initial
}

struct TabNavigationBar: View {
    @StateObject var appEnviroment = AppEnviroment()
    @State private var selectionTab: TabSelection = .initial
    
    var body: some View {
        TabView(selection: $selectionTab) {
            NavigationView {
                InitialView()
            }
            .tabItem {
                Label("Initial", systemImage: AppIcons.familyunit.rawValue)
            }
            .tag(TabSelection.initial)

            NavigationView {
                SharedEventsView()
            }
            .tabItem {
                Label("Calendario", systemImage: AppIcons.calendar.rawValue)
            }
            .tag(TabSelection.calendar)
        }
        .navigationBarHidden(true)
        .onChange(of: appEnviroment.selectionTab) { newValue in
            selectionTab = newValue
        }
        .onChange(of: selectionTab) { newValue in
            appEnviroment.selectionTab = newValue
        }
        .accentColor(AppColors.pink)
        .environmentObject(appEnviroment)
        .customTabBar()
    }
}

#Preview {
    TabNavigationBar()
}
