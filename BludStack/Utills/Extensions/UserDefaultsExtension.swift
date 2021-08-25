

import Foundation

extension UserDefaults {
    
    private struct Keys {
        static let phone = "phone"
        static let bloodGroup = "bloodGroup"
        static let userId = "userId"
        static let isDonor = "isDonor"
        static let fcmToken = "fcmToken"
        static let userName = "userName"
        static let city = "city"
    }
    
    static var city: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.city) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.city)
        }
    }
    
    static var userName: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.userName) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.userName)
        }
    }
    
    static var userId: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.userId) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.userId)
        }
    }
    
    static var phone: String? {
        get {
            return UserDefaults.standard.string(forKey: Keys.phone)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.phone)
        }
    }
    
    static var isDonor: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.isDonor)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.isDonor)
        }
    }
    
    static var bloodGroup: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.bloodGroup) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.bloodGroup)
        }
    }
    static var fcmToken: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.fcmToken) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.fcmToken)
        }
    }
    
}
