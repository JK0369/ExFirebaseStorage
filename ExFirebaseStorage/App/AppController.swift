//
//  AppController.swift
//  ExFirebaseStorage
//
//  Created by 김종권 on 2021/11/19.
//

import Foundation
import UIKit
import Firebase

final class AppController {
    static let shared = AppController()
    private init() {
        FirebaseApp.configure()
        registerAuthStateDidChangeEvent()
    }
    
    private var window: UIWindow!
    private var rootViewController: UIViewController? {
        didSet {
            window.rootViewController = rootViewController
        }
    }
    
    func show(in window: UIWindow) {
        self.window = window
        window.backgroundColor = .systemBackground
        window.makeKeyAndVisible()
        
        if Auth.auth().currentUser == nil {
            checkLogin()
        }
    }
    
    private func registerAuthStateDidChangeEvent() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkLogin),
                                               name: .AuthStateDidChange,
                                               object: nil)
    }
        
    @objc private func checkLogin() {
        if let currentUser = Auth.auth().currentUser {
            print("currentUser = \(currentUser)")
            setHome()
        } else {
            routeToLogin()
        }
    }
    
    private func setHome() {
        let homeVC = HomeVC()
        rootViewController = UINavigationController(rootViewController: homeVC)
    }

    private func routeToLogin() {
        rootViewController = UINavigationController(rootViewController: LoginVC())
    }
    
}
