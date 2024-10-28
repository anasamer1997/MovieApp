//
//  SectionsView.swift
//  MovieApp
//
//  Created by anas amer on 26/10/2024.
//

import SwiftUI

struct DetailsSectionsCard: View {
    let section:DetailViewSection
    let nameSpace:Namespace.ID
    @Binding var selectedSection:DetailViewSection
    var body: some View {
        Text(section.rawValue)
            .poppins(.medium,16)
            .background(
                ZStack{
                    if section == selectedSection{
                        RoundedRectangle(cornerRadius: 25.0)
                            .fill(Color.appGrayColor1)
                            .frame(height: 7)
                            .offset(y:20)
                            .matchedGeometryEffect(id: "section", in: nameSpace)
                    }
                }
            )

    }
}

#Preview {
    DetailsSectionsCard(section: .AboutMovie, nameSpace:Namespace().wrappedValue, selectedSection: .constant(.AboutMovie))
}
