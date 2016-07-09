//
//  ViewController.swift
//  Nowak-Pokedex
//
//  Created by Chris Nowak on 6/28/16.
//  Copyright © 2016 Chris Nowak Tho, LLC. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    // IBOutlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Properties
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    
    // View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.returnKeyType = UIReturnKeyType.Done
        self.initAudio()
        self.parsePokemonCsv()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // UICollectionView Methods
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell {
            let poke = self.currentPokemonArray()[indexPath.row]
            cell.configureCell(poke)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let poke = self.currentPokemonArray()[indexPath.row];
        self.performSegueWithIdentifier("PokemonDetailVC", sender: poke)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.currentPokemonArray().count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105, 105)
    }
    
    // UISearchBar Methods
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            self.inSearchMode = false
            self.view.endEditing(true)
        } else {
            self.inSearchMode = true
            let lower = searchBar.text!.lowercaseString
            self.filteredPokemon = pokemon.filter({$0.name.rangeOfString(lower) != nil})
        }
        self.collectionView.reloadData()
    }
    
    // IBActions
    
    @IBAction func musicButtonPressed(sender: UIButton!) {
        if self.musicPlayer.playing {
            self.musicPlayer.stop()
            sender.alpha = 0.5
        } else {
            self.musicPlayer.play()
            sender.alpha = 1
        }
    }
    
    // Custom Helper Methods
    
    func currentPokemonArray() -> [Pokemon] {
        return self.inSearchMode ? self.filteredPokemon : self.pokemon
    }
    
    func initAudio() {
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!
        do {
            self.musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path)!)
            self.musicPlayer.prepareToPlay()
            self.musicPlayer.numberOfLoops = -1
            self.musicPlayer.play()
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    func parsePokemonCsv() {
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        do {
            let csv = try CsvParser(contentsOfURL: path)
            let rows = csv.rows
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(poke)
            }
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailVC = segue.destinationViewController as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailVC.pokemon = poke
                }
            }
        }
    }
    
}

