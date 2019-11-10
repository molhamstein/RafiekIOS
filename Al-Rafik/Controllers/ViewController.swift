//
//  ViewController.swift
//  Al-Rafik
//
//  Created by Nour  on 4/3/19.
//  Copyright © 2019 Nour . All rights reserved.
//

import UIKit
import Zip
import SwiftyJSON
//import SwiftSVG
import SVGKit
import PocketSVG


class ViewController: AbstractController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var contolrViewWidthConstraint:NSLayoutConstraint!
    @IBOutlet weak var contentViewWidthConstraint:NSLayoutConstraint!
    
    var layers:[CAShapeLayer] = []
    var book:Book?
    var bookId:String?
    var counter = 0
    var controlCounter = 0
    var selectedLayer:SVGLayer?
    var controlSelectedLayer:SVGLayer?
    var closeEnablePress:Bool = true
    var enablePress:Bool = true
    var controlEnablePress:Bool = true
    var selectedPage:Page?
    var confirmClose = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showNavBackButton = true
        NavigationManager.delegate = self
        SpeechCommandsManager.shared.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getBook()
    }

    @IBAction func close(_ sender: UILongPressGestureRecognizer) {
        if(sender.state == UIGestureRecognizer.State.ended){
            closeEnablePress = true
        }else if(sender.state == UIGestureRecognizer.State.began){
            if closeEnablePress{
                closeEnablePress = false
                if confirmClose{
                    self.dismiss(animated: true, completion: nil)
                }else{
                    confirmClose = true
                    VoiceManager.shared.appendTextList(list: [MessagesHelper.closeMessage])
                    VoiceManager.shared.playList()
                }
            }
            
        }
    }
    
    func getBook(){
        if let bookName = book?.name_en{
            let path = FileHelper.document(filePath: bookName)
            if FileHelper.isExists(filePath: path){
                readBook(file: bookName)
                //                downloadBook(bookId: bookId ?? "")
            }else{
                downloadBook(bookId: bookId ?? "")
            }
        }else{
            downloadBook(bookId: bookId ?? "")
        }
    }
    
    func downloadBook(bookId:String){
        AlertsManager.loadingAlert(state: true)
        ApiManager.shared.downloadFile(file: bookId,fileName: book?.name_en ?? "Book") { (success, error, result) in
            AlertsManager.loadingAlert(state: false)
            if success{
                if let path = result{
                    //            let path = FileHelper.fil
                    if let path =  ArchiveHelper.unZip(filePath: URL(string:path)!){
                        self.readBook(file: path)
                    }
                }
            }
            if error != nil{
                AlertsManager.errorAlert()
                print(error?.errorName ?? "error downloadBook")
            }
        }
    }
    
    func readBook(file:String){
        AppBrain.shared.setBook(file)
        if let bookJson = FileHelper.readBookJSON(folder: file, file: "book.json"){
            self.book = Book(json:bookJson)
            if let page = book?.pages?.first{
                VoiceManager.shared.speek(Commands.setPage.description(val: page.name ?? ""))
                self.navigateTo(page: page)
            }
        }
    }
    
    func getPageBy(id:String) ->Page?{
        var res:Page? = nil
        for page in book?.pages ?? []{
            if page.pid == id{
                res = page
                break
            }
        }
        return res
    }
    
    func navigateTo(page:Page){
        selectedPage = page
        if let descritpion = selectedPage?.description{
            VoiceManager.shared.appendTextList(list: [ descritpion])
            VoiceManager.shared.playList()
        }
        self.contolrViewWidthConstraint.setNewConstant(200.0)
        UIView.animate(withDuration: 0.1, animations: {
            self.view.layoutSubviews()
        }, completion: nil)
        
        // controlr view
        if let control = page.control{
            if let content = control.content{
                let viewBox = SVGManager.shared.viewBox(with: content)
                let bounds = controlView.bounds
                let ratio = SVGManager.shared.getRatio(viewBox: viewBox, bounds: bounds)
                let width = viewBox.width * ratio
                self.contolrViewWidthConstraint.setNewConstant(width)
                UIView.animate(withDuration: 0.1, animations: {
                    self.view.layoutSubviews()
                }, completion: nil)
                
                let layers = SVGManager.shared.drawSVG(of: content, containerView: self.controlView)
                var svgLayers:[SVGLayer] = []
                for layer in layers{
                    if let id = layer.id{
                        layer.layerActions =  control.shapes[id] ?? []
                        svgLayers.append(layer)
                    }
                }
                self.controlView.layer.sublayers = svgLayers
            }
        }else if let control = self.book?.control{
            if let content = control.content{
                let viewBox = SVGManager.shared.viewBox(with: content)
                let bounds = controlView.bounds
                let ratio = SVGManager.shared.getRatio(viewBox: viewBox, bounds: bounds)
                let width = viewBox.width * ratio
                self.contolrViewWidthConstraint.setNewConstant(width)
                UIView.animate(withDuration: 0.1, animations: {
                    self.view.layoutSubviews()
                }, completion: nil)
                let layers = SVGManager.shared.drawSVG(of: content, containerView: self.controlView)
                var svgLayers:[SVGLayer] = []
                for layer in layers{
                    if let id = layer.id{
                        layer.layerActions =  control.shapes[id] ?? []
                        svgLayers.append(layer)
                    }
                }
                self.controlView.layer.sublayers = svgLayers
            }
        }

        // content view
        let content = page.content
        let layers = SVGManager.shared.drawSVG(of: content!, containerView: self.contentView)
        var svgLayers:[SVGLayer] = []
        for layer in layers{
            if let id = layer.id{
                layer.layerActions =  page.shapes[id] ?? []
                svgLayers.append(layer)
            }
        }
        self.contentView.layer.sublayers = svgLayers
    }
    
    func getNextPage()-> Page?{
        if let index = book?.pages?.firstIndex(where: {$0.pid == selectedPage?.pid}){
            if let cnt =  book?.pages?.count , index < cnt - 1{
                if let page = book?.pages?[index + 1 ]{
                    return page
                }
            }
        }
        return nil
    }
    
    func getPrevPage()->Page?{
        if let index = book?.pages?.firstIndex(where: {$0.pid == selectedPage?.pid}){
            if index > 0 {
                if let page = book?.pages?[index - 1]{
                    return page
                }
            }
        }
        return nil
    }
    
    func getPageByDirction(dirction:String)->Page?{
        if let id = selectedPage?.direction?[dirction].string{
            if let page = getPageBy(id: id){
                return page
            }
        }
        return nil
    }
    
    @IBAction func lognPress(_ sender: UILongPressGestureRecognizer) {
        if(sender.state == UIGestureRecognizer.State.ended){
            enablePress = true
        }else if(sender.state == UIGestureRecognizer.State.began){
            print("began")
            if enablePress{
                enablePress = false
                let point = sender.location(in: contentView)
                guard let sublayers = contentView.layer.sublayers as? [SVGLayer] else {return}
                for layer in sublayers {
                    if let path = layer.path , path.contains(point) {
                        selectedLayer = layer
                        if let action = selectedLayer?.currentAction(){
                            performAction(action:action)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func controlLognPress(_ sender: UILongPressGestureRecognizer) {
        if(sender.state == UIGestureRecognizer.State.ended){
            controlEnablePress = true
        }else if(sender.state == UIGestureRecognizer.State.began){
            print("Control began")
            if controlEnablePress{
                controlEnablePress = false
                let point = sender.location(in: controlView)
                guard let sublayers = controlView.layer.sublayers as? [SVGLayer] else {return}
                for layer in sublayers {
                    if let path = layer.path , path.contains(point) {
                        controlSelectedLayer = layer
                        if let action = controlSelectedLayer?.currentAction(){
                            performAction(action: action)
                        }
                        self.view.backgroundColor = UIColor(cgColor:layer.fillColor!)
                    }
                }
            }
        }
    }
    
    func performAction(action:Action,value:String? = nil){
        if let type = action.type {
            if let operation = AppBrain.shared.operations[type]{
                switch operation {
                case .navigate(_):
                    VoiceManager.shared.appendTextList(list: [""])
                    if let page = getPageBy(id: value ?? action.value ?? ""){
                        VoiceManager.shared.appendTextList(list: [ Commands.navigation.description(val: page.name ?? "")])
                        VoiceManager.shared.playList()
                        AppBrain.shared.setPage(page)
                    }
                    break
                    
                case .command:
                    // Comand
                    if let val = value ?? action.value , let op = Commands(rawValue: val){
                        switch (op){
                        case .up , .down , .left , .right:
                            if let page = getPageByDirction(dirction: op.rawValue){
                                VoiceManager.shared.appendTextList(list: [ Commands.navigation.description(val: page.name ?? "")])
                                VoiceManager.shared.playList()
                                AppBrain.shared.setPage(page)
                            }
                            break;
                        case .next:
                            VoiceManager.shared.appendTextList(list: [ op.description()])
                            if let page = getNextPage() {
                                VoiceManager.shared.appendTextList(list: [ Commands.navigation.description(val: page.name ?? "")])
                                VoiceManager.shared.playList()
                                AppBrain.shared.setPage(page)
                            }
                            break;
                        case .previous:
                            VoiceManager.shared.appendTextList(list: [ op.description()])
                            if let page = getPrevPage(){
                                VoiceManager.shared.appendTextList(list: [ Commands.navigation.description(val: page.name ?? "")])
                                VoiceManager.shared.playList()
                                AppBrain.shared.setPage(page)
                            }
                            break;
                        default:
                            break
                        }
                    }// End Command
                    break
                default:
                    break
                }
            }
            AppBrain.shared.setValue(value ?? action.value ?? "")
            AppBrain.shared.performOperation(type)
        }
    }
}

// navigation
extension ViewController:NavigationManagerDelegate{
    func changePage(id: String) {
        if let page = getPageBy(id: id){
            navigateTo(page: page)
        }
    }
    
    func goTo(dirction: String) {
        if let page = getPageByDirction(dirction: dirction){
            navigateTo(page: page)
        }
    }
    func nextPage() {
        
        if let page = getNextPage(){
            navigateTo(page: page)
        }else{
            VoiceManager.shared.removeLast()
            AlertsManager.errorAlert()
        }
    }
    
    func prevPage() {
        if let page = getPrevPage(){
            navigateTo(page: page)
        }else{
            VoiceManager.shared.removeLast()
            AlertsManager.errorAlert()
        }
    }
    
    func goToPage(num: Int) {
        if let cnt = book?.pages?.count , num <= cnt,num > 0{
            if let page = book?.pages?[num - 1] {
                navigateTo(page: page)
            }
        }else{
            AlertsManager.errorAlert()
        }
    }
    
    func playMenuActions() {
        guard let menu = selectedPage?.menu else {return}
        var textList:[String] = []
        var i = 1
        for action in menu{
            if let val = action.type , let op = Commands(rawValue: val){
                switch op{
                case .audio:
                    let text = Commands(rawValue: action.type ?? "")
                    textList.append("\(i)  \(text?.description() ?? "")")
                    break
                case .text:
                    let text = Commands(rawValue: action.type ?? "")
                    textList.append("\(i)  \(text?.description() ?? "")")
                    break
                case .command:
                    let text = Commands(rawValue: action.type ?? "")
                    textList.append("\(i)  \(text?.description() ?? "")")
                    break
                case .navigation:
                    if let id = action.value{
                        if let page = getPageBy(id: id){
                            textList.append("\(i)  \(Commands.navigateMenu.description(val: page.name ?? "") )")
                        }
                    }
                    break
                case .down:
                    if let text = Commands(rawValue: action.type ?? ""){
                        if let page = getPageByDirction(dirction:text.rawValue){
                            textList.append("\(i)  \(text.description() ) \(page.name ?? "")")
                        }
                    }
                case .up:
                    if let text = Commands(rawValue: action.type ?? ""){
                        if let page = getPageByDirction(dirction:text.rawValue){
                            textList.append("\(i)  \(text.description() ) \(page.name ?? "")")
                        }
                    }
                case .next:
                    if let text = Commands(rawValue: action.type ?? ""){
                        if let page = getNextPage(){
                            textList.append("\(i)  \(text.description() ) \(page.name ?? "")")
                        }
                    }
                case .left:
                    if let text = Commands(rawValue: action.type ?? ""){
                        if let page = getPageByDirction(dirction:text.rawValue){
                            textList.append("\(i)  \(text.description() ) \(page.name ?? "")")
                        }
                    }
                case .previous:
                    if let text = Commands(rawValue: action.type ?? ""){
                        if let page = getPrevPage(){
                            textList.append("\(i)  \(text.description() ) \(page.name ?? "")")
                        }
                    }
                default :
                    break
                }
            }
            i += 1
        }
        VoiceManager.shared.appendTextList(list:textList)
    }
    
    func trigerMenuAction(num: Int) {
        guard let menu = selectedPage?.menu else {return}
        if num <= menu.count , num > 0{
            let action = menu[num - 1]
            if let type = action.type{
                if let val = action.value{
                    AppBrain.shared.setValue(val)
                    AppBrain.shared.performOperation(type)
                }
            }
        }else{
            AlertsManager.errorAlert()
        }
    }
}


extension ViewController: SpeechCommandDelegate{
    func commandDidFetched(command: VoiceCommand) {
        switch command.commandType {
        case .command:
            if let value = command.value {
                let action = Action()
                action.type = "command"
                performAction(action: action,value: value)
            }
            break
        case .changeLanguage:
            if let value = command.value , let language = AppLanguage.init(rawValue: value) {
                AppConfig.currentLanguage = language
                VoiceManager.shared.speek(language.languageName)
            }
            break
        case .selectCommand:
            if let value = command.value {
                let action = Action()
                action.type = "command"
                performAction(action: action,value: value)
                action.type = "command"
                performAction(action: action,value: "enter")
            }
        case .selectPage:
            if let value = command.value {
                let action = Action()
                action.type = "command"
                performAction(action: action,value: value)
                action.type = "command"
                performAction(action: action,value: "confirm")
            }
        default:
            VoiceManager.shared.speek("Invalid Voice Command")
        }
    }
    
    @IBAction func listen(_ sender: UILongPressGestureRecognizer) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(startListen), object: nil)
        self.perform(#selector(startListen), with: nil, afterDelay: 0.5)
    }
    
    @objc func startListen(){
        SpeechCommandsManager.shared.open()
    }
}
