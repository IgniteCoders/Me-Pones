//
//  SignUpViewController.swift
//  Me Pones
//
//  Created by Mañanas on 17/9/24.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordRepeatTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUp(_ sender: Any) {
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        Auth.auth().createUser(withEmail: username, password: password) { authResult, error in
            
            if let error = error {
                print("Error al crear usuario")
                print(error.localizedDescription)
                self.showToast(message: error.localizedDescription, seconds: 3)
                return
            } else {
                print("Registro correcto")
                self.backToLogin(self)
                self.showToast(message: "Registro correcto", seconds: 3)
                print("Se ejecutó esta linea")
            }
        }
    }
    
    @IBAction func backToLogin(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
