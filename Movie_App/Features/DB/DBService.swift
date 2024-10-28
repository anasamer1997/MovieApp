//
//  DBService.swift
//  WeatherApp
//
//  Created by anas amer on 30/08/2024.
//

import Foundation
import CoreData


enum MovieType {
    case trending, topRated, genre,selectedGenreMovies
}

protocol CoreDataStorageServiceProtocol {
    func saveMoviesInDB<T>(_ item: T,_ type:MovieType) async
    func loadMoviesFromLocalStorage<T>(_ type: MovieType) async -> T?
}

class CoreDataStorageService: CoreDataStorageServiceProtocol {
    
    static let shared = CoreDataStorageService()
    private init() {}
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DB") // Replace with your Core Data model name
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveMoviesInDB<T>(_ item: T, _ type: MovieType) async {
        do {
            switch type {
            case .trending:
                guard let movies = item as? [MovieModel] else { return }
                let request: NSFetchRequest<TrendingMovies> = TrendingMovies.fetchRequest()
                let results = try context.fetch(request)

                for movie in movies {
                    let entity = results.first ?? TrendingMovies(context: context)
                    entity.id = Int32(movie.id)
                    entity.title = movie.title
                    entity.genreIDS = movie.genreIDS as NSObject
                    entity.overview = movie.overview
                    entity.releaseDate = movie.releaseDate
                    entity.voteCount = Int32(movie.voteCount)
                    entity.backdropPath = movie.backdropPath
                    entity.posterPath = movie.posterPath
                }

            case .topRated:
                guard let movies = item as? [MovieModel] else { return }
                let request: NSFetchRequest<TopRatedMovies> = TopRatedMovies.fetchRequest()
                let results = try context.fetch(request)

                for movie in movies {
                    let entity = results.first ?? TopRatedMovies(context: context)
                    entity.id = Int32(movie.id)
                    entity.title = movie.title
                    entity.genreIDS = movie.genreIDS as NSObject
                    entity.overview = movie.overview
                    entity.releaseDate = movie.releaseDate
                    entity.voteCount = Int32(movie.voteCount)
                    entity.backdropPath = movie.backdropPath
                    entity.posterPath = movie.posterPath
                }
            case .selectedGenreMovies:
                guard let movies = item as? [MovieModel] else { return }
                let request: NSFetchRequest<MoviesSelectedGenre> = MoviesSelectedGenre.fetchRequest()
                let results = try context.fetch(request)

                for movie in movies {
                    let entity = results.first ?? MoviesSelectedGenre(context: context)
                    entity.id = Int32(movie.id)
                    entity.title = movie.title
                    entity.genreIDS = movie.genreIDS as NSObject
                    entity.overview = movie.overview
                    entity.releaseDate = movie.releaseDate
                    entity.voteCount = Int32(movie.voteCount)
                    entity.backdropPath = movie.backdropPath
                    entity.posterPath = movie.posterPath
                }
            case .genre:
                guard let genres = item as? [GenreModel] else { return }
                let request: NSFetchRequest<Genre> = Genre.fetchRequest()
                let results = try context.fetch(request)

                for genre in genres {
                    let entity = results.first ?? Genre(context: context)
                    entity.id = Int32(genre.id)
                    entity.name = genre.name
                }
            }

            // Save the context after entity setup
            try context.save()
            print("Data saved successfully")

        } catch {
            print("Error saving or updating data: \(error.localizedDescription)")
        }
    }

    
    func loadMoviesFromLocalStorage<T>(_ type: MovieType) async -> T? {
        switch type {
        case .trending:
            let request: NSFetchRequest<TrendingMovies> = TrendingMovies.fetchRequest()
            do {
                let results = try context.fetch(request)
                let movies: [MovieModel] = results.map { movie in
                    MovieModel(backdropPath: movie.backdropPath,
                               id: Int(movie.id),
                               genreIDS: movie.genreIDS as! [Int] ,
                               overview: movie.overview ?? "",
                               title: movie.title ?? "",
                               posterPath: movie.posterPath,
                               releaseDate: movie.releaseDate,
                               voteAverage: movie.voteAverage,
                               voteCount: Int(movie.voteCount))
                }
                return movies as? T // Return as type T
            } catch {
                print("Error loading trending movies: \(error.localizedDescription)")
                return nil
            }

        case .topRated:
            let request: NSFetchRequest<TopRatedMovies> = TopRatedMovies.fetchRequest()
            do {
                let results = try context.fetch(request)
                let movies: [MovieModel] = results.map { movie in
                    MovieModel(backdropPath: movie.backdropPath,
                               id: Int(movie.id),
                               genreIDS: movie.genreIDS as! [Int] ,
                               overview: movie.overview ?? "",
                               title: movie.title ?? "",
                               posterPath: movie.posterPath,
                               releaseDate: movie.releaseDate,
                               voteAverage: movie.voteAverage,
                               voteCount: Int(movie.voteCount))
                }
                return movies as? T // Return as type T
            } catch {
                print("Error loading top-rated movies: \(error.localizedDescription)")
                return nil
            }
        case .selectedGenreMovies:
            let request: NSFetchRequest<MoviesSelectedGenre> = MoviesSelectedGenre.fetchRequest()
            do {
                let results = try context.fetch(request)
                let movies: [MovieModel] = results.map { movie in
                    MovieModel(backdropPath: movie.backdropPath,
                               id: Int(movie.id),
                               genreIDS: movie.genreIDS as! [Int] ,
                               overview: movie.overview ?? "",
                               title: movie.title ?? "",
                               posterPath: movie.posterPath,
                               releaseDate: movie.releaseDate,
                               voteAverage: movie.voteAverage,
                               voteCount: Int(movie.voteCount))
                }
                return movies as? T // Return as type T
            } catch {
                print("Error loading Selected Genre movies: \(error.localizedDescription)")
                return nil
            }
        case .genre:
            let request: NSFetchRequest<Genre> = Genre.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sortDescriptor]
            do {
                let results = try context.fetch(request)
                let genres: [GenreModel] = results.map { genre in
                    GenreModel(id: Int(genre.id), name: genre.name ?? "")
                }
                return genres as? T // Return as type T
            } catch {
                print("Error loading genres: \(error.localizedDescription)")
                return nil
            }
        }
    }
}
