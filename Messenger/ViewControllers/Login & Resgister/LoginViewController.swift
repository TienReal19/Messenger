//
//  LoginViewController.swift
//  Messenger
//
//  Created by Valerian   on 18/11/2020.
//

import Foundation
import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class LoginViewController: UIViewController  {
    
    //MARK: - conponents
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var emailTextField : UITextField = {
        let field = UITextField()
        field.text = "test1@gmail.com"
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private var passwordTextField : UITextField = {
        let field = UITextField()
        field.text = "123455"
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        return field
    }()
    
    private var loginButton : UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private var fbLoginButton : FBLoginButton = {
        let button = FBLoginButton()
        button.permissions = ["email,public_profile"]
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let GoogleLoginButton = GIDSignInButton()
    
    private var loginObserver : NSObjectProtocol?
    
    //MARK: - viewDidload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginObserver = NotificationCenter.default.addObserver(forName: .didlogInNotification, object: nil, queue: .main, using: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })

        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        view.backgroundColor = .white
        title = "Log In"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Resgister", style: .done, target: self, action: #selector(didTapResgister))
        loginButton.addTarget(self, action: #selector(loginButtontapped), for: .touchUpInside)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        fbLoginButton.delegate = self
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(fbLoginButton)
        scrollView.addSubview(GoogleLoginButton)
    }
    
    deinit {
        if let observer = loginObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    //MARK: - viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width/3
        imageView.frame = CGRect(x: (scrollView.width-size)/2, y: 20, width: size, height: size)
        emailTextField.frame = CGRect(x: 30, y: imageView.bottom+10, width: scrollView.width-60, height: 52)
        passwordTextField.frame = CGRect(x: 30, y: emailTextField.bottom+10, width: scrollView.width-60, height: 52)
        loginButton.frame = CGRect(x: 30, y: passwordTextField.bottom+10, width: scrollView.width-60, height: 52)
        fbLoginButton.frame = CGRect(x: 30, y: loginButton.bottom+10, width: scrollView.width-60, height: 52)
        GoogleLoginButton.frame = CGRect(x: 30, y: fbLoginButton.bottom+10, width: scrollView.width-60, height: 52)
    }
    
    @objc private func loginButtontapped() {
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        guard let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            alertUserLoginError()
            return
        }
        
        //MARK: - Firebase Login
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
            guard let strongSelf = self else {
                return
            }
            guard authResult != nil, error == nil else {
                print("Faild to log in user \(email)")
                return
            }
            
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func alertUserLoginError() {
        let alert = UIAlertController(title: "Something Wrong", message: "Login Fail", preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func didTapResgister() {
        let vc = ResgisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            loginButtontapped()
        }
        return true
    }
}

//MARK: - facebook LoginButtonDelegate
extension LoginViewController: LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        // something
    }
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("fail to login with Facabook")
            return
        }
        
        let facebookReguest = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields" : "email, name"], tokenString: token, version: nil, httpMethod: .get)
        facebookReguest.start { (_, result, error) in
            guard let result = result as? [String: Any], error == nil else {
                print("fail to graph request")
                return
            }
            guard let userName = result["name"] as? String, let email = result["email"] as? String else {
                print("fail to get username and email")
                return
            }
            let nameComponent = userName.components(separatedBy: " ")
            guard nameComponent.count == 2 else {
                return
            }
            let firstName = nameComponent[0]
            let lastName = nameComponent[1]
            
            DatabaseManager.shared.userExist(with: email) { (exists) in
                if !exists {
                    DatabaseManager.shared.insertUser(with: ChapAppUser(firstName: firstName, lastName: lastName, emailAddress: email))
                }
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            FirebaseAuth.Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
                guard let strongSelf = self else {
                    return
                }
                guard authResult != nil, error == nil else {
                    print("Facebook credential login failed, MFA may be needed - \(String(describing: error))")
                    return
                }
                print("log in via Facabook successfull")
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
    }
}
