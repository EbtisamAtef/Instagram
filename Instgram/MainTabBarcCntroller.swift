//
//  MainTabBarcCntroller.swift
//  Instgram
//
//  Created by Ebtisam on 10/24/18.
//  Copyright © 2018 Ebtisam. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewLayout()
        let userprofile = UserProfileController(collectionViewLayout: layout)
        let navController = UINavigationController(rootViewController: userprofile )
        navController.tabBarItem.image = #imageLiteral(resourceName: "user")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "selecteuser")
        tabBar.tintColor = .black
        viewControllers = [navController, UIViewController()]
        featchuser()
    }
    
    
    func featchuser(){
        let ref = Database.database().reference()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        ref.child("users").child("uid").observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.value ?? "")
        }) { (err) in
            print("failed to feach user data : \(err)")
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
}
