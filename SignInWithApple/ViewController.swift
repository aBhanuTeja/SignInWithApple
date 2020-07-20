//
//  ViewController.swift
//  SignInWithApple
//
//  Created by Bhanuteja on 14/03/20.
//  Copyright © 2020 annam. All rights reserved.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = ASAuthorizationAppleIDButton()
        button.addTarget(self, action: #selector(signInWithAppleButtonPressed), for: .touchUpInside)
        stackView.addArrangedSubview(button)
    }

    @objc func signInWithAppleButtonPressed(){
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email, .fullName]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

extension ViewController: ASAuthorizationControllerDelegate{
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        print(credential)
        let id               = credential.user
        let email            = credential.email ?? ""
        let lastName         = credential.fullName?.familyName ?? ""
        let firstName        = credential.fullName?.givenName ?? ""
        let name             = firstName + lastName
        let appleId          = credential.identityToken?.base64EncodedString() ?? ""
        let totalCredentials = "ID:\(id),\n Email:\(email),\n Name:\(name),\n IdentityToken:\(appleId)"
        print(totalCredentials)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
}

extension ViewController: ASAuthorizationControllerPresentationContextProviding{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
