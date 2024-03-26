//
//  ViewController.swift
//  TaskTrail
//
//  Created by Carl Wright on 2024-02-27.
//  100875122

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
        
    let textArray = [
        "\"Strive not to be a success but rather to be of value\"\n- Albert Einstein",
        "“The happiness of your life depends on the quality of your thoughts.”\n- Marcus Aurelius",
        "“Nothing is impossible. The word itself says ‘I'm possible!'”\n- Audrey Hepburn",
        "“Happiness is not something readymade. It comes from your own actions.”\n- Dalai Lama",
        "“Folks are usually about as happy as they make up their minds to be.”\n- Abraham Lincoln",
        "“Develop success from failures. Discouragement and failure are two of the surest stepping stones to success.”\n- Dale Carnegie",
        "“It is during our darkest moments that we must focus to see the light.”\n- Aristotle",
        "\"For me life is continuously being hungry. The meaning of life is not simply to exist, to survive, but to move ahead, to go up, to achieve, to conquer.\"\n- Arnold Schwarzenegger"
    ]
        
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        startTimer()
        updateDateLabel()
    }
    
    //Get the date in the proper format
    func updateDateLabel() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let currentDate = dateFormatter.string(from: Date())
            dateLabel.text = currentDate
        }
    
    //Quote Changing Timer
    func startTimer() {
            timer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(updateText), userInfo: nil, repeats: true)
            timer?.fire() // Fire the timer immediately upon starting
        }
        
        @objc func updateText() {
            // Flash white during transition
                textView.backgroundColor = .white
                UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveLinear], animations: {
                    self.textView.backgroundColor = .black
                }, completion: nil)
            
            // Random Quote
            let randomIndex = Int(arc4random_uniform(UInt32(textArray.count)))
            textView.text = textArray[randomIndex]
        }
        
        deinit {
            // Invalidate the timer when the view controller is deallocated
            timer?.invalidate()
        }
    
    


}

