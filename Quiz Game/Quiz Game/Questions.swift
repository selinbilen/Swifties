//
//  Questions.swift
//  Quiz Game
//
//  Created by selin eylül bilen on 4/24/21.
//

import Foundation

class Questions{
    let questionImage: String
    let questionLbl: String
    let optionA: String
    let optionB: String
    let optionC: String
    let optionD: String
    let correctAnswer: Int
    
    init(image: String, questionText: String, choiceA: String, choiceB: String, choiceC: String, choiceD: String, answer: Int){
        questionImage = image
        questionLbl = questionText
        optionA = choiceA
        optionB = choiceB
        optionC = choiceC
        optionD = choiceD
        correctAnswer = answer
    }
}
