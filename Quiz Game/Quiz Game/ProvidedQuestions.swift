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
        list.append(Questions(image: "q1", questionText: "Do you know where this magnificent building was built which is  a temple for the gods? ", choiceA: "A. Romania", choiceB: "B. Italy", choiceC: "C. Greece", choiceD: "D. Iran", answer: 2))
        
        list.append(Questions(image: "q2", questionText: "Who knows what impressive performances were exhibited in this hall, which was opened for use in 1825 ... Well, where is this hall in your opinion?", choiceA: "A. Ukrain", choiceB: "B. Serbia", choiceC: "C. Poland", choiceD: "D. Russia", answer: 4))
        
        list.append(Questions(image: "q3", questionText: "Let's get an estimate of where the historical building is located in this location, which looks like a corner from heaven!", choiceA: "A. Bosnia and Herzegovina", choiceB: "B. Bulgaria", choiceC: "C. Albania", choiceD: "D. Barbados", answer: 1))
        
        list.append(Questions(image: "q4", questionText: "In which country can this building, which is one of the largest cathedrals in Europe, be?.", choiceA: "A. Luxembourg", choiceB: "B. Italy", choiceC: "C. France", choiceD: "D. Portugal ", answer: 2))
        
        list.append(Questions(image: "q5" , questionText: "There are not many words to say about this monastery, which has a perfect view ... So where is this monastery?", choiceA: "A. Peru" , choiceB: "B. Chili" , choiceC: "C. Turkey" , choiceD: "D. China", answer: 3))
        
        list.append(Questions(image: "q6" , questionText: "Do you know in which country this Sun temple, which is 765 years old, is located?", choiceA: "A. Mexico" , choiceB: "B. China" , choiceC: "C. India" , choiceD: "D. Peru", answer: 3))
        
        list.append(Questions(image: "q7", questionText: "In which country do you think this historical mosque was completed in 1848?", choiceA: "A. Palestine", choiceB: "B. Iran", choiceC: "C. Saudi Arabia", choiceD: "D. Egypt", answer: 4))
        
        list.append(Questions(image: "q8", questionText: "I suppose we all agree on how fascinating this city gate, whose construction began in 170 AD, is. So where is this magnificent city gate?", choiceA: "A. Germany", choiceB: "B. Romania", choiceC: "C. Greece", choiceD: "D. Poland", answer: 1))
        
        list.append(Questions(image: "q9" , questionText: "Can you guess what country this great Gothic convent church is in?", choiceA: "A. England" , choiceB: "B. France" , choiceC: "C. Austria" , choiceD: "D. Holland", answer: 1))
        
        list.append(Questions(image: "q10" , questionText: "Do you know in which country this historical building, which is used as a library today, is located?", choiceA: "A. Bahamas" , choiceB: "B. Pakistan" , choiceC: "C. Dominican Republic" , choiceD: "D. Egypt", answer: 2))
    }
}
