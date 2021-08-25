//  MIT License

//  Copyright (c) 2019 Haik Aslanyan

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import FirebaseAuth

class UserManager {
    
    private let service = FirestoreService()
    
    func currentUserID() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    func currentUserData(_ completion: @escaping CompletionObject<ObjectUser?>) {
        guard let id = Auth.auth().currentUser?.uid else { completion(nil); return }
        let query = FirestoreService.DataQuery(key: "id", value: id, mode: .equal)
        service.objectWithListener(ObjectUser.self, parameter: query, reference: .init(location: .users), completion: { users in
            completion(users.first)
        })
    }
    
    func verifyPhone(phone: String, completion: @escaping CompletionObject<String?>) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { (verificationId, error) in
            if error == nil {
                print("VerificationID: ", verificationId!)
                completion(verificationId)
            } else {
                print("Error: ", error!)
                completion(nil)
            }
        }
    }
    
    
    func login(verificationId: String, verificationCode: String, completion: @escaping CompletionObject<FirestoreResponse>) {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationId,
            verificationCode: verificationCode)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error == nil {
                completion(.success)
            } else {
                print("Error: ", error!)
                completion(.failure)
            }
        }
    }
    
    func update(user: ObjectUser, completion: @escaping CompletionObject<FirestoreResponse>) {
        FirestorageService().update(user, reference: .users) { response in
            switch response {
            case .failure: completion(.failure)
            case .success:
                FirestoreService().update(user, reference: .init(location: .users), completion: { result in
                    completion(result)
                })
            }
        }
    }
    
    func userData(for id: String, _ completion: @escaping CompletionObject<ObjectUser?>) {
        let query = FirestoreService.DataQuery(key: "id", value: id, mode: .equal)
        FirestoreService().objects(ObjectUser.self, reference: .init(location: .users), parameter: query) { users in
            completion(users.first)
        }
    }
    
    func user(for id: String, _ completion: @escaping CompletionObject<ObjectUser?>) {
        let query = FirestoreService.DataQuery(key: "id", value: id, mode: .equal)
        service.objectWithListener(ObjectUser.self, parameter: query, reference: .init(location: .users)) { users in
            completion(users.first)
        }
    }
    
    @discardableResult func logout() -> Bool {
        do {
            UserDefaults.phone = nil
            UserDefaults.userId = ""
            try Auth.auth().signOut()
            return true
        } catch {
            return false
        }
    }
}
