
import UIKit

class ObjectUser: FireStorageCodable {
    
    var id = UUID().uuidString
    var name: String?
    var gender: String?
    var location: String?
    var dateOfBirth: String?
    var bloodGroup: String?
    var phone: String?
    var profilePicLink: String?
    var profilePic: UIImage?
    var isDonor: Bool?
    var lastDonation: Int64?
    
    var latitude: Double?
    var longitude: Double?
    
    var token: String?
    var city: String?
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(city, forKey: .city)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(gender, forKey: .gender)
        try container.encodeIfPresent(location, forKey: .location)
        try container.encodeIfPresent(dateOfBirth, forKey: .dateOfBirth)
        try container.encodeIfPresent(bloodGroup, forKey: .bloodGroup)
        try container.encodeIfPresent(phone, forKey: .phone)
        try container.encodeIfPresent(profilePicLink, forKey: .profilePicLink)
        try container.encodeIfPresent(isDonor, forKey: .isDonor)
        try container.encodeIfPresent(lastDonation, forKey: .lastDonation)
        try container.encodeIfPresent(latitude, forKey: .latitude)
        try container.encodeIfPresent(longitude, forKey: .longitude)
        try container.encodeIfPresent(token, forKey: .token)
    }
    
    init() {}
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        city = try container.decodeIfPresent(String.self, forKey: .city)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        gender = try container.decodeIfPresent(String.self, forKey: .gender)
        location = try container.decodeIfPresent(String.self, forKey: .location)
        dateOfBirth = try container.decodeIfPresent(String.self, forKey: .dateOfBirth)
        bloodGroup = try container.decodeIfPresent(String.self, forKey: .bloodGroup)
        phone = try container.decodeIfPresent(String.self, forKey: .phone)
        profilePicLink = try container.decodeIfPresent(String.self, forKey: .profilePicLink)
        isDonor = try container.decodeIfPresent(Bool.self, forKey: .isDonor)
        lastDonation = try container.decodeIfPresent(Int64.self, forKey: .lastDonation)
        latitude = try container.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try container.decodeIfPresent(Double.self, forKey: .longitude)
        token = try container.decodeIfPresent(String.self, forKey: .token)
    }
}

extension ObjectUser {
    private enum CodingKeys: String, CodingKey {
        case id
        case phone
        case name
        case profilePicLink
        case bloodGroup
        case gender
        case location
        case dateOfBirth
        case isDonor
        case lastDonation
        
        case latitude
        case longitude
        case token
        case city
        
    }
}
