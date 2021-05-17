//
//  EndViewController.swift
//  Quiz Game
//
//  Created by Nazlı Güler on 12.05.2021.
//

import UIKit

class EndViewController: UIViewController {
    @IBOutlet weak var RestartButton: UIButton!
    @IBOutlet weak var ScoreLabel: UILabel!
    
    var ScoreData:String!
 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ScoreLabel.text = ScoreData
    }
    

    @IBAction func RestartGame(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
        self.presentingViewController?.dismiss(animated: false, completion: nil)
        
        
        
    }
    

}
