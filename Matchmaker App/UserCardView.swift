//
//  UserCardView.swift
//  Matchmaker App
//
//  Created by Arav Khandelwal on 26/07/24.
//

import SwiftUI

struct UserCardView: View {
    let cardDetail: CardDetailsModel
    let onAccept: () -> Void
    let onReject: () -> Void
    
    @State private var rotationAngle: Double = 0
    @State private var axis: (x: CGFloat, y: CGFloat, z: CGFloat) = (x: 0, y: 0, z: 0)
    @State private var isRotating = false
    @State private var showingBack = false
    @State private var backContent: String = ""
    @State private var currStatus: UserStatus = .new
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                if showingBack {
                    VStack(alignment: .center, spacing: 20) {
                        if backContent == "Accepted" {
                            Image("accepting_profile")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } else if backContent == "Rejected" {
                            Image("rejecting_profile")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .frame(width: 320, height: 500)
                    .background(backContent == "Accepted" ? Color.teal : Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .rotation3DEffect(
                        .degrees(180),
                        axis: (x: 0, y: 1, z: 0)
                    )
                } else {
                    VStack(alignment: .leading) {
                        CustomImageView(imageEntity: CustomImageEntity(imageURL: cardDetail.imageURL, imageName: nil))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(.leading, 16)
                            .padding(.top, 10)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(cardDetail.fullName)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("\(cardDetail.age) yrs")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text(cardDetail.fullAddress)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                        
                        if self.currStatus == .new {
                            HStack {
                                Spacer()
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 1)) {
                                        self.axis = (x: 0, y: 1, z: 0)
                                        self.rotationAngle = -180
                                        self.isRotating = true
                                        self.backContent = "Rejected"
                                        self.showingBack = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
                                        self.currStatus = .rejected
                                        self.rotationAngle = 0
                                        self.isRotating = false
                                        self.showingBack = false
                                        onReject()
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.gray)
                                }
                                .padding(.leading, 20)
                                
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 1)) {
                                        self.axis = (x: 0, y: 1, z: 0)
                                        self.rotationAngle = 180
                                        self.isRotating = true
                                        self.backContent = "Accepted"
                                        self.showingBack = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
                                        self.currStatus = .accepted
                                        self.rotationAngle = 0
                                        self.isRotating = false
                                        self.showingBack = false
                                        onAccept()
                                    }
                                }) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.green)
                                }
                                .padding(.trailing, 20)
                            }
                            .padding(.bottom, 20)
                        }
                        else {
                            Text(self.currStatus == .accepted ? "Accepted" : "Rejected")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(self.currStatus == .accepted ? Color.green : Color.gray)
                                .cornerRadius(10)
                        }
                    }
                    .frame(width: 320, height: 500)
                }
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(radius: 5)
            .padding(.horizontal, 20)
            .rotation3DEffect(
                .degrees(rotationAngle),
                axis: (x: axis.x, y: axis.y, z: axis.z)
            )
        }
        .onAppear {
            self.currStatus = cardDetail.status
        }
    }
}
