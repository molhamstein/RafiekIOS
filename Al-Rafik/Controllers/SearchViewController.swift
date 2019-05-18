//
//  SearchViewController.swift
//  Al-Rafik
//
//  Created by Nour  on 5/18/19.
//  Copyright © 2019 Nour . All rights reserved.
//

import UIKit

class SearchViewController: AbstractController {

    var number:String?
    var isTyping = false
    var chooseBookMode = false
    var books:[Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    func initialize(){
        VoiceManager.shared.speek(MessagesHelper.searchViewInfoMessage)
        number = nil
        isTyping = false
    }
    
    
    func getBooks(){
        guard let code = number else {return}
        AlertsManager.loadingAlert(state: true)
        ApiManager.shared.getBooksBy(code: code) { (success, error, result) in
            AlertsManager.loadingAlert(state: false)
            if success{
                if result.count > 0{
                    self.books = result
                    self.chooseBookMode = true
                    self.chooseBook()
                }else{
                    AlertsManager.warningAlert()
                    self.initialize()
                }
            }
            
            if error != nil{
                AlertsManager.errorAlert()
                self.initialize()
            }
        }
        
    }
    
    func chooseBook(){
        VoiceManager.shared.speek(MessagesHelper.searchResultViewInfoMessage)
        
        perform(#selector(readBooksDescription), with: nil, afterDelay: 0.7)
    }
    
    @objc func readBooksDescription(){
        VoiceManager.shared.textList = self.books.map({$0.description ?? ""})
        VoiceManager.shared.speakTextList()
    }
    
    func goToBookPage(){
        if let num = number , let index = Int(num){
            
            if (index - 1) < books.count {
                let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                vc.book = self.books[index - 1]
                vc.bookId = self.books[index - 1].bId
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                AlertsManager.warningAlert()
            }
        }
        
    }

    @IBAction func setNumber(_ sender: UIButton) {
        if let title = sender.currentTitle{
            VoiceManager.shared.speek(title)
            if title == "Enter"{
                if isTyping {
                    VoiceManager.shared.speek(number ?? "None"){_ in
                        if self.chooseBookMode {
                            self.goToBookPage()
                        }else{
                            self.getBooks()
                        }
                        
                        self.isTyping = false
                        self.number = nil
                    }
                }
            }else{
                if isTyping{
                    if number != nil{
                        number = number! + title
                    }
                }else{
                    number = title
                    isTyping = true
                }
            }
        }
    }
}
