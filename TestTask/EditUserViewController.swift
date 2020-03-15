//
//  EditUserViewController.swift
//  TestTask
//
//  Created by Sergey Vorobey on 06/03/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class EditUserViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var saveButtonLabel: UIButton!
    
    var humanCurrent: UserDataPlist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        
        if let saveButton = saveButtonLabel {
            saveButton.isEnabled = false
        }
        
        if let humanCurrent = humanCurrent {
            firstNameTextField.text = humanCurrent.firstName
            lastNameTextField.text = humanCurrent.lastName
            ageTextField.text = humanCurrent.age
        }
        
        errorLabel.alpha = 0
        
        firstNameTextField.addTarget(self,
                                     action: #selector(checkValidDataTextFields),
                                     for: .editingChanged)
        
        lastNameTextField.addTarget(self,
                                    action: #selector(checkValidDataTextFields),
                                    for: .editingChanged)
        
    }
    
    // check method error
    private func displayWarning(withText text: String) {
        
        errorLabel.text = text
        
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.errorLabel.alpha = 1
        }) { [weak self] complate in
            self?.errorLabel.alpha = 0
        }
    }
    
    //check empty or spaces only text fields
    private func checkMandatoryFields() {
        
        if let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            firstName.trimmingCharacters(in: .whitespaces).isEmpty ||
                lastName.trimmingCharacters(in: .whitespaces).isEmpty {
            displayWarning(withText: "Пожалуйста, заполните все поля!")
            return
            
        } else {
            
            displayWarning(withText: "Сохранено!")
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        checkMandatoryFields()
        
        let key = "Users"
        let value = ["User 3": ["firstName": firstNameTextField.text,
                                            "lastName": lastNameTextField.text,
                                            "age": ageTextField.text]
                ]
        let path = Bundle.main.path(forResource: "DataUsers", ofType: "plist")
        let url = URL(fileURLWithPath: path!)
        let dict = NSMutableDictionary()/* = [firstNameTextField.text:
                                                                ["firstName": firstNameTextField.text,
                                                                "lastName": lastNameTextField.text,
                                                                "age": ageTextField.text]]*/
        dict.setValue(value, forKey: key)
        dict.write(to: url, atomically: false)
        //        print(dict)

        let resultDictionary = NSMutableDictionary(contentsOfFile: path!)
        print(resultDictionary as Any)
    }
    
    @objc func checkValidDataTextFields() {
        
        if firstNameTextField.text!.isEmpty == false, lastNameTextField.text!.isEmpty == false {
            saveButtonLabel.isEnabled = true
            
        } else {
            
            saveButtonLabel.isEnabled = false
        }
    }
    
    @IBAction func viewButton(_sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension EditUserViewController: UITextFieldDelegate {
    
    // hide keyboard after tap Done text Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
