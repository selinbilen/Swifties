//
//  ProvidedQuestions.swift
//  Quiz Game
//
//  Created by selin eylül bilen on 4/24/21.
//

import Foundation

class ProvidedQuestions{
    var list = [Questions]()
    
    init() {
        list.append(Questions(image: "q1", questionText: "What year was Binghamton University founded?", choiceA: "A. 1945", choiceB: "B. 1946", choiceC: "C. 1955", choiceD: "D. 1956", answer: 2))
        
        list.append(Questions(image: "q2", questionText: "What is the Binghamton University athletic teams nickname?", choiceA: "A. Colonials", choiceB: "B. Indians", choiceC: "C. Spiedies", choiceD: "D. Bearcats", answer: 4))
        
        list.append(Questions(image: "q3", questionText: "During the 1960's and seventies, the campus newspaper was called", choiceA: "A. Harpur Herald", choiceB: "B. Campus Crier", choiceC: "C. Colonial News", choiceD: "D. The Voice", answer: 3))
        
        list.append(Questions(image: "q4", questionText: "The University has great facilities, including its own bowling alley. How many lanes does the bowling alley have?", choiceA: "A. 12", choiceB: "B. 8", choiceC: "C. 6", choiceD: "D. 2", answer: 2))
        
        list.append(Questions(image: "q5" , questionText: "In the late 1950's the current campus was under construction, by 1961 the school moves to Vestal. What body organ is the road system patterned after?", choiceA: "A. Kidney" , choiceB: "B. Eye" , choiceC: "C. Brain" , choiceD: "D. Stomach", answer: 3))
        
        list.append(Questions(image: "q6" , questionText: "In 1950, the school changed its name, what was the schools new name?", choiceA: "A. Harpur College" , choiceB: "B. Harvard College" , choiceC: "C. Hillier College" , choiceD: "D. Hinman College", answer: 1))
        
        list.append(Questions(image: "q7", questionText: "What was the school's original name when founded in Endicott NY?", choiceA: "A. Binghamton College", choiceB: "B. Endwell School of Art", choiceC: "C. Triple Cities College", choiceD: "D. Hinman College", answer: 3))
        
        list.append(Questions(image: "q8", questionText: "What is the output of the following program?", choiceA: "A. 5", choiceB: "B. 6", choiceC: "C. Runtime Error", choiceD: "D. Compile Error", answer: 4))
        
        list.append(Questions(image: "q9" , questionText: "What will be the output of the following code snippet?", choiceA: "A. 4 2" , choiceB: "B. 0 4" , choiceC: "C. 4 0" , choiceD: "D. None of the mentioned", answer: 3))
        
        list.append(Questions(image: "q10" , questionText: "What will be the output of the following code snippet?", choiceA: "A. 8 16 64" , choiceB: "B. 2 16 4" , choiceC: "C. 4 8 16" , choiceD: "D. 2 4 8", answer: 2))
    }
}
