//
//  UserDetailsViewModel.swift
//  Matchmaker App
//
//  Created by Arav Khandelwal on 25/07/24.
//

import Foundation

class UserDetailsViewModel: ObservableObject {
    
    @Published var viewState: ViewState = .success
    
    var userDetails: [CardDetailsModel] = []
    
    /// Function to call userDetailsAPI and prepare the required list on the basis of results. Handles the logic syncing up data from database.
    func fetchUserDetails() {
        self.viewState = .fullScreenLoading(text: "Preparing the appropriate matches for you.")
        UserDetailsNetworkAPIs.sendGetUserListRequest { [weak self] (userResponse, apiError) in
            guard let strongSelf = self else {
                return
            }
            guard let err = apiError else {
                userResponse?.userList.forEach { userInfo in
                    let cardDetail = CardDetailsModel(
                        imageURL: userInfo.picture.large,
                        fullName: userInfo.name.getFullName(),
                        fullAddress: userInfo.location.getFullAddress(),
                        age: userInfo.dob.age,
                        idValue: "\(userInfo.id.name)-\(userInfo.id.value ?? "")",
                        status: .new
                    )
                    PersistenceManager.shared.saveCardDetail(cardDetail: cardDetail)
                }
                strongSelf.userDetails = PersistenceManager.shared.fetchCardDetails()
                strongSelf.viewState = .success
                return
            }
            if case .networkReachabilityError = err {
                let userList = PersistenceManager.shared.fetchCardDetails()
                if !userList.isEmpty {
                    strongSelf.userDetails = userList
                    strongSelf.viewState = .success
                }
            }
            else {
                strongSelf.viewState = .failure(
                    apiError: err,
                    buttonTitle: "Try Again",
                    buttonFunctionality: {
                        strongSelf.fetchUserDetails()
                    }
                )
            }
        }
    }
    
    func acceptUserProfile(profileId: String) {
        if var cardDetail = self.userDetails.first(where: {
            $0.idValue == profileId
        }) {
            cardDetail.status = .accepted
            PersistenceManager.shared.updateCardDetail(cardDetail: cardDetail)
        }
    }
    
    func rejectUserProfile(profileId: String) {
        if var cardDetail = self.userDetails.first(where: {
            $0.idValue == profileId
        }) {
            cardDetail.status = .rejected
            PersistenceManager.shared.updateCardDetail(cardDetail: cardDetail)
        }
    }
}
