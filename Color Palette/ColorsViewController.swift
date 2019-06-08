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

class HarmonifyProvider: UIActivityItemProvider{
    
//    init(item: String){
//        super.init(placeholderItem: item)
//    }
//
    var palette =  HarmonyProvider.instance.palettes.first!
    func getSketchPalette() -> URL?{
        var url = URL(fileURLWithPath: NSTemporaryDirectory())
        url.appendPathComponent(self.palette.name)
        url.appendPathExtension("sketchpalette")
        
        guard let string = SketchConverter(palette: self.palette).getJson() else { return nil }
        do {
            try string.write(to: url, atomically: true, encoding: .utf8)
            return url
        } catch let error {
            print("Error writing to file", error.localizedDescription)
        }
        return nil
    }
    
    func getPaletteDescription() -> String{
        var ret = ""
        for color in self.palette.colors{
            let rgb = RGB(fromHSV: color)
            let hex = color.getDescriptiveHex()
            let toAppend = """
                #\(hex):
                    Red: \(rgb.red),
                    Green: \(rgb.green),
                    Blue: \(rgb.blue),
            
            """
            ret += toAppend
        }
        return ret
    }
    
    override var item: Any{
        switch self.activityType!
        {
        case .airDrop:
            if let url = self.getSketchPalette(){
                return url
            }
        default: break
        }
        
        return """
        Check out this palette I created using Harmonify:
        \(self.getPaletteDescription())
        Harmonify is avaiable at App Store
        Download now <COLOCAR A URL AQUI>
        """
    }
    
}



class ColorsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ShareDelegate {
    
    func onSharePressed(sender: Any) {
        
        let item = HarmonifyProvider(placeholderItem: "asd")
//        let cell = sender as! ColorCollectionViewCell
        let vc = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let source = HarmonyProvider.instance
    var currentDisplay: DisplayOptions!
    
    // MARK: - Setup
    override func viewDidLoad() {
        self.currentDisplay = .palettes
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self

        let a = SketchConverter(palette: self.source.palettes.first!)
        print(a.getJson()!)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
    // MARK: - Collection delegates
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.currentDisplay == .palettes{
            return self.source.getPaletteCount()
        }
        return self.source.getColorCount()
    }
    
    func addressOf<T: AnyObject>(_ o: T) -> String {
        let addr = unsafeBitCast(o, to: Int.self)
        return String(format: "%p", addr)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.currentDisplay == .palettes{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "paletteCell", for: indexPath) as! PaletteCollectionViewCell
            let palette = self.source.getPallete(at: indexPath)
            print(addressOf(palette))
            cell.palette = palette
            cell.setupCell()
            
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! ColorCollectionViewCell
        let color = self.source.getColor(at: indexPath)
        cell.color = color
        cell.setupCell()
        cell.delegate = self
        return cell
    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if self.currentDisplay != .palettes { return }
//
//
//
//    }
    
    // MARK: - Callbacks

    @IBAction func onDisplayChange(_ sender: Any) {
        let segmented = sender as! UISegmentedControl
        let prevState = self.currentDisplay
        switch segmented.selectedSegmentIndex{
        case 0:
            self.currentDisplay = .palettes
        case 1:
            self.currentDisplay = .colors
        default: break
        }
        if prevState != self.currentDisplay{
            self.updatePresentingCollection()
        }
    }
    
    // MARK: - State functions
    
    func updatePresentingCollection(){
     self.collectionView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "colorDetails"{
            let src = sender as! BaseColorCollectionViewCell
            let dest = segue.destination as! ColorDetailViewController
            dest.color = src.color
            dest.displaysBlur = true
        }
    }
}
