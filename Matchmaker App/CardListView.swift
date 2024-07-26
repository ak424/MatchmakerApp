//
//  ContentView.swift
//  Matchmaker App
//
//  Created by Arav Khandelwal on 25/07/24.
//

import SwiftUI

struct CardListView: View {
    @ObservedObject var viewModel = UserDetailsViewModel()
    
    var body: some View {
        HBGenericBaseView(
            viewState: $viewModel.viewState,
            childView:
                ScrollView {
                    VStack {
                        ForEach(viewModel.userDetails, id: \.idValue) { detail in
                            UserCardView(
                                cardDetail: detail,
                                onAccept: {
                                    viewModel.acceptUserProfile(profileId: detail.idValue)
                                },
                                onReject: {
                                    viewModel.rejectUserProfile(profileId: detail.idValue)
                                }
                            ).padding(.bottom, 10)
                        }
                    }
                    
                }
        )
        .onAppear {
            viewModel.fetchUserDetails()
        }
    }
}

#Preview {
    CardListView()
}

