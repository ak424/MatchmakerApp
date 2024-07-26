//
//  MatchmakerImageView.swift
//  Matchmaker App
//
//  Created by Arav Khandelwal on 25/07/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct CustomImageView: View {
    let imageEntity: CustomImageEntity
    
    init(imageEntity: CustomImageEntity) {
        self.imageEntity = imageEntity
    }
    
    init(localFileName: String) {
        self.imageEntity = CustomImageEntity(imageURL: nil, imageName: localFileName)
    }
    
    var body: some View {
        if let imageUrl = imageEntity.imageURL, let url = URL(string: imageUrl) {
            if (url.path as NSString).pathExtension.lowercased() != "gif" {
                WebImage(url: url, options: [.scaleDownLargeImages])
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                AnimatedImage(url: url, options: [.scaleDownLargeImages])
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        } else if let imageString = imageEntity.imageName {
            Image(systemName: imageString)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

struct CustomImageEntity: Codable {
    let imageURL: String?
    let imageName: String?
}
