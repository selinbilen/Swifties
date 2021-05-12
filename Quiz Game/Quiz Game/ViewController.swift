//
//  ViewController.swift
//  Quiz Game
//
//  Created by selin eylül bilen on 4/24/21.
//

import UIKit
import SpriteKit
import GameplayKit

class ViewController: UIViewController {

    @IBOutlet weak var questionCount: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var progress: UIView!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var questionImage: UIImageView!
    
    //Buttons
    @IBOutlet weak var optionA: UIButton!
    @IBOutlet weak var optionB: UIButton!
    @IBOutlet weak var optionC: UIButton!
    @IBOutlet weak var optionD: UIButton!
    
    var allQuestions = ProvidedQuestions()
    var questionNumber: Int = 0
    var score: Int = 0
    var selectedAnswer: Int = 0
    var timerTest: Timer? = nil
    var countDown = 0
    var stopEverything = true
    var scoreText = SKLabelNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allQuestions.list.shuffle()
        nextQuestion()
        uptUI()
    }

    @IBAction func ansPressed(_ sender: UIButton) {
        if sender.tag == selectedAnswer{
            print("correct")
            score += 10
        }else{
            print("wrong")
        }
        questionNumber += 1
        nextQuestion()
        countDown = 0
    }
    
    func nextQuestion(){
        timerTest?.invalidate()
        timerTest = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(ViewController.startCountDown), userInfo: nil, repeats: true)
        if questionNumber <= allQuestions.list.count - 1{
            questionImage.image = UIImage(named:(allQuestions.list[questionNumber].questionImage))
            question.text = allQuestions.list[questionNumber].questionLbl
            optionA.setTitle(allQuestions.list[questionNumber].optionA, for: UIControl.State.normal)
            optionB.setTitle(allQuestions.list[questionNumber].optionB, for: UIControl.State.normal)
            optionC.setTitle(allQuestions.list[questionNumber].optionC, for: UIControl.State.normal)
            optionD.setTitle(allQuestions.list[questionNumber].optionD, for: UIControl.State.normal)
            selectedAnswer = allQuestions.list[questionNumber].correctAnswer
            uptUI()
        }
        else {
            let alert = UIAlertController(title: "Awesome", message: "End of Quiz. Do you want to start over?", preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Restart", style: .default, handler: {action in self.restart()})
            alert.addAction(restartAction)
            present(alert, animated: true, completion: nil)
        }
    }
    func uptUI(){
        scoreLabel.text = "Score: \(score)"
        questionCount.text = "\(questionNumber + 1)/\(allQuestions.list.count)"
    }
    func restart(){
        score = 0
        questionNumber = 0
        nextQuestion()
    }
    @objc func startCountDown(){
        if countDown < 21{
            print(countDown)
            progress.frame.size.width = (view.frame.size.width - 20.7 * CGFloat(countDown))
            countDown += 1
        }
        if countDown == 21 {
            countDown = 0
            score = 0
            questionNumber = questionNumber + 1
            nextQuestion()
        }
    }
}

