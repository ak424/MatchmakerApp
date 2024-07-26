//
//  CustomLottieView.swift
//  Matchmaker App
//
//  Created by Arav Khandelwal on 26/07/24.
//

import SwiftUI
import Lottie

struct CustomLottieView: View {
    
    var filename: String
    
    var body: some View {
        LottieView(animation: .named(filename))
            .looping()
    }
}
