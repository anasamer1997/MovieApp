//
//  ReviewCard.swift
//  MovieApp
//
//  Created by anas amer on 26/10/2024.
//

import SwiftUI
import SDWebImageSwiftUI
struct ReviewCard: View {
    let review:Review
    
    var body: some View {
        VStack(alignment:.leading){
            HStack{
                AsyncImage(url: URL(string: review.authorImage)) { image in
                    image
                        .resizable()
                       
                } placeholder: {
                    ZStack{
                        Color.appGrayColor1
                            
                        if let firstChart = review.autherName.first{
                            Text(String(firstChart))
                        }
                    }
                }
                .scaledToFill()
                .frame(width: 45,height: 45)
                .clipShape(Circle())
                
                Text(review.autherName)
                    .poppins(.medium,16)
            }
            Text(review.content)
                .poppins(.light)
            Divider()
        }
    }
}

#Preview {
    ReviewCard(review: DeveloperPreview.instance.review)
}
