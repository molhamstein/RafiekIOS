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
    
    
    var appBrain = AppBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showNavBackButton = true
        NavigationManager.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getBook()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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

    
    func getBook(){
        if let bookName = book?.name_en{
            let path = FileHelper.document(filePath: bookName)
            if FileHelper.isExists(filePath: path){
                readBook(file: bookName)
                //downloadBook(bookId: bookId ?? "")
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
        appBrain.setBook(file)
        if let bookJson = FileHelper.readBookJSON(folder: file, file: "book.json"){
        self.book = Book(json:bookJson)
            if let page = book?.pages?.first{
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
            VoiceManager.shared.appendTextList(list: [descritpion])
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
                            if let type = action.type{
                                appBrain.setValue(action.value ?? "")
                                appBrain.performOperation(type)
                            }
                        }
                        self.view.backgroundColor = UIColor(cgColor:layer.fillColor!)
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
                            if let type = action.type{
                                appBrain.setValue(action.value ?? "")
                                appBrain.performOperation(type)
                            }
                        }
                        self.view.backgroundColor = UIColor(cgColor:layer.fillColor!)
                        
                    }
                }
                
            }
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
        if let id = selectedPage?.direction?[dirction].string{
            if let page = getPageBy(id: id){
                navigateTo(page: page)
            }
        }
    }
    
    func nextPage() {
        if let index = book?.pages?.firstIndex(where: {$0.pid == selectedPage?.pid}){
            if let cnt =  book?.pages?.count , index < cnt - 1{
                if let page = book?.pages?[index + 1 ]{
                    navigateTo(page: page)
                }else{
                    VoiceManager.shared.removeLast()
                    AlertsManager.errorAlert()
                }
            }else{
                VoiceManager.shared.removeLast()
                AlertsManager.errorAlert()
            }
        }
    }
    
    func prevPage() {
        if let index = book?.pages?.firstIndex(where: {$0.pid == selectedPage?.pid}){
            if index > 0 {
                if let page = book?.pages?[index - 1]{
                    navigateTo(page: page)
                }else{
                    VoiceManager.shared.removeLast()
                    AlertsManager.errorAlert()
                }
            }else{
                VoiceManager.shared.removeLast()
                AlertsManager.errorAlert()
            }
        }
    }
    
    func goToPage(num: Int) {
        if let cnt = book?.pages?.count , num <= cnt,num > 0{
            if let page = book?.pages?[num - 1]{
                navigateTo(page: page)
            }
        }else{
            AlertsManager.errorAlert()
        }
    }
    
    func playMenuActions() {
        guard let menu = selectedPage?.menu else {return}
        let actions = menu.map{$0.type ?? ""}
        var textList:[String] = []
        var i = 1
        for action in  (actions.map{Commands(rawValue: $0)}.map{$0?.description ?? ($0?.rawValue)!}) {
            textList.append("\(i)  \(action)")
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
                    self.appBrain.setValue(val)
                    self.appBrain.performOperation(type)
                    
                }
            }
        }else{
            AlertsManager.errorAlert()
        }
    }
}
