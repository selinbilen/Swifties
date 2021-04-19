//
//  ViewController.swift
//  scavenger hunt ar
//
//  Created by Nazlı Güler on 19.04.2021.
//

import UIKit
import GameKit

class ViewController: UIViewController {

override func viewDidLoad() {
  super.viewDidLoad()
      authenticateUser()

  
}
    private func authenticateUser() {
      let player = GKLocalPlayer.local
        
    player.authenticateHandler = { vc, error in
         guard error == nil else {
           print(error?.localizedDescription ?? "")
           return
         }
        if let vc = vc {
              self.present(vc, animated: true, completion: nil)
            }
    }

        func showAchievements(_ sender: Any) {
        let vc = GKGameCenterViewController()
            vc.gameCenterDelegate = self as? GKGameCenterControllerDelegate
           vc.viewState = .achievements
           present(vc, animated: true, completion: nil)
    }
    
        func showLeaderboard(_ sender: Any) {
        let vc = GKGameCenterViewController()
            vc.gameCenterDelegate = (self as! GKGameCenterControllerDelegate)
        vc.viewState = .leaderboards
        vc.leaderboardIdentifier = "smarterplayers"
        present(vc, animated: true, completion: nil)
    }
    
        func unlockAchievements(_ sender: Any) {
        let achievement = GKAchievement(identifier: "finished800level")
        achievement.percentComplete = 100
        achievement.showsCompletionBanner = true
        GKAchievement.report([achievement]) { error in
          guard error == nil else {
            print(error?.localizedDescription ?? "")
            return
          }
          print("done!")
        }
    }
    
        func submitScore(_ sender: Any) {
        let score = GKScore(leaderboardIdentifier: "smarterplayers")
          score.value = 100
          GKScore.report([score]) { error in
            guard error == nil else {
              print(error?.localizedDescription ?? "")
              return
            }
            print("done!")
          }
        }
    }
    
    
}
