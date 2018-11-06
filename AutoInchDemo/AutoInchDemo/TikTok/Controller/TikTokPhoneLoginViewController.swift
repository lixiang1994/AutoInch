//
//  TikTokPhoneLoginViewController.swift
//  AutoInchDemo
//
//  Created by 李响 on 2018/11/5.
//  Copyright © 2018 swift. All rights reserved.
//

import UIKit

class TikTokPhoneLoginViewController: UIViewController {

    private lazy var layer = CAGradientLayer().then {
        let colors: [CGColor] =  [#colorLiteral(red: 0.462745098, green: 0.4588235294, blue: 0.9607843137, alpha: 1), #colorLiteral(red: 0.5647058824, green: 0.2784313725, blue: 1, alpha: 1), #colorLiteral(red: 0.6588235294, green: 0.1803921569, blue: 0.9019607843, alpha: 1)]
        $0.locations = [0.0, 0.3, 1.0]
        $0.colors = colors
        $0.opacity = 0.8
    }
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    
    @IBOutlet weak var areaButton: UIButton!
    @IBOutlet weak var captchaButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var otherView: UIView!
    
    private var phone: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupNotification()
        
        view.layoutIfNeeded()
        phoneTextField.addTarget(self, action: #selector(phoneTextFieldAction), for: .editingChanged)
        phoneTextField.becomeFirstResponder()
        
        if let button = phoneTextField.value(forKey: "_clearButton") as? UIButton {
            button.setImage(#imageLiteral(resourceName: "tiktok_textfield_clear"), for: .normal)
            button.setImage(#imageLiteral(resourceName: "tiktok_textfield_clear"), for: .highlighted)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layer.frame = view.bounds
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
        dismiss(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    @IBAction func areaAction(_ sender: UIButton) {
        
    }
    
    @IBAction func captchaAction(_ sender: UIButton) {
        
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        
    }
    
    @objc private func phoneTextFieldAction(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }
        
        if text.count > phone.count {
            if text.count == 3 || text.count == 8 {
                sender.text = text + " "
            }
            if text.count >= 13 {
                sender.text = String(text.prefix(13))
                codeTextField.becomeFirstResponder()
            }
            
            phone = text
            
        } else if text.count < phone.count {
            if text.count == 3 || text.count == 8 {
                sender.text = String(text.prefix(text.count - 1))
            }
            
            phone = text
        }
        
        UIView.beginAnimations("", context: nil)
        UIView.setAnimationDuration(0.2)
        captchaButton.isEnabled = !text.isEmpty
        loginView.alpha = text.isEmpty ? 0 : 1
        otherView.alpha = text.isEmpty ? 1 : 0
        UIView.commitAnimations()
    }
}

extension TikTokPhoneLoginViewController {
    
    private func setup() {
        view.layer.insertSublayer(layer, at: 0)
    }
    
    private func setupNotification() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
}

extension TikTokPhoneLoginViewController {
    
    @objc private func keyboardWillChangeFrame(_ sender: Notification) {
        guard let info = sender.userInfo else {
            return
        }
        guard let local = info[UIResponder.keyboardIsLocalUserInfoKey] as? Int, local == 1 else {
            return
        }
        guard
            let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curveRaw = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
            let curve = UIView.AnimationCurve(rawValue: curveRaw),
            let end = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        bottomConstraint.constant = view.bounds.height - end.minY
        
        UIView.beginAnimations("keyboard", context: nil)
        UIView.setAnimationDuration(duration)
        UIView.setAnimationCurve(curve)
        view.layoutIfNeeded()
        UIView.commitAnimations()
    }
}
