//
//  ViewController.swift
//  Quiz Game
//
//  Created by selin eylül bilen on 4/24/21.
//

import UIKit

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
    
    let allQuestions = ProvidedQuestions()
    var questionNumber: Int = 0
    var score: Int = 0
    var selectedAnswer: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextQuestion()
        uptUI()
    }

    @IBAction func ansPressed(_ sender: UIButton) {
        //print(selectedAnswer)
        //print(sender.tag)
        if sender.tag == selectedAnswer{
            print("correct")
            score += 10
        }else{
            print("wrong")
        }
        questionNumber += 1
        nextQuestion()
    }
    
    func nextQuestion(){
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
        progress.frame.size.width = (view.frame.size.width / CGFloat(allQuestions.list.count)) * CGFloat(questionNumber + 1)
    }
    
    func restart(){
        score = 0
        questionNumber = 0
        nextQuestion()
    }
}

