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
    
    var numbers:[String] = []
    
    var enablePress = true
    var confirmClose = false
    var closeEnablePress:Bool = true
    var backspaceEnablePress:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialize()
    }
    func initialize(){
        VoiceManager.shared.appendTextList(list: [MessagesHelper.searchViewInfoMessage])
        VoiceManager.shared.playList()
        self.number = nil
        self.numbers = []
        isTyping = false
        chooseBookMode = false
    }
    
    
    @IBAction func backSpace(_ sender: UILongPressGestureRecognizer) {
        if(sender.state == UIGestureRecognizer.State.ended){
            backspaceEnablePress = true
        }else if(sender.state == UIGestureRecognizer.State.began){
            print("began")
            if backspaceEnablePress{
                backspaceEnablePress = false
                VoiceManager.shared.appendTextList(list:[MessagesHelper.backSpaceMessage])
                VoiceManager.shared.playList()
                number?.removeLast()
                numbers.removeLast()
            }
        }
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
                    AlertsManager.errorAlert()
                    VoiceManager.shared.appendTextList(list: [MessagesHelper.searchResultViewErrorMessage])
                    self.initialize()
                }
            }
            
            if error != nil{
                    AlertsManager.errorAlert()
                    VoiceManager.shared.appendTextList(list: [MessagesHelper.searchResultViewErrorMessage])
                    self.initialize()
            }
        }
        
    }
    
    func chooseBook(){
        VoiceManager.shared.appendTextList(list: [MessagesHelper.searchResultViewInfoMessage])
        readBooksDescription()
//        perform(#selector(readBooksDescription), with: nil, afterDelay: 2.8)
    }
    
    @objc func readBooksDescription(){
        var textList:[String] = []
        var i = 1;
        for book in books {
            textList.append("\(i) \(book.description ?? "")")
            i += 1
        }
//        let textList = self.books.map({ $0.description ?? ""})
        VoiceManager.shared.appendTextList(list:textList)
        VoiceManager.shared.playList()
    }
    
    func goToBookPage(){
        if let num = number , let index = Int(num){
            
            if (index - 1) < books.count {
                let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                vc.book = self.books[index - 1]
                vc.bookId = self.books[index - 1].bId
//                self.navigationController?.pushViewController(vc, animated: true)
                self.present(vc, animated: true, completion: nil)
                
            }else{
                AlertsManager.warningAlert()
                 VoiceManager.shared.speek(MessagesHelper.searchResultViewErrorMessage)
            }
        }
        
    }
    @IBAction func setNumber(_ sender: UILongPressGestureRecognizer) {
        confirmClose = false
        
        if(sender.state == UIGestureRecognizer.State.ended){
            enablePress = true
        }else if(sender.state == UIGestureRecognizer.State.began){
            print("began")
            if enablePress{
                enablePress = false
        if let tag = sender.view?.tag  {
             let title = String(tag)
           
            if tag == -1{
                if isTyping {
                    VoiceManager.shared.speek(numbers.joined(separator: " "))
                        if self.chooseBookMode {
                            self.goToBookPage()
                        }else{
                            self.getBooks()
                        }
                        
                        self.isTyping = false
                        self.number = nil
                        self.numbers = []
                    
                }else{
                    AlertsManager.errorAlert()
                    VoiceManager.shared.speek(MessagesHelper.wrongChooseErrorMessage)
                }
            }else{
                VoiceManager.shared.speek(title)
                if isTyping{
                    if number != nil{
                        number = number! + title
                        numbers.append(title)
                    }
                }else{
                    number = title
                    numbers = [title]
                    isTyping = true
                }
            }
                }
                
            }
            
        }
        
    }
    
    
    @IBAction func close(_ sender: UILongPressGestureRecognizer) {
        if(sender.state == UIGestureRecognizer.State.ended){
            closeEnablePress = true
        }else if(sender.state == UIGestureRecognizer.State.began){
            if closeEnablePress{
                closeEnablePress = false
                if confirmClose{
                    //                self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                }else{
                    confirmClose = true
                    VoiceManager.shared.appendTextList(list: [MessagesHelper.closeMessage])
                    VoiceManager.shared.playList()
                }
            }
            
        }
    }
    
  
}
