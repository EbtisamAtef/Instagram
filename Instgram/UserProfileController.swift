//
//  UserProfileController.swift
//  Instgram
//
//  Created by Ebtisam on 10/24/18.
//  Copyright © 2018 Ebtisam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    override func viewDidLoad() {
    super.viewDidLoad()
        
        collectionView?.backgroundColor = #colorLiteral(red: 0.76056941, green: 0.7659923732, blue: 0.7822612627, alpha: 1)
        
        featchuser()
        
        //collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
    }
    
    
     override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath)
        header.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        print("in first collectionview func")
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        print("in second collectionview func")
        return CGSize(width: view.frame.width, height: 200)
    }
    
    
  func featchuser(){
    
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let user = Auth.auth().currentUser
        
        ref.child("users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot ) in
            print((user?.uid)!)
            let dictionary = snapshot.value as? [String: Any]
            let username = dictionary?["username"] as? String
            self.navigationItem.title = username!
            
        }) { (err) in
            print("failed to feach user data : \(err)")
        }
        
    }
    
    
   
}
    

