//
//  MovieDetailes.swift
//  MovieApp
//
//  Created by anas amer on 25/10/2024.
//

import SwiftUI


enum DetailViewSection:String{
    case AboutMovie
    case Reviews
    
    var rawValue: String{
        switch self {
        case .AboutMovie:
            "About Movie"
        case .Reviews:
            "Reviews"
        }
    }
}

struct MovieDetailes: View {
    let movietype:[String]
    @StateObject var viewModel:DetailesViewModel
    @Environment(\.dismiss) var dismiss

    @Namespace var namesapce
    init(movie:MovieModel,movieType:[String]) {
        _viewModel = StateObject(wrappedValue: DetailesViewModel(movie: movie))
        self.movietype = movieType
    }
    var body: some View {
        ZStack {
            
            Color.appBackground
            ScrollView {
                VStack(alignment: .leading){
                    Header
                    VStack(alignment:.center){
                        HStack{
                            Image(systemName: Image.CalendarIcon)
                            Text(viewModel.movie.releaseDate ?? "")
                            Text("|")
                            Image.GenreIcon
                            ForEach(movietype,id: \.self){type in
                                Text(type + ",")
                            }
                            
                        }
                        .foregroundStyle(Color.appGrayColor2)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom)
                        HStack(spacing:15){
                            ForEach(viewModel.detailesViewSections,id: \.self){sec in
                                DetailsSectionsCard(section: sec, nameSpace: namesapce, selectedSection: $viewModel.selectedSection)
                                    .onTapGesture {
                                        withAnimation {
                                            viewModel.selectedSection = sec
                                        }
                                }
                            }
                        }.padding(.bottom,25)
                        
                        switch viewModel.selectedSection {
                        case .AboutMovie:
                            Text(viewModel.movie.overview)
                        case .Reviews:

                            ScrollView{
                                LazyVStack{
                                    ForEach(viewModel.reviews){review in
                                       ReviewCard(review: review)
                                    }
                                }
                            }
     
                        
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .padding(.top,contentOffset)
                    
                }
                .task {
                    await viewModel.fetchReviews()
                }
                .preferredColorScheme(.dark)
                .background(Color.appBackground)
                .navigationBarHidden(true)
            }
        }.ignoresSafeArea(edges:.bottom)
    }
    
    var posterImageHeight:CGFloat{
        return screenHeight * 0.35
    }
    var backDropImageSize:CGFloat{
        return screenHeight * 0.20
    }
    var posterImageOffset:CGFloat{
        return screenHeight * 0.15
    }
    var titleOffset:CGFloat{
        return screenHeight * 0.15
    }
    var contentOffset:CGFloat{
        return screenHeight * 0.11
    }
    
}

extension MovieDetailes{
    private var Header :some View{
        ZStack(alignment: .leading){
            ZStack(alignment: .top){
                CustomImageView(itemWidth: screenWidth, itemHeight: posterImageHeight, movie: viewModel.movie)
                
                HStack{
                    Image(systemName: Image.BackIcon)
                        .onTapGesture {
                            dismiss.callAsFunction()
                        }
                    Spacer()
                    Text("Detail")
                    Spacer()
                    
                }
                .padding()
                .background(Color.appBackground)
            }
            
            HStack{
                CustomImageView(itemWidth: backDropImageSize, itemHeight: backDropImageSize, movie: viewModel.movie,movieImageType: .backdrop)
                Text(viewModel.movie.title)
                    .minimumScaleFactor(0.5)
                    .padding(.top,titleOffset)
            }
            .padding()
            .offset(y:posterImageOffset)
        }
    }
}
#Preview {
    MovieDetailes(movie: DeveloperPreview.instance.movie,movieType: ["action"])
}
