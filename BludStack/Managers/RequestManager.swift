

import Foundation
import FirebaseAuth

class RequestManager {
    let service = FirestoreService()
    
    func requestData(for id: String, _ completion: @escaping CompletionObject<ObjectRequest?>) {
        let query = FirestoreService.DataQuery(key: "id", value: id, mode: .equal)
        service.objectWithListener(ObjectRequest.self, parameter: query, reference: .init(location: .requests)) { requests in
            completion(requests.first)
        }
    }
    
    func currentRequests(_ completion: @escaping CompletionObject<[ObjectRequest]>) {
      let query = FirestoreService.DataQuery(key: "userId", value: UserDefaults.userId, mode: .equal)
      service.objectWithListener(ObjectRequest.self, parameter: query, reference: .init(location: .requests)) { results in
        completion(results)
      }
    }
    
    func allRequests(_ completion: @escaping CompletionObject<[ObjectRequest]>) {
        let query = FirestoreService.DataQuery(key: "bloodGroup", value: UserDefaults.bloodGroup, mode: .equal)
      service.objectWithListener(ObjectRequest.self, parameter: query, reference: .init(location: .requests)) { results in
        completion(results)
      }
    }
    
    func currentDonations(_ completion: @escaping CompletionObject<[ObjectRequest]>) {
      let query = FirestoreService.DataQuery(key: "donorId", value: UserDefaults.userId, mode: .equal)
      service.objectWithListener(ObjectRequest.self, parameter: query, reference: .init(location: .requests)) { results in
        completion(results)
      }
    }
    
    func create(_ request: ObjectRequest, _ completion: CompletionObject<FirestoreResponse>? = nil) {
      FirestoreService().update(request, reference: .init(location: .requests)) { completion?($0) }
    }
    
    func delete(_ request: ObjectRequest, _ completion: CompletionObject<FirestoreResponse>? = nil) {
        let query = FirestoreService.DataQuery(key: "id", value: request.id, mode: .equal)
        FirestoreService().delete(ObjectRequest.self, reference: .init(location: .requests), parameter: query) { results in
        completion?(results)
      }
//        update(request, reference: .init(location: .requests)) { completion?($0) }
    }
    
}
