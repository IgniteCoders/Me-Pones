//
//  ViewController.swift
//  Me Pones
//
//  Created by Mañanas on 13/9/24.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signIn(_ sender: Any) {
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        Auth.auth().signIn(withEmail: username, password: password) { [unowned self] authResult, error in
            
            if let error = error {
                print("Error al iniciar sesión")
                print(error.localizedDescription)
                return
            } else {
                print("Login correcto")
                self.goToHome()
            }
        }
    }
    
    @IBAction func googleSignIn(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                print("Error obteniendo el usuario o el token")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    print("Error al iniciar sesión con Google")
                    print(error.localizedDescription)
                    return
                } else {
                    print("Login correcto con Google")
                    self.goToHome()
                }
            }
        }
    }
    
    func goToHome() {
        self.performSegue(withIdentifier: "goToHome", sender: self)
    }
}

