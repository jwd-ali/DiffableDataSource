//
//  MovieCell.swift
//  CombinePractice
//
//  Created by Jawad Ali on 02/02/2021.
//  Copyright © 2021 Jawad Ali. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var movieNameLabel: UILabel!
   
    var movieObject: Result!
    {
        didSet
        {
            setupData()
        }
    }
    
    func setupData()
    {
        guard
            let unwrappedMovieName = movieObject.title,
            let unwrappedMovieDetails = movieObject.resultDescription
        else { return }
        
        movieNameLabel.text = unwrappedMovieName
        movieDescriptionLabel.text = unwrappedMovieDetails
        
        if
        let unwrappedMovieImage = movieObject.image,
        let imageURL = URL(string: unwrappedMovieImage)
        {
            print(imageURL)
              movieImageView.image = UIImage(named: "placeholder-image")
//            movieImageView.activateSdWebImageLoader()
//            movieImageView.sd_setImage(with: imageURL, completed: nil)
        }
        else
        {
            movieImageView.image = UIImage(named: "placeholder-image")
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
