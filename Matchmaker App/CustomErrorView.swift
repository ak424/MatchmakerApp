//
//  CustomErrorView.swift
//  Matchmaker App
//
//  Created by Arav Khandelwal on 26/07/24.
//

import Foundation
import SwiftUI

struct HBGenericBaseView<Content: View>: View {
    @Binding var viewState: ViewState
    var childView: Content
    
    ///  To show Appropriate view in case of error
    /// - Parameters:
    ///   - apiError:error of type CustomError
    ///   - buttonTitle: title to be shown on button
    ///   - buttonFunctionality: button click action
    /// - Returns: Returns the error view
    func customizedErrorView(apiError: CustomError, buttonTitle: String, buttonFunctionality: @escaping () -> Void) -> CustomErrorView? {
        switch apiError {
            case .networkReachabilityError:
                return CustomErrorView(
                    heading: "No internet connection",
                    imageString: "wifi.exclamationmark",
                    buttonTitle: buttonTitle,
                    buttonAction: buttonFunctionality
                )
            case .timedOutError:
                return CustomErrorView(
                    heading: "Request timed out",
                    imageString: "hourglass",
                    buttonTitle: buttonTitle,
                    buttonAction: buttonFunctionality
                )
            case .defaultError(_), .customizedError(_), .statusCode(_, _):
                return CustomErrorView(
                    heading: "Something went wrong",
                    imageString: "exclamationmark.triangle",
                    buttonTitle: buttonTitle,
                    buttonAction: buttonFunctionality
                )
        }
    }
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 0
        ) {
            if case .fullScreenLoading(let text) = viewState {
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        CustomLottieView(filename: "Custom_Loader")
                            .frame(
                                width: geometry.size.width - 94,
                                height: geometry.size.width - 94 * 0.4
                            )
                        if !text.isEmpty {
                            Text(text)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                                .padding(.top, 56)
                        }
                        Spacer()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            else if case .failure(let apiError, let buttonTitle, let buttonFunctionality) = viewState,
                    let insideView = self.customizedErrorView(
                        apiError: apiError,
                        buttonTitle: buttonTitle,
                        buttonFunctionality: buttonFunctionality
                    )
            {
                insideView
            }
            else {
                childView
            }
        }
    }
}


struct CustomErrorView: View {
    var heading: String
    var imageString: String
    var buttonTitle: String?
    var buttonAction: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            Image(systemName: imageString)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            
            Text(heading)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.black)
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            if let action = buttonAction,
               let title = buttonTitle {
                Button(action: action) {
                    Text(title)
                        .font(.system(size: 16, weight: .bold))
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}
