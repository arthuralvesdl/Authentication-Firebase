import SwiftUI

struct AppView: View {
    
    @EnvironmentObject var appController: AppController
    
    var body: some View {
        if appController.isLoggedIn {
            HomeView()
        } else {
            LoginView()
        }
    }
}
