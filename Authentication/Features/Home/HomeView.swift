import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var appController: AppController
    var body: some View {
        TabView {
            ContentView()
                .environmentObject(appController)
            ProfileView()
                .environmentObject(appController)
        }
    }
}
