//
//  DebugViewController.swift
//  Color Palette
//
//  Created by Bruno Pastre on 11/06/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

class DebugViewController: UIViewController {

    let palette = HarmonyProvider.instance.palettes.first!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onDebug(_ sender: Any) {
        self.testSerializable()
    }
    
    func testSerializable(){
//        guard let json = String(data: self.palette.serialize()!, encoding: .utf8) else { return }
        let json = self.palette.toBase64()
        print(json)
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
