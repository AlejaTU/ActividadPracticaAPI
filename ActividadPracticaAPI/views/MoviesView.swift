import SwiftUI

struct MoviesView: View {
    @ObservedObject var viewModel = MoviesViewModel()
    @FocusState private var isTextFieldFocused: Bool
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Cabecera
                    HStack {
                        Spacer()
                        Text("🎥").font(.largeTitle)
                        Text("MOVIES")
                            .font(.largeTitle)
                            .bold()
                        Text("🍿").font(.largeTitle)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Buscador
                    TextField("Buscar película", text: $viewModel.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 300)
                        .focused($isTextFieldFocused)
                        .submitLabel(.search)
                        .onSubmit {
                            viewModel.searchMode = true
                            isTextFieldFocused = false
                        }
                        .onChange(of: viewModel.searchText) { oldValue, newValue in
                            if newValue.isEmpty {
                                viewModel.searchMode = false
                            }
                        }
                    
                    // Grid de películas
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.filteredMovies) { movie in
                            NavigationLink {
                                
                                MoviesDetail(movie: movie, genres: viewModel.genres)
                            } label: {
                                VStack(alignment: .leading, spacing: 3) {
                                    ZStack(alignment: .topTrailing) {
                                        AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")")) { phase in
                                            if let image = phase.image {
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                            } else if phase.error != nil {
                                                Color.gray
                                            } else {
                                                ProgressView()
                                            }
                                        }
                                        .frame(height: 200)
                                        
                                        
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 40, height: 40)
                                            .overlay(
                                                Text(String(format: "%.1f", movie.voteAverage))
                                                    .font(.caption)
                                                    .foregroundColor(.white)
                                            )
                                            .padding(6)
                                    }
                                    .frame(maxWidth: .infinity)
                                    
                                    Text(movie.title)
                                        .font(.headline)
                                        .lineLimit(2)
                                        .padding(10)
                                    Text(movie.genre_ids.compactMap { viewModel.genres[$0] }.joined(separator: ", "))
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 2)
                                .frame(height: 300)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    MoviesView()
}
