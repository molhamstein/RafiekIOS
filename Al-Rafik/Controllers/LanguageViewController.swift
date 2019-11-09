//
//  LanguageViewController.swift
//  Al-Rafik
//
//  Created by Nour  on 5/18/19.
//  Copyright © 2019 Nour . All rights reserved.
//

import UIKit

class LanguageViewController: AbstractController {

    var enablePress = true
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        VoiceManager.shared.speek(MessagesHelper.languageViewInfoMessage)
    }
    

    
    @IBAction func setArabic(_ sender: UILongPressGestureRecognizer) {
        if(sender.state == UIGestureRecognizer.State.ended){
            enablePress = true
        }else if(sender.state == UIGestureRecognizer.State.began){
            print("began")
            if enablePress{
                enablePress = false
                AppConfig.currentLanguage = .arabic
                VoiceManager.shared.speek("العربية")
                goToGendarView()
                
            }
            
        }
    }
    
    @IBAction func setEnglish(_ sender: UILongPressGestureRecognizer) {
        if(sender.state == UIGestureRecognizer.State.ended){
            enablePress = true
        }else if(sender.state == UIGestureRecognizer.State.began){
            print("began")
            if enablePress{
                enablePress = false
                AppConfig.currentLanguage = .english
                VoiceManager.shared.speek("English")
                goToGendarView()
                
            }
            
        }
    }
    

    
    func goToGendarView(){
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "GendarViewController") as! GendarViewController
        self.present(vc, animated: true, completion: nil)
    }
}
