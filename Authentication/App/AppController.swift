import Foundation
import FirebaseAuth
import UserNotifications
import SwiftUI

class AppController: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    @Published public var isLoggedIn: Bool = false
    @Published public var user: User?
    @Published public var notificationStatus: UNAuthorizationStatus = .notDetermined
    @Published public var notificationsIsEnabled: Bool = false
    
    let notificationCenter = UNUserNotificationCenter.current() //Notificação em primeiro plano
    
   override init(){
       super.init()
       notificationCenter.delegate = self
    }
    
    func initApp(){
        checkLogin()
    }
    
    func checkLogin(){
        if let currentUser = Auth.auth().currentUser {
            isLoggedIn = true
            user = User(id: currentUser.uid, name: currentUser.displayName ?? "", email: currentUser.email ?? "")
        }
    }
    
    func checkNotificationPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.notificationStatus = settings.authorizationStatus
                
                switch settings.authorizationStatus {
                case .notDetermined:
                    self.notificationsIsEnabled = false
                case .denied:
                    self.notificationsIsEnabled = false
                case .authorized, .provisional, .ephemeral:
                    self.notificationsIsEnabled = true
                @unknown default:
                    break
                }
            }
        }
    }
    
    //DELEGATE FUNCTION
    /*TODO: https://www.youtube.com/watch?v=m45mnkCUUvI */
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.sound, .banner]
    }
 
    func scheduleNotification(title: String, subtitle: String) {
         let content = UNMutableNotificationContent()
         content.title = title
         content.subtitle = subtitle
         content.sound = UNNotificationSound.default
         
         let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

         let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

         UNUserNotificationCenter.current().add(request)
    }

    func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func logout(completion: @escaping(Bool, String) -> Void){
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
            user = nil
            completion(true, "Deslogado")
        } catch {
            completion(false, "Erro ao deslogar")
        }
    }
}

struct User: Codable {
    let id: String
    var name: String
    var email: String
    
}
