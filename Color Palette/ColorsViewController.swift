//
//  ColorsViewController.swift
//  Color Palette
//
//  Created by Bruno Pastre on 05/06/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

enum DisplayOptions{
    case palettes
    case colors
}

class ColorsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    


    @IBOutlet weak var collectionView: UICollectionView!
    
    let source = HarmonyProvider.instance
    var currentDisplay: DisplayOptions!
    
    // MARK: - Setup
    override func viewDidLoad() {
        self.currentDisplay = .palettes
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
    // MARK: - Collection delegates
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        if self.currentDisplay == .palettes{
        return source.getPalettes().count
        //        }
        //
        //        return source.getColors().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "paletteCell", for: indexPath) as! PaletteCollectionViewCell
        let palette = self.source.getPalettes()[indexPath.item]
        
        cell.palette = palette
        cell.setupCell()
        
        return cell
    }
    
    // MARK: - Callbacks

    @IBAction func onDisplayChange(_ sender: Any) {
        let segmented = sender as! UISegmentedControl
        switch segmented.selectedSegmentIndex{
        case 0:
            self.currentDisplay = .palettes
        case 1:
            self.currentDisplay = .colors
        default: break
        }
        
        self.updatePresentingCollection()
        
    }
    
    // MARK: - State functions
    
    func updatePresentingCollection(){
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
