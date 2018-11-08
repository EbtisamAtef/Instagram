//
//  MainTabBarcCntroller.swift
//  Instgram
//
//  Created by Ebtisam on 10/24/18.
//  Copyright © 2018 Ebtisam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth


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
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
