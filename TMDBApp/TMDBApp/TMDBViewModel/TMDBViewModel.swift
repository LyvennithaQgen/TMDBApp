//
//  TMDBViewModel.swift
//  TMDBApp
//
//  Created by Lyvennitha on 09/12/21.
//

import Foundation
import Alamofire

class TMDBViewModel{
    static let shared = TMDBViewModel()
    func getMovieList(parameters: [String: Any],endPoint: MovieURL, onResponse: @escaping (Result<IMDBDataResponse, AFError>) -> ()){
        TMDBModelAPI.shared.getMovieData(parameters: parameters, endPoint: endPoint, onResponse: {(result) in
            switch result{
            case .success(let data):
                onResponse(.success(data))
            case .failure(let error):
                onResponse(.failure(error))
            }
        })
    }
}
