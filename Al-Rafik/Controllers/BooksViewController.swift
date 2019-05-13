//
//  BooksViewController.swift
//  Al-Rafik
//
//  Created by Nour  on 4/14/19.
//  Copyright © 2019 Nour . All rights reserved.
//

import UIKit

class BooksViewController: AbstractController,UITableViewDelegate,UITableViewDataSource {

    
    var books:[Book] = []
    @IBOutlet weak var tableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getBooks()
        tableView.delegate = self
        tableView.dataSource = self
//        let url = FileHelper.filePathMainBundel(file: "test", ext: "mp3")
//        VoiceManager.play(audioURL: url!)
      
    }
    
    func getBooks(){
        AlertsManager.loadingAlert(state: true)
        ApiManager.shared.getBooks { (success, error, result) in
            AlertsManager.loadingAlert(state: false)
            if success{
                self.books = result
                self.tableView.reloadData()
            }
            if error != nil{
                AlertsManager.errorAlert()
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = books[indexPath.row].name_en
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //VoiceManager.shared.speek(msg: books[indexPath.row].description_en ?? ""){
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            vc.book = self.books[indexPath.row]
            vc.bookId = self.books[indexPath.row].bId
            self.navigationController?.pushViewController(vc, animated: true)
       // }
        
    }

}
