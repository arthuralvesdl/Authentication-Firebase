import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appController: AppController
    var body: some View {
        NavigationView {
            VStack {
                Text("SettingsScreen")
                Button("Sair") {
                    appController.logout() {result, message in}
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        .tabItem {
            Label("Settings", systemImage: "gearshape.fill")
        }
    }
}
