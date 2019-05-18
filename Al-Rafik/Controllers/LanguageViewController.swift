//
//  LanguageViewController.swift
//  Al-Rafik
//
//  Created by Nour  on 5/18/19.
//  Copyright © 2019 Nour . All rights reserved.
//

import UIKit

class LanguageViewController: AbstractController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        VoiceManager.shared.speek(MessagesHelper.languageViewInfoMessage)
    }
    

    @IBAction func setArabic(_ sendar:UIButton){
        AppConfig.currentLanguage = .arabic
        VoiceManager.shared.speek("العربية")
        goToGendarView()
    }

    @IBAction func setEnglish(_ sendar:UIButton){
        AppConfig.currentLanguage = .english
        VoiceManager.shared.speek("English")
        goToGendarView()
    }
    
    func goToGendarView(){
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "GendarViewController") as! GendarViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
