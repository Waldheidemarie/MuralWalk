//
//  MuralListTableViewCell.swift
//  CityArt
//
//  Created by Colin Smith on 6/20/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit

class MuralListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var localeLabel: UILabel!
    
    @IBOutlet weak var cellStackView: UIStackView!
    
    var mural: Mural?{
        didSet{
            updateViews()
        }
    }
    
    func updateViews(){
        guard let mural = mural else {return}
        titleLabel.text = mural.title
        artistLabel.text = mural.artist
        yearLabel.text = mural.yearInstalled
        configureStackView()
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        

    }
    func configureStackView(){
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
