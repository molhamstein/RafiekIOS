//
//  GendarViewController.swift
//  Al-Rafik
//
//  Created by Nour  on 5/18/19.
//  Copyright © 2019 Nour . All rights reserved.
//

import UIKit

class GendarViewController: AbstractController {

    var enablePress = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        VoiceManager.shared.speek(MessagesHelper.gendarViewInfoMessage)
    }
    
    @IBAction func setMale(_ sender: UILongPressGestureRecognizer) {
        if(sender.state == UIGestureRecognizer.State.ended){
            enablePress = true
        }else if(sender.state == UIGestureRecognizer.State.began){
            print("began")
            if enablePress{
                enablePress = false
                AppConfig.currentGendar = .male
                VoiceManager.shared.speek("Male")
                goToSearchView()
                
            }
            
        }
    }
    
    
    @IBAction func setFemale(_ sender: UILongPressGestureRecognizer) {
        if(sender.state == UIGestureRecognizer.State.ended){
            enablePress = true
        }else if(sender.state == UIGestureRecognizer.State.began){
            print("began")
            if enablePress{
                enablePress = false
                AppConfig.currentGendar = .female
                VoiceManager.shared.speek("Female")
                goToSearchView()
            }
            
        }
    }
    

    
    func goToSearchView(){
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
//        self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true, completion: nil)
    }
    

}
