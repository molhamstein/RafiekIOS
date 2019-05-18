//
//  GendarViewController.swift
//  Al-Rafik
//
//  Created by Nour  on 5/18/19.
//  Copyright © 2019 Nour . All rights reserved.
//

import UIKit

class GendarViewController: AbstractController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        VoiceManager.shared.speek(MessagesHelper.gendarViewInfoMessage)
    }
    

    @IBAction func setMale(_ sendar:UIButton){
        AppConfig.currentGendar = .male
        VoiceManager.shared.speek("Male")
        goToSearchView()
    }
    
    @IBAction func setFemale(_ sendar:UIButton){
        AppConfig.currentGendar = .female
        VoiceManager.shared.speek("Female")
        goToSearchView()
    }
    
    func goToSearchView(){
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
