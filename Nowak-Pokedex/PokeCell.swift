//
//  PokeCell.swift
//  Nowak-Pokedex
//
//  Created by Chris Nowak on 7/1/16.
//  Copyright © 2016 Chris Nowak Tho, LLC. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    // IBOutlets
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // Properties
    var pokemon: Pokemon!
    
    // Methods
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5.0
    }
    
    func configureCell(pokemon: Pokemon) {
        self.pokemon = pokemon
        nameLabel.text = self.pokemon.name.capitalizedString
        thumbImageView.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
}
