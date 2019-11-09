//
//  NavigationManager.swift
//  Al-Rafik
//
//  Created by Nour  on 4/21/19.
//  Copyright © 2019 Nour . All rights reserved.
//

import Foundation
protocol NavigationManagerDelegate {
    func changePage(id:String)
    func goTo(dirction:String)
    func goToPage(num:Int)
    func nextPage()
    func prevPage()
    func playMenuActions()
    func trigerMenuAction(num:Int)
}

class NavigationManager{
    
    static var delegate:NavigationManagerDelegate?
    
    static func navigateToPage(id:String){
        delegate?.changePage(id: id)
    }
    
    static func goToDirection(dir:String){
        delegate?.goTo(dirction: dir)
    }
    
    static func goToPage(num:Int){
        delegate?.goToPage(num: num)
    }
    
    static func next(){
        delegate?.nextPage()
    }

    static func prev(){
        delegate?.prevPage()
    }
    
    static func playMenuActions(){
        delegate?.playMenuActions()
    }
    
    static func trigerMenuAction(num:Int){
        delegate?.trigerMenuAction(num: num)
    }
    

    
    
    static func openUrl(url:String){
        guard let strUrl = URL(string: url) else {
            return //be safe
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(strUrl, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(strUrl)
        }
    }
    
    
    
    
}
