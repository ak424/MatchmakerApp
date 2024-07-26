//
//  UserModules.swift
//  Matchmaker App
//
//  Created by Arav Khandelwal on 26/07/24.
//

import Foundation
import CoreData

struct UsersResponse: Codable {
    let userList: [UserInfo]
    let info: Info
    
    enum CodingKeys: String, CodingKey {
        case userList = "results"
        case info
    }
}

struct UserInfo: Codable {
    let id: ID
    let gender: String
    let name: Name
    let location: Location
    let email: String
    let dob: DateInfo
    let registered: DateInfo
    let phone: String
    let cell: String
    let picture: Picture
    let nat: String
    var status: UserStatus = .new
    
    enum CodingKeys: String, CodingKey {
        case gender, name, location, email, dob, registered, phone, cell, picture, nat, id
    }
}

struct Name: Codable {
    let title: String
    let first: String
    let last: String
    
    func getFullName() -> String {
        return "\(self.title) \(self.first) \(self.last)"
    }
}

struct Location: Codable {
    let street: Street
    let city: String
    let state: String
    let country: String
    let timezone: Timezone

    func getFullAddress() -> String {
        return "\(self.street.number), \(self.street.name)\n\(self.city), \(self.state)"
    }
}

struct Street: Codable {
    let number: Int
    let name: String
}

struct Timezone: Codable {
    let offset: String
    let description: String
}

struct DateInfo: Codable {
    let date: String
    let age: Int
}

struct ID: Codable, Hashable {
    let name: String
    let value: String?

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(value)
    }

    static func == (lhs: ID, rhs: ID) -> Bool {
        return lhs.name == rhs.name && lhs.value == rhs.value
    }
}
struct Picture: Codable {
    let large: String
    let medium: String
    let thumbnail: String
}

struct Info: Codable {
    let seed: String
    let results: Int
    let page: Int
    let version: String
}

enum UserStatus: String, Codable {
    case accepted, rejected, new
}

struct CardDetailsModel {
    let imageURL: String
    let fullName: String
    let fullAddress: String
    let age: Int
    let idValue: String
    var status: UserStatus = .new
}

extension CardDetails {
    
    func toCardDetailsModel() -> CardDetailsModel {
        return CardDetailsModel(
            imageURL: imageURL,
            fullName: fullName,
            fullAddress: fullAddress,
            age: Int(age),
            idValue: idValue,
            status: UserStatus(rawValue: status) ?? .new
        )
    }

    static func fromCardDetailsModel(_ cardDetails: CardDetailsModel, context: NSManagedObjectContext) -> CardDetails {
        let cardDetailsEntity = CardDetails(context: context)
        cardDetailsEntity.imageURL = cardDetails.imageURL
        cardDetailsEntity.fullName = cardDetails.fullName
        cardDetailsEntity.fullAddress = cardDetails.fullAddress
        cardDetailsEntity.age = Int32(cardDetails.age)
        cardDetailsEntity.idValue = cardDetails.idValue
        cardDetailsEntity.status = cardDetails.status.rawValue
        return cardDetailsEntity
    }
}

enum ViewState: Equatable {
    case start
    case fullScreenLoading(text: String)
    case buttonLoading
    case success
    case exit
    case failure(apiError: CustomError, buttonTitle: String, buttonFunctionality: () -> Void)
    
    static func ==(lhs: ViewState, rhs: ViewState) -> Bool {
        switch (lhs, rhs) {
            case (.start, .start),
                (.buttonLoading, .buttonLoading),
                (.success, .success),
                (.exit, .exit):
                return true
            case (.failure(let lhsError, let lhsButtonTitle, _), .failure(let rhsError, let rhsButtonTitle, _)):
                return (lhsButtonTitle == rhsButtonTitle && ("\(lhsError)") == ("\(rhsError)"))
            case (.fullScreenLoading(let lhsText), .fullScreenLoading(let rhsText)):
                return lhsText == rhsText
            default:
                return false
        }
    }
}

enum CustomError: Error {
    case networkReachabilityError, timedOutError, statusCode(Int,Data), customizedError(String), defaultError(Error)
}
