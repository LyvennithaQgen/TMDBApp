//
//  ViewController.swift
//  TMDBApp
//
//  Created by Lyvennitha on 07/12/21.
//

import UIKit
import Alamofire

class ViewController: UIViewController, NetworkConstants {
    
    var baseURL: String = "https://api.themoviedb.org/3/movie/now_playing"
    
    var method: String = ""
    typealias UserDataSource = UICollectionViewDiffableDataSource<Section,ResultData>
    typealias UserSnapshot = NSDiffableDataSourceSnapshot<Section,ResultData>
    
    var movieList: IMDBDataResponse?
    var dataSource : UserDataSource!
    
    
    @IBOutlet weak var movieListCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetWorkHandler.shared.delegate = self
        configureDataSource()
        getMovieData()
       
    }
    
    
}
extension ViewController{
    
    private func configureDataSource(){
        dataSource = UserDataSource(collectionView: movieListCollectionView, cellProvider: {(collection, indexPath, data) -> UICollectionViewCell in
            if data.voteAverage ?? 0.0 > 7{
                let cell = collection.dequeueReusableCell(withReuseIdentifier: "popular", for: indexPath) as? PopularMovieCell
                cell?.closeButton.addTarget(self, action: #selector(self.deleteAction(_:)), for: .touchUpInside)
                DispatchQueue.global(qos: .userInitiated).async{
                    cell?.imgView.downloaded(from: "https://image.tmdb.org/t/p/w342\(data.backdropPath ?? "")", contentMode: .scaleToFill)
                }
                return cell!
            }
            let cell = collection.dequeueReusableCell(withReuseIdentifier: "unpopular", for: indexPath) as? UnPopularMovieCell
            cell?.movieTitle.text = data.title
            cell?.movieDEscription.text = data.overview
            cell?.closeButton.addTarget(self, action: #selector(self.deleteAction(_:)), for: .touchUpInside)
            DispatchQueue.global(qos: .userInitiated).async{
                cell?.imgView.downloaded(from: "https://image.tmdb.org/t/p/w342\(data.posterPath ?? "")", contentMode: .scaleToFill)
            }
            
            return cell!
        })
    }
    
    func update(with list: [ResultData], animate: Bool = false, toSec: Section) {
        var snapshot =  UserSnapshot()
        snapshot.appendSections(Section.allCases)
        for value in Section.allCases{
            list.forEach({(data) in
                snapshot.appendItems([data], toSection: value)
            })
            
        }
        dataSource.apply(snapshot, animatingDifferences: animate)
        
    }
    
    func deleteRow(indexPath: IndexPath){
        if let deleteContent = dataSource.itemIdentifier(for:indexPath){
            var snapshot = dataSource.snapshot()
            snapshot.deleteItems([deleteContent])
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    @objc func deleteAction(_ sender: UIButton){
        let buttonPosition = sender.convert(CGPoint.zero, to: self.movieListCollectionView)
         let indexPath = self.movieListCollectionView.indexPathForItem(at: buttonPosition)
        self.deleteRow(indexPath:IndexPath(row: indexPath!.row, section: 0 ))
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionSize = collectionView.frame.size
        if movieList?.results?[indexPath.row].voteAverage ?? 0.0 > 7{
            return CGSize(width: collectionSize.width, height: collectionSize.width*0.75)
        }
        
        return CGSize(width: collectionSize.width, height: 250)
        //return UICollectionViewFlowLayout.automaticSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = movieList?.results?[indexPath.row]
        let vc = storyboard?.instantiateViewController(identifier: "TMDBDetailViewController") as? TMDBDetailViewController
        vc?.titleStr = data?.title ?? ""
        vc?.subjectStr = data?.releaseDate ?? ""
        vc?.descriptionStr = data?.overview ?? ""
        vc?.imgURL = data?.backdropPath ?? ""
        vc?.modalPresentationStyle = .overCurrentContext
        self.navigationController?.pushViewController(vc!, animated: false)
        
    }
}

extension ViewController{
    func getMovieData(){
        TMDBViewModel.shared.getMovieList(parameters: ["api_key":"a07e22bc18f5cb106bfe4cc1f83ad8ed"], endPoint: .movieList, onResponse: {(result) in
            switch result{
            case .success(let data):
                self.movieList = data
                DispatchQueue.main.async {
                    self.update(with: data.results!, toSec: .first)
                }
            case .failure(let error):
                print(error.localizedDescription)
                
            }
            
        })
    }
    
}

enum Section: CaseIterable {
    case first
}

class PopularMovieCell: UICollectionViewCell{
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
}

class UnPopularMovieCell: UICollectionViewCell{
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDEscription: UILabel!
    @IBOutlet weak var closeButton: UIButton!
}



extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        DispatchQueue.main.async {[self] in
            contentMode = mode
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

