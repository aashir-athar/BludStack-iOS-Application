

import UIKit

class ObjectRequest: FireCodable {
    
    var id = UUID().uuidString
    var userId: String?
    var date: String?
    var time: String?
    var latitude: Double?
    var longitude: Double?
    var bloodGroup: String?
    var donorId: String? = ""
    var isUrgent: Bool? = false
    var isCompleted: Bool? = false
    var isOnWay: Bool? = false
    var timestamp: Int64?
    
    var city: String?
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encodeIfPresent(date, forKey: .date)
        try container.encodeIfPresent(city, forKey: .city)
        try container.encodeIfPresent(time, forKey: .time)
        try container.encodeIfPresent(latitude, forKey: .latitude)
        try container.encodeIfPresent(longitude, forKey: .longitude)
        try container.encodeIfPresent(bloodGroup, forKey: .bloodGroup)
        try container.encodeIfPresent(donorId, forKey: .donorId)
        try container.encodeIfPresent(isUrgent, forKey: .isUrgent)
        try container.encodeIfPresent(isCompleted, forKey: .isCompleted)
        try container.encodeIfPresent(isOnWay, forKey: .isOnWay)
        try container.encodeIfPresent(timestamp, forKey: .timestamp)
    }
    
    init() {}
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        userId = try container.decode(String.self, forKey: .userId)
        date = try container.decodeIfPresent(String.self, forKey: .date)
        time = try container.decodeIfPresent(String.self, forKey: .time)
        latitude = try container.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try container.decodeIfPresent(Double.self, forKey: .longitude)
        bloodGroup = try container.decodeIfPresent(String.self, forKey: .bloodGroup)
        donorId = try container.decodeIfPresent(String.self, forKey: .donorId)
        isUrgent = try container.decodeIfPresent(Bool.self, forKey: .isUrgent)
        isCompleted = try container.decodeIfPresent(Bool.self, forKey: .isCompleted)
        isOnWay = try container.decodeIfPresent(Bool.self, forKey: .isOnWay)
        timestamp = try container.decodeIfPresent(Int64.self, forKey: .timestamp)
        city = try container.decodeIfPresent(String.self, forKey: .city)
    }
}

extension ObjectRequest {
    private enum CodingKeys: String, CodingKey {
        case id
        case userId
        case date
        case time
        case bloodGroup
        case longitude
        case latitude
        case donorId
        case isUrgent
        case isCompleted
        case isOnWay
        case timestamp
        case city
    }
}
