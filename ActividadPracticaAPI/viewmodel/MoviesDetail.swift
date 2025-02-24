//
//  MoviesDetail.swift
//  ActividadPracticaAPI
//
//  Created by Alejandra Torres on 24/2/25.
//

import SwiftUI

struct MoviesDetail: View {
    let movie: Movie
    let genres: [Int: String]
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 16){
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")")) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 300)
                                            .clipped()
                                    } else if phase.error != nil {
                                        Color.gray.frame(height: 300)
                                    } else {
                                        ProgressView().frame(height: 300)
                                    }
                                }
                
                //titulo
                Text(movie.title)
                    .font(.title)
                    .bold()
                
                //fecha de estreno
                Text("Estreno: \(movie.releaseDate)")
                    .font(.subheadline)
                    .foregroundStyle(.red)
                Spacer()
                
                //sinopsis
                Text("Sinopsis")
                    .foregroundColor(.gray)
                    
                Text(movie.overview)
                    .font(.body)
                Spacer()
                Text("Categorias")
                    .foregroundColor(.gray)
                    
                Text("\(movie.genre_ids.compactMap { genres[$0] }.joined(separator: ", "))")
                                    .font(.subheadline)
                            
            }.padding()
        }
    }
}

#Preview {
    MoviesView()
}
