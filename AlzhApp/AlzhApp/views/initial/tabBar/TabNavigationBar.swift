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
            InitialView()
                .tabItem {
                    Label("Initial", systemImage: AppIcons.familyunit.rawValue)
                }
                .tag(TabSelection.initial)
            //            SharedCalendar()
            NavigationView {
                SharedCalendar()
            }
            .tabItem {
                Label("Calendario", systemImage: AppIcons.calendar.rawValue)
            }
            .tag(TabSelection.calendar)
        }
        .navigationBarHidden(true)
        //        .navBarAddFamily(title: LocalizedString.unidadesFamiliares)
        .onChange(of: appEnviroment.selectionTab) { newValue, oldValue in
            selectionTab = newValue
        }
        .onChange(of: selectionTab) { newValue, oldValue in
            appEnviroment.selectionTab = newValue
        }
        .accentColor(AppColors.pink)
        .environmentObject(appEnviroment)
        .customTabBar()
    }
}

//#Preview {
//    SharedEventsView(patientID: <#Int?#>)
//}


struct TabSelectionView: View {
    var body: some View {
        VStack {
            Text("TabSelectionView")
        }
    }
}

//#Preview {
//    TabSelectionView()
//}
