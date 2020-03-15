//
//  ViewController.swift
//  TestTask
//
//  Created by Sergey Vorobey on 06/03/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var loginProgressView: UIProgressView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorLabel: UILabel!
    
    private var users: UsersAuth?
    private var userProvider: UserProvider = UserProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        users = userProvider.user
        
        loginTextField.text = userProvider.user.login
        passwordTextField.text = userProvider.user.password
        
        errorLabel.alpha = 0
        loginProgressView.alpha = 0

        loginTextField.delegate = self
        passwordTextField.delegate = self
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateChangeFrame(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateChangeFrame(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        loginProgressView.alpha = 0
//        loginTextField.text = ""
//        passwordTextField.text = ""
    }
    
    
    @IBAction func signInPressed(_ sender: UIButton) {
        
        checkData()
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "RegisterViewController", sender: nil)
        
    }
}

extension SignInViewController: UITextFieldDelegate {
    
    // hide keyboard after tap Done text Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SignInViewController {
    
    //method keyboard appearance and disappearance animation
    @objc func updateChangeFrame (notification: Notification) {
              
              guard let userInfo = notification.userInfo as? [String: AnyObject],
                  
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
                  else { return }
       
              if notification.name == UIResponder.keyboardWillShowNotification {

                  self.bottomConstraint.constant = keyboardFrame.height + 5
                  
                  UIView.animate(withDuration: 0.5) {
                      
                      self.view.layoutIfNeeded()
                  }
                  
              } else {
                  
                  self.bottomConstraint.constant =  100
                  
                  UIView.animate(withDuration: 0.25) {
                      
                      self.view.layoutIfNeeded()
            }
        }
    }
}

extension SignInViewController {
    
    // Warning label if there is an error
    func displayWarning(withText text: String) {
        
        errorLabel.text = text
        
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.errorLabel.alpha = 1
        }) { [weak self] complate in
            self?.errorLabel.alpha = 0
        }
    }
    
    // Error checking method
    private func checkData() {
        
        let progress = Progress(totalUnitCount: 10)
        
        guard let login = loginTextField.text,
              let password = passwordTextField.text,
                login != "",
                password != ""
        else {
            displayWarning(withText: "Fill in all the fields")
            return
        }
        
        guard let userLogin = users?.login, let userPassword = users?.password else {
            return
        }
        
        if userLogin.elementsEqual(login), userPassword.elementsEqual(password) {
                
                loginProgressView.alpha = 1
                
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] (timer) in
                    
                   guard progress.isFinished == false else {
                        timer.invalidate()
    
                    self?.loginProgressView.progress = 0
                    self?.performSegue(withIdentifier: "AccountUserViewController", sender: nil)
                    return
                
                    }
                    progress.completedUnitCount += 3
                    
                    let progressFloat = Float(progress.fractionCompleted)
                    self?.loginProgressView.setProgress(progressFloat, animated: true)
                }
            } else {
                
                loginProgressView.alpha = 1

                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] (timer) in

                guard progress.isFinished == false else {
                    timer.invalidate()

                self?.displayWarning(withText: "Error Data")
                self?.loginProgressView.alpha = 0
                self?.loginProgressView.progress = 0
                
                return
                    
                }

                progress.completedUnitCount += 3

                let progressFloat = Float(progress.fractionCompleted)
                self?.loginProgressView.setProgress(progressFloat, animated: true)
            }
        }
    }
}


