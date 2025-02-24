//
//  MoviesViewModel.swift
//  ActividadPracticaAPI
//
//  Created by Alejandra Torres on 23/2/25.
//

import Foundation

//gestionara la peticion

@MainActor
class MoviesViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var genres: [Int: String] = [:]
    @Published var searchText: String = ""
    
    @Published var searchMode: Bool = false  // Modo de búsqueda exacta al presionar enter

    //para filtrar las peliculas en el buscador
       var filteredMovies: [Movie] {
           if searchText.isEmpty {
               return movies
           } else if searchMode {
               // Filtrar por coincidencia exacta
               return movies.filter { $0.title.lowercased() == searchText.lowercased() }
           } else {
               // Filtrar por coincidencia parcial
               return movies.filter { $0.title.lowercased().contains(searchText.lowercased()) }
           }
       }
    
    init(){
        //cargamos las peliculas y luego los generos
        Task {
                await fetchTopRatedMovies()
                await fetchGenres()
            }
    }
    
    //peticion a la api
    func fetchTopRatedMovies() async {
            guard let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated")else {
                print("URL INVLIDa")
                return }
      
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
            //ponemos el token aqui
        request.setValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyNTZkMTM5YjI5NjY1NmZhMzY4MGJkZjk2MzVlMmNhNCIsIm5iZiI6MTcxNDQxNDU2Mi4zLCJzdWIiOiI2NjJmZTNlMmExOTlhNjAxMjg3MmYwOGQiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.EwwpykF_BmIQ-Rlw9Jc910fkSFYMvkDNGtF7JdhT8Fc", forHTTPHeaderField: "Authorization")
        
        do {
            print("REalizando llamada a pelicula")
                 let (data, _) = try await URLSession.shared.data(for: request)
            print("datos recibidos: \(data.count) bytes")
            let moviesResponse = try JSONDecoder().decode(MoviesResponse.self, from: data)
            print("Peliculs decodificadas \(moviesResponse.results.count)")
            movies = moviesResponse.results
             } catch {
                 print("Error al obtener películas: \(error.localizedDescription)")
             }
    }


func fetchGenres() async{

       guard let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list") else {
           print("URL INVALIDA")
           return }
       var request = URLRequest(url: url)
       request.httpMethod = "GET"
    request.setValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyNTZkMTM5YjI5NjY1NmZhMzY4MGJkZjk2MzVlMmNhNCIsIm5iZiI6MTcxNDQxNDU2Mi4zLCJzdWIiOiI2NjJmZTNlMmExOTlhNjAxMjg3MmYwOGQiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.EwwpykF_BmIQ-Rlw9Jc910fkSFYMvkDNGtF7JdhT8Fc", forHTTPHeaderField: "Authorization")
       
    do {
        print("REalizando llamada a los generos")
            let (data, _) = try await URLSession.shared.data(for: request)
        print("Datos de genero recibidos \(data.count)")
            let genresResponse = try JSONDecoder().decode(GenresResponse.self, from: data)
        print("Generos decodificados \(genresResponse.genres.count)")
          
        genres = Dictionary(uniqueKeysWithValues: genresResponse.genres.map { ($0.id, $0.name) })
        } catch {
            print("Error al obtener géneros: \(error.localizedDescription)")
        }
   
}
}
