import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appController: AppController
    @StateObject private var loginModel: LoginModel = LoginModel()
    @State private var showingFields = false
    
    var body: some View {
        VStack {
            
            Button("Login com E-mail") {
                showingFields.toggle()
            }
            .disabled(loginModel.isLoading)
            .sheet(isPresented: $showingFields){
                VStack{
                    TextField("Email", text: $loginModel.email)
                        .textFieldStyle(.roundedBorder)
                    SecureField("Senha", text: $loginModel.password)
                        .textFieldStyle(.roundedBorder)
                    Button("Entrar") {
                        loginModel.loginWithEmail { result in
                            if result {
                                appController.isLoggedIn = result
                                appController.user = loginModel.userLogged()
                            }
                        }
                    }
                    .disabled(loginModel.isLoading)
                    .buttonStyle(.bordered)
                    if loginModel.isLoading {
                        ProgressView("", value: loginModel.loadingAmount, total: 120)
                            .onReceive(loginModel.timer) { _ in
                                if !loginModel.isLoading {
                                    loginModel.loadingAmount = 120
                                }
                                if loginModel.loadingAmount < 120 {
                                    loginModel.loadingAmount += 1
                                }
                            }
                    }
                }
                .padding()
                
            }
            .buttonStyle(.bordered)
            
            Button("Login com Google") {
                loginModel.loginWithGoogle { result in
                    if result {
                        appController.isLoggedIn = result
                        appController.user = loginModel.userLogged()
                    }
                }
            }
            .disabled(loginModel.isLoading)
            .buttonStyle(.bordered)
            //MARK: - LOADING
            if loginModel.isLoading {
                ProgressView("", value: loginModel.loadingAmount, total: 120)
                    .onReceive(loginModel.timer) { _ in
                        if !loginModel.isLoading {
                            loginModel.loadingAmount = 120
                        }
                        if loginModel.loadingAmount < 120 {
                            loginModel.loadingAmount += 1
                        }
                        
                    }
            }
            
        }
        .padding()
        .alert(Text(loginModel.alertMessage), isPresented: $loginModel.showingAlert) { }
    }
}
