//
//  PokemonDetailVC.swift
//  Nowak-Pokedex
//
//  Created by Chris Nowak on 7/7/16.
//  Copyright © 2016 Chris Nowak Tho, LLC. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var pokedexLabel: UILabel!
    @IBOutlet weak var currentEvolutionImageView: UIImageView!
    @IBOutlet weak var nextEvolutionImageView: UIImageView!
    @IBOutlet weak var evolutionLabel: UILabel!
    @IBOutlet weak var baseAttackLabel: UILabel!
    
    // MARK: - Other Properties
    
    var pokemon: Pokemon!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = pokemon.name
        let image = UIImage(named: "\(pokemon.pokedexId)")
        mainImageView.image = image
        currentEvolutionImageView.image = image
        pokemon.downloadPokemonDetails { 
            // this will be called after download is done
            self.updateUI()
        }
    }
    
    // MARK: - Custom Helper Methods
    
    func updateUI() {
        descriptionLabel.text = pokemon.description
        typeLabel.text = pokemon.type
        defenseLabel.text = pokemon.defense
        heightLabel.text = pokemon.height
        pokedexLabel.text = "\(pokemon.pokedexId)"
        weightLabel.text = pokemon.weight
        baseAttackLabel.text = pokemon.attack
        if pokemon.nextEvolutionId == "" {
            evolutionLabel.text = "No Evolutions"
            nextEvolutionImageView.hidden = true
        } else {
            nextEvolutionImageView.hidden = false
            nextEvolutionImageView.image = UIImage(named: pokemon.nextEvolutionId)
            var str = "Next Evolution: \(pokemon.nextEvolutionText)"
            if pokemon.nextEvolutionLevel != "" {
                str += " - LVL \(pokemon.nextEvolutionLevel)"
            }
            evolutionLabel.text = str
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
