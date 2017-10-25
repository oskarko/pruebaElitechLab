//
//  ELErrorMessageViewController.swift
//  ElitechLab
//
//  Created by Óscar Rodríguez Garrucho on 11/7/17.
//  Copyright © 2017 Óscar Rodríguez Garrucho. All rights reserved.
//

import UIKit

class ELErrorMessageViewController: UIViewController {

    @IBOutlet weak var errorMessage: UILabel!
    
    var messageForLabel : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        errorMessage.text = messageForLabel
        
    }

    func initializeWithMessage(_ message:String){
        messageForLabel = message
    }
    

    @IBAction func closeBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }



}
