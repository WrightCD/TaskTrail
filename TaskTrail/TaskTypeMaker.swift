//
//  TaskTypeMaker.swift
//  TaskTrail
//
//  Created by Carl Wright on 2024-03-25.
//

import UIKit

class TaskTypeMaker: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colours.count
    }
    
    
    @IBOutlet weak var nameBox: UITextField!
    @IBOutlet weak var coloursBox: UITextField!
    @IBOutlet weak var descBox: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    let colours = ["Red", "Green", "Blue", "Yellow", "Orange", "Purple", "Pink", "Brown", "Cyan", "Magenta", "Teal", "Gray"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        coloursBox.inputView = pickerView

        // Do any additional setup after loading the view.
        cancelButton.tintColor = UIColor.red
        cancelButton.isEnabled = true 
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
            // Cancel current view
            navigationController?.popViewController(animated: true)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return colours[row]
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coloursBox.text = colours[row]
    }
    
    @IBAction func createButtonTapped(_ sender: UIButton) {
        //Checking valid input
        guard let name = nameBox.text, !name.isEmpty else {
            showAlert(message: "Please fill in all criteria")
            return
        }
            
        guard name.count <= 16 else {
            showAlert(message: "Name should not be larger than 16 characters")
            return
        }
            
        guard let colour = coloursBox.text, !colour.isEmpty, colours.contains(colour) else {
            showAlert(message: "Please select a valid colour")
            return
        }
            
        guard let desc = descBox.text, !desc.isEmpty else {
            showAlert(message: "Please fill in all criteria")
            return
        }
            
        guard desc.count <= 100 else {
            showAlert(message: "Description should not be larger than 100 characters")
            return
        }
        
        // Success
        let message = "Name: \(name)\nColour: \(colour)\nDescription: \(desc)"
        print(message)
        showAlert(message: "Task Category \(name) created")
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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
