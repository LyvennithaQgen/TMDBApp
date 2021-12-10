//
//  TMDBModelAPI.swift
//  TMDBApp
//
//  Created by Lyvennitha on 07/12/21.
//

import Foundation
import Alamofire

class TMDBModelAPI{
    static let shared = TMDBModelAPI()
    func getMovieData(parameters: [String: Any],endPoint: MovieURL, onResponse: @escaping (Result<IMDBDataResponse, AFError>) -> ()){
        NetWorkHandler.shared.getRequest(parameters: parameters, endPoint: endPoint, onResponse: onResponse)
    }
}

// MARK: - IMDBDataResponse
public struct IMDBDataResponse: Codable, Hashable {
    public let page: Int?
    public let dates: Dates?
    public var results: [ResultData]?
    public let totalResults, totalPages: Int?

    enum CodingKeys: String, CodingKey {
        case page, dates, results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }

    public init(page: Int?, dates: Dates?, results: [ResultData]?, totalResults: Int?, totalPages: Int?) {
        self.page = page
        self.dates = dates
        self.results = results
        self.totalResults = totalResults
        self.totalPages = totalPages
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - Dates
public struct Dates: Codable, Hashable {
    public let maximum, minimum: String?

    public init(maximum: String?, minimum: String?) {
        self.maximum = maximum
        self.minimum = minimum
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - Result
public struct ResultData: Codable, Hashable {
    public let genreIDS: [Int]?
    public let adult: Bool?
    public let backdropPath: String?
    public let id: Int?
    public let originalTitle: String?
    public let voteAverage, popularity: Double?
    public let posterPath, overview, title: String?
    public let originalLanguage: OriginalLanguage?
    public let voteCount: Int?
    public let releaseDate: String?
    public let video: Bool?

    enum CodingKeys: String, CodingKey {
        case genreIDS = "genre_ids"
        case adult
        case backdropPath = "backdrop_path"
        case id
        case originalTitle = "original_title"
        case voteAverage = "vote_average"
        case popularity
        case posterPath = "poster_path"
        case overview, title
        case originalLanguage = "original_language"
        case voteCount = "vote_count"
        case releaseDate = "release_date"
        case video
    }

    public init(genreIDS: [Int]?, adult: Bool?, backdropPath: String?, id: Int?, originalTitle: String?, voteAverage: Double?, popularity: Double?, posterPath: String?, overview: String?, title: String?, originalLanguage: OriginalLanguage?, voteCount: Int?, releaseDate: String?, video: Bool?) {
        self.genreIDS = genreIDS
        self.adult = adult
        self.backdropPath = backdropPath
        self.id = id
        self.originalTitle = originalTitle
        self.voteAverage = voteAverage
        self.popularity = popularity
        self.posterPath = posterPath
        self.overview = overview
        self.title = title
        self.originalLanguage = originalLanguage
        self.voteCount = voteCount
        self.releaseDate = releaseDate
        self.video = video
    }
}

public enum OriginalLanguage: String, Codable, Hashable {
    case en = "en"
    case es = "es"
    case pt = "pt"
}
