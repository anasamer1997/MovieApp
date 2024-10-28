//
//  searchWidget.swift
//  MovieApp
//
//  Created by anas amer on 23/10/2024.
//

import SwiftUI

struct searchWidget: View {
    @Binding var searchText:String
    var body: some View {
        TextField("Search ", text: $searchText)
            .overlay(
                ZStack{
                    Image(systemName: Image.CancelIcon)
                        .foregroundStyle(.white)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            searchText = ""
                            UIApplication.shared.endEditing()
                        }
                    Image(systemName: Image.SearchIcon)
                        .opacity(searchText.isEmpty ?  1.0 : 0.0)
                    
                    
                }
                ,alignment: .trailing)
            .foregroundStyle(.white)
            .padding()
            .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).fill(.appGrayColor1))
    }
}

#Preview {
    searchWidget(searchText: .constant(""))
}
