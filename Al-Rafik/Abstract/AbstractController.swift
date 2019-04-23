//
//  AbstractController.swift
//  BrainSocket Code base
//
//  Created by Molham Mahmoud on 19/10/16.
//  Copyright © 2016 BrainSocket. All rights reserved.
//

import UIKit
import Toast_Swift


// MARK: Alert message types
enum MessageType{
    case success
    case error
    case warning
    
    var toastIcon: String {
        switch self {
        case .success:
            return "successIcon"
        case .error:
            return "errorIcon"
        case .warning:
            return "warningIcon"
        }
    }
    
    var toastTitle: String {
        switch self {
        case .success:
            return "GLOBAL_SUCCESS_TITLE"
        case .error:
            return "GLOBAL_ERROR_TITLE"
        case .warning:
            return "GLOBAL_WARNING_TITLE"
        }
    }
}

enum titleImageView: String{
    case logoAndText = "navLogo"
    case logoIcon = "navLogoIcon"
    case filter = "navFilter"
}

class AbstractController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    /// Instaniate view controller from main story board
    ///
    /// **Warning:** Make sure to set storyboard id the same as the controller name
    class func control() -> AbstractController {
        return UIStoryboard(name: "Start", bundle: nil).instantiateViewController(withIdentifier: String(describing: self)) as! AbstractController
    }
    
    public static var className:String {
        return String(describing: self.self)
    }
    
    // MARK: Navigation Bar
    func setNavBarTitle(title : String) {
        
        self.navigationItem.titleView = nil
        self.navigationItem.title = title
        
    }
    
    func setNavBarTitleImage(type:titleImageView) {
        // add app logo to navigation title
        let image = UIImage(named: type.rawValue)
        let imageView = UIImageView(image:image)
        self.navigationItem.titleView = imageView
    }
    
    /// Navigation bar custome back button
    var navBackButton : UIBarButtonItem  {
        let _navBackButton   = UIButton()
//        _navBackButton.dropShadow()
        _navBackButton.setBackgroundImage(UIImage(named: "ic_back_white"), for: .normal)
        _navBackButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        _navBackButton.addTarget(self, action: #selector(backButtonAction(_:)), for: .touchUpInside)
        return UIBarButtonItem(customView: _navBackButton)
    }
    
    var navBlackBackButton : UIBarButtonItem  {
        let _navBackButton   = UIButton()
//        _navBackButton.dropShadow()
        _navBackButton.setBackgroundImage(UIImage(named: "navBack"), for: .normal)
        _navBackButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        _navBackButton.addTarget(self, action: #selector(backButtonAction(_:)), for: .touchUpInside)
        return UIBarButtonItem(customView: _navBackButton)
    }
    
    /// Navigation bar custome close button
    var navCloseButton : UIBarButtonItem {
        let _navCloseButton = UIButton()
        _navCloseButton.setBackgroundImage(UIImage(named: "navClose"), for: .normal)
        _navCloseButton.frame = CGRect(x: 0, y: 0, width: 17, height: 17)
        _navCloseButton.addTarget(self, action: #selector(closeButtonAction(_:)), for: .touchUpInside)
        return UIBarButtonItem(customView: _navCloseButton)
    }
    
    /// Navigation bar profile button
    var navProfileButton : UIBarButtonItem {
        let _navProfileButton = UIButton()
        _navProfileButton.setBackgroundImage(UIImage(named: "navProfile"), for: .normal)
        _navProfileButton.frame = CGRect(x: 0, y: 0, width: 33, height: 26)
       // _navProfileButton.addTarget(self, action: #selector(profileButtonAction(_:)), for: .touchUpInside)
        return UIBarButtonItem(customView: _navProfileButton)
    }
    
    
    /// Navigation bar profile button
    var navEditButton : UIBarButtonItem {
        let _navProfileButton = UIButton()
        _navProfileButton.setBackgroundImage(UIImage(named: "ic_edit"), for: .normal)
        _navProfileButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
         _navProfileButton.addTarget(self, action: #selector(editButtonAction(_:)), for: .touchUpInside)
        return UIBarButtonItem(customView: _navProfileButton)
    }
    
    /// Enable back button on left side of navigation bar
    var showNavBackButton: Bool = false {
        didSet {
            if (showNavBackButton) {
                self.navigationItem.leftBarButtonItem = navBackButton
            } else {
                self.navigationItem.leftBarButtonItem = nil
                self.navigationItem.leftBarButtonItems = nil
            }
        }
    }
    
    var showNavBlackBackButton: Bool = false {
        didSet {
            if (showNavBlackBackButton) {
                self.navigationItem.leftBarButtonItem = navBlackBackButton
            } else {
                self.navigationItem.leftBarButtonItem = nil
                self.navigationItem.leftBarButtonItems = nil
            }
        }
    }
    
    /// Enable close button on left side of navigation bar
    var showNavCloseButton: Bool = false {
        didSet {
            if (showNavCloseButton) {
                self.navigationItem.leftBarButtonItem = navCloseButton
            } else {
                self.navigationItem.leftBarButtonItem = nil
                self.navigationItem.leftBarButtonItems = nil
            }
        }
    }
    
    /// Enable profile button
    var showNavProfileButton: Bool = false {
        didSet {
            if (showNavProfileButton) {
                self.navigationItem.rightBarButtonItem = navProfileButton
            } else {
                self.navigationItem.rightBarButtonItem = nil
                self.navigationItem.rightBarButtonItems = nil
            }
        }
    }
    
    
    /// Enable edit button
    var showNavEditButton: Bool = false {
        didSet {
            if (showNavEditButton) {
                self.navigationItem.rightBarButtonItem = navEditButton
            } else {
                self.navigationItem.rightBarButtonItem = nil
                self.navigationItem.rightBarButtonItems = nil
            }
        }
    }
    
    // MARK: Status Bar
    func setStatuesBarDark() {
        UIApplication.shared.statusBarStyle = .default
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // enable swipe left back guesture
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        // hide keyboard when tapping on non input control
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        // hide default back button
        self.navigationItem.hidesBackButton = true
        self.navigationItem.backBarButtonItem = nil
        // add navigation title logo
        //self.setNavBarTitleImage(type: .logoAndText)
        // customize view
        self.customizeView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // build up view
//         self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64)
        self.buildUp()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    // Customize all view members (fonts - style - text)
    func customizeView() {
    }
    
    // Build up view elements
    func buildUp() {
    }
    
    @objc func editButtonAction(_ sender:AnyObject){
    }
    
    @objc func backButtonAction(_ sender: AnyObject) {
        
    }
    
    @objc func closeButtonAction(_ sender: AnyObject) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
//
//    func profileButtonAction( _ sender:AnyObject) {
//        ActionShowProfile.execute()
//    }
    
    // MARK: Show toast message
    /// Show toast message with key and type
    func showMessage(message: String, type: MessageType) {
        // toast view measurments
        let toastOffset = CGFloat(48)
        let toastHeight = CGFloat(104)
        let imageOffset = CGFloat(16)
        let imageHeight = CGFloat(32)
        // toast view frames
        let toastFrame = CGRect.init(x: toastOffset, y: (self.view.frame.size.height - toastHeight) / 2, width:self.view.frame.size.width - 2 * toastOffset, height:toastHeight)
        let imageFrame = CGRect.init(x: (toastFrame.size.width - imageHeight) / 2, y: imageOffset, width: imageHeight, height: imageHeight)
        let labelFrame = CGRect.init(x: imageOffset, y: imageHeight + imageOffset, width: toastFrame.size.width - 2 * imageOffset, height: toastHeight - imageOffset - imageHeight)
        // toast view
        let toastView = UIView.init(frame: toastFrame)
        toastView.backgroundColor = UIColor.init(white: 0.35, alpha: 1.0)
//        toastView.cornerRadius = 8.0
        // toast image
        let toastImage = UIImageView.init(frame: imageFrame)
        toastImage.image = UIImage(named: type.toastIcon)
        toastView.addSubview(toastImage)
        // toast label
        let toastLabel = UILabel.init(frame: labelFrame)
        toastLabel.text = message
        toastLabel.textAlignment = .center
        toastLabel.font = AppFonts.smallBold
        toastLabel.textColor = UIColor.white
        toastLabel.numberOfLines = 2
        toastView.addSubview(toastLabel)
        // present the toast with custom view
        self.view.showToast(toastView, duration: 2.0, position: .center, completion: nil)
    }
    
    /// Show/Hide activity loader
    func showActivityLoader(_ show: Bool) {
        if (show) {
            // create a new style
            var style = ToastStyle()
            style.backgroundColor = UIColor.init(white: 0.35, alpha: 0.8)
            style.activitySize = CGSize.init(width: 80, height: 80)
            ToastManager.shared.style = style
            // present the toast with the new style
            self.view.makeToastActivity(.center)
            // disable user interaction
            self.view.isUserInteractionEnabled = false
        } else {
            // hide activity loader
            self.view.hideToastActivity()
            // enable user interaction
            self.view.isUserInteractionEnabled = true
        }
    }
    
    // MARK: Keyboard Hide Button
    func addDoneToolBarToKeyboard(textView:UITextView) {
        let doneToolbar : UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        let flexibelSpaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let hideKeyboardButton   = UIButton()
        hideKeyboardButton.setBackgroundImage(UIImage(named: "downArrow"), for: .normal)
        hideKeyboardButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        hideKeyboardButton.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
        let hideKeyboardItem  = UIBarButtonItem(customView: hideKeyboardButton)
        
        doneToolbar.items = [flexibelSpaceItem, hideKeyboardItem]
        doneToolbar.tintColor = UIColor.darkGray
        doneToolbar.sizeToFit()
        textView.inputAccessoryView = doneToolbar
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //MARK: UIGuesture recognizer delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @IBAction func unwindToRoot(segue: UIStoryboardSegue)
    {
        print("unwind!!")
    }
}

extension AbstractController :UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    func takePhoto() {
        
        let alertController  = UIAlertController(title: "Choose source", message: "", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: openCamera))
        
        alertController.addAction(UIAlertAction(title: "Gallery", style: .default, handler: openGallery))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func openCamera(action: UIAlertAction){
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func openGallery(action: UIAlertAction){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!){

        setImage(image: image)
        self.dismiss(animated: true, completion: nil)
    }
    
    func setImage(image:UIImage){
        
    }
    



    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
}


