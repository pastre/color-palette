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
    
    @IBOutlet weak var deleteButton: UIButton!
    
    let doneButton: UIButton = {
        var button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "done"), for: .normal)
    
        return button
    }()
    
    let source = HarmonyProvider.instance
    
    var currentDisplay: DisplayOptions!
    var isDeleting: Bool!
    
    // MARK: - Setup
    override func viewDidLoad() {
        self.currentDisplay = .palettes
        self.isDeleting = false
        
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        SKPaymentQueue.default().add(self)
        self.setupProductRequest()
        
        self.collectionView.allowsMultipleSelection = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        SKPaymentQueue.default().remove(self)
        print("[COLORS TABLE] Just dissapeared")
    }
    
    func setupDoneButton(){
        self.doneButton.addTarget(self, action: #selector(self.onDone), for: .touchDown)
        self.view.addSubview(self.doneButton)
        self.doneButton.widthAnchor.constraint(equalTo: self.deleteButton.widthAnchor).isActive = true
        self.doneButton.heightAnchor
            .constraint(equalTo: self.deleteButton.heightAnchor).isActive = true
        self.doneButton.centerYAnchor.constraint(equalTo: self.deleteButton.centerYAnchor).isActive = true
        self.doneButton.leadingAnchor
            .constraint(equalTo: self.deleteButton.trailingAnchor, constant: 10).isActive = true
        
        
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
    
    
    func onRefresh(){
        print("Refresh!")
    }
    
    func onDelete(){
        print("Delete!")
        self.isDeleting = !self.isDeleting
        
        if self.isDeleting {
            self.showDeleteOptions()
        } else {
            self.hideDeleteOptions()
        }
        self.collectionView.reloadData()
        
    }
    
    func showDeleteOptions() {
        let duration: TimeInterval = 0.2
        let scale:  CGFloat = 0.05
        UIView.animate(withDuration: duration, animations: {
            self.deleteButton.transform = self.deleteButton.transform.scaledBy(x: scale, y: scale)
        }) { (_) in
            
            self.deleteButton.setImage(UIImage(named: "close"), for: .normal)
            self.setupDoneButton()
            self.doneButton.transform = self.doneButton.transform.scaledBy(x: scale, y: scale)
            
            UIView.animate(withDuration: duration) {
                self.deleteButton.transform = .identity
                self.doneButton.transform = .identity
            }
        }
    }
    
    func hideDeleteOptions() {
        UIView.animate(withDuration: 0.2, animations: {
            self.deleteButton.alpha = 0
            self.doneButton.transform = self.doneButton
                .transform.translatedBy(x: -10 - self.deleteButton.frame.width, y: 0)
            self.doneButton.alpha = 0
        }) { (_) in
            self.doneButton.removeFromSuperview()
            self.deleteButton.setImage(UIImage(named: "delete"), for: .normal)
            self.deleteButton.alpha = 1
            self.doneButton.alpha = 1
        }
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
    
    @objc func onDone(){
        
    }
    
    @IBAction func onTap(_ sender: UIButton){
        switch sender.tag{
        case 1:
            self.onRefresh()
        case 2:
            self.onDelete()
        default: break
        }
    }
    
    
}
