//
//  ColorsViewController.swift
//  Color Palette
//
//  Created by Bruno Pastre on 05/06/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit
import StoreKit

enum DisplayOptions{
    case palettes
    case colors
}

class ColorsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ShareDelegate, SKPaymentTransactionObserver, SKProductsRequestDelegate {

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var modeSegmentedView: UISegmentedControl!
    
    let source = HarmonyProvider.instance
    var currentDisplay: DisplayOptions!
    
    // MARK: - Setup
    override func viewDidLoad() {
        self.currentDisplay = .palettes
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        SKPaymentQueue.default().add(self)
        self.setupProductRequest()


        NotificationCenter.default.addObserver(self, selector: #selector(self.onKeyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onKeyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.collectionView.allowsMultipleSelection = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        SKPaymentQueue.default().remove(self)
        print("[COLORS TABLE] Just dissapeared")
    }
    
    @objc func onKeyboardWillAppear(_ sender: Any){
//        let notification = sender as! Notification
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            print("notification: Keyboard will show")
//            if self.collectionView.transform == .identity{
//                self.modeSegmentedView.alpha = 0
//                self.collectionView.transform = self.collectionView.transform.translatedBy(x: 0, y: -keyboardSize.height)
////                self.collectionView.frame.origin.y -= keyboardSize.height
//            }
//        }
    }
    
    @objc func onKeyboardWillDisappear(_ sender: Any){
//        self.modeSegmentedView.alpha = 1
//        self.collectionView.transform = .identity
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        let color = #colorLiteral(red: 1, green: 0.6555405855, blue: 0.6453160644, alpha: 1)
        return self.source.getColorCount()
    }
    
//    func addressOf<T: AnyObject>(_ o: T) -> String {
//        let addr = unsafeBitCast(o, to: Int.self)
//        return String(format: "%p", addr)
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.currentDisplay == .palettes{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "paletteCell", for: indexPath) as! PaletteCollectionViewCell
            
            let palette = self.source.palettes[indexPath.item]
            
            cell.palette = palette
            cell.delegate = self
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
    
    // MARK: - Share delegate
    
    func onSharePressed(sender: Any) {
        var vc: UIActivityViewController!
        
        if self.currentDisplay == .palettes{
            let palette = sender as! Palette
            let item = PaletteActivityItemProvider(placeholderItem: "asd")
            vc = UIActivityViewController(activityItems: [item], applicationActivities: nil)
            
            item.palette = palette
        }else{
            let color = sender as! HSV
            let item = ColorActivityItemProvider(placeholderItem: "asd")
            vc = UIActivityViewController(activityItems: [item], applicationActivities: nil)
            
            item.color = color
        }
        
        
        self.present(vc, animated: true, completion: nil)
        if UIDevice.current.userInterfaceIdiom == .pad{
            if let popOver = vc.popoverPresentationController {
                popOver.sourceView = self.view
            }
        }
    }

    
    // MARK: - StoreKit helpers
    
    func setupProductRequest(){
        print("Called setup fo product requests")
        let request = SKProductsRequest(productIdentifiers: Set(["fullversion"]))
        request.delegate = self
        request.start()
        print("requested products from the store")
    }
    
    // MARK: - StoreKit delegates
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("I have transactions!", transactions)
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let prod = response.products
        print("Recebi produtos" , response.products.count)
        for p in prod{
            print(p.localizedDescription, p.localizedTitle, p.price)
          
            
        }
    }
}
