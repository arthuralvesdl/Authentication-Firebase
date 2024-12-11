import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class LoginModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var alertMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var loadingAmount = 0.0
    @Published var showingAlert: Bool = false
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    func userLogged() -> User? {
        if let currentUser = Auth.auth().currentUser {
            return User(id: currentUser.uid, name: currentUser.displayName ?? "", email: currentUser.email ?? "")
        } else {
            return nil
        }
    }
    //MARK: - E-mail
    func loginWithEmail(completion: @escaping(Bool) -> Void) {
        isLoading = true
        loadingAmount = 0.0
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else {return}
            if let e = error {
                self.showingAlert = true
                self.alertMessage = e.localizedDescription
                completion(false)
            } else {
                self.showingAlert = true
                self.alertMessage = "Login realizado com sucesso"
                completion(true)
            }
            self.isLoading = false
        }
        
    }
    //MARK: - GOOGLE
    func loginWithGoogle(completion: @escaping (Bool) -> Void) {
        // Obtém o clientID do Firebase
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            self.showingAlert = true
            self.alertMessage = "Client ID não encontrado."
            self.isLoading = false
            completion(false)
            return
        }
        
        // Cria a configuração do Google Sign-In
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Inicia o fluxo de login do Google
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
                GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
                    guard let self = self else {return}
                    self.isLoading = true
                    self.loadingAmount = 0.0
                    if let error = error {
                        // Erro no login com o Google
                        self.showingAlert = true
                        self.alertMessage = error.localizedDescription
                        self.isLoading = false
                        completion(false)
                        return
                    }
                    
                    guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                        self.showingAlert = true
                        self.alertMessage = "Erro ao obter o ID Token do Google."
                        self.isLoading = false
                        completion(false)
                        return
                    }
                    
                    // Cria as credenciais do Firebase com o ID Token e Access Token do Google
                    let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                                   accessToken: user.accessToken.tokenString)
                    
                    // Autentica com o Firebase usando as credenciais do Google
                    Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                        guard let self = self else {return}
                        if let error = error {
                            // Erro na autenticação com o Firebase
                            self.showingAlert = true
                            self.alertMessage = error.localizedDescription
                            self.isLoading = false
                            completion(false)
                            return
                        }
                        
                        // Login com Google bem-sucedido
                        self.showingAlert = true
                        self.alertMessage = "Login com Google realizado com sucesso!"
                        self.isLoading = false
                        completion(true)
                    }
                }
            }
        }
    }
}
