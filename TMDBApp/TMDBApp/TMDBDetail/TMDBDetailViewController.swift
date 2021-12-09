//
//  TMDBDetailViewController.swift
//  TMDBApp
//
//  Created by Lyvennitha on 09/12/21.
//

import Foundation
import UIKit

class TMDBDetailViewController: UIViewController{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    var titleStr:String = ""
    var subjectStr: String = ""
    var descriptionStr: String = ""
    var imgURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titleLabel.text = titleStr
        self.subjectLabel.text = subjectStr
        self.descriptionLabel.text = descriptionStr
        DispatchQueue.global().async(qos: .userInitiated) {
            self.imgView.downloaded(from: "https://image.tmdb.org/t/p/w342\(self.imgURL)", contentMode: .scaleToFill)
        }
    }
    
}

