//
//  TikTokPasswordLoginViewController.swift
//  Demo
//
//  Created by 李响 on 2018/11/5.
//  Copyright © 2018 swift. All rights reserved.
//

import UIKit

class TikTokPasswordLoginViewController: UIViewController {

    var phone = ""
    
    private lazy var layer = CAGradientLayer().then {
        let colors: [CGColor] =  [#colorLiteral(red: 0.4727493525, green: 0.4444301128, blue: 0.9979013801, alpha: 1), #colorLiteral(red: 0.5695798397, green: 0.2927905917, blue: 0.9881889224, alpha: 1), #colorLiteral(red: 0.6905713677, green: 0.1041976586, blue: 0.9767265916, alpha: 1), #colorLiteral(red: 0.7510715127, green: 0.002722046804, blue: 0.9681376815, alpha: 1)]
        $0.locations = [0.0, 0.4, 0.8, 1.0]
        $0.colors = colors
        $0.opacity = 1.0
    }
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var areaButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    private var isLogging = false
    private var isDidAppear = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupNotification()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
        isDidAppear = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        isDidAppear = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        if phone.count < 13 {
            phoneTextField.becomeFirstResponder()
        } else {
            passwordTextField.becomeFirstResponder()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layer.frame = view.bounds
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard !isLogging else {
            return
        }
        
        view.endEditing(true)
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
    
    @IBAction func doneAction(_ sender: UIButton) {
        guard
            let phone = phoneTextField.text,
            let password = passwordTextField.text else {
            return
        }
        guard sender.alpha == 1 else {
            return
        }
        guard !isLogging else {
            return
        }
        
        sender.setBackgroundImage(#imageLiteral(resourceName: "tiktok_sign_loading"), for: .normal)
        
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation.z"
        animation.fromValue = 0
        animation.toValue = 360 * CGFloat(CGFloat.pi / 180)
        animation.duration = 0.9
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        sender.layer.add(animation, forKey: "loading")
        
        logging(phone.trimmingCharacters(in: .whitespaces), password) {
            [weak self] (result) in
            guard let self = self else { return }
            
            if result {
                self.view.endEditing(true)
                self.dismiss(animated: true)
                
            } else {
                sender.layer.removeAllAnimations()
                sender.setBackgroundImage(#imageLiteral(resourceName: "tiktok_sign_done"), for: .normal)
            }
        }
    }
    
    @IBAction func phoneChangeAction(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }
        
        if text.count > phone.count {
            if text.count == 3 || text.count == 8 {
                sender.text = text + " "
            }
            if text.count >= 13 {
                sender.text = String(text.prefix(13))
                passwordTextField.becomeFirstResponder()
            }
            
            phone = text
            
        } else if text.count < phone.count {
            if text.count == 3 || text.count == 8 {
                sender.text = String(text.prefix(text.count - 1))
            }
            
            phone = text
        }
        
        checkDoneStatus()
    }
    
    @IBAction func passwordChangeAction(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }
        
        if text.count >= 6 {
            sender.text = String(text.prefix(6))
        }
        
        checkDoneStatus()
    }
}

extension TikTokPasswordLoginViewController {
    
    private func setup() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        view.layer.insertSublayer(layer, at: 0)
        view.layoutIfNeeded()
        
        phoneTextField.text = phone
        
        if let button = phoneTextField.value(forKey: "_clearButton") as? UIButton {
            button.setImage(#imageLiteral(resourceName: "tiktok_textfield_clear"), for: .normal)
            button.adjustsImageWhenHighlighted = false
        }
        if let button = passwordTextField.value(forKey: "_clearButton") as? UIButton {
            button.setImage(#imageLiteral(resourceName: "tiktok_textfield_clear"), for: .normal)
            button.adjustsImageWhenHighlighted = false
        }
        
        phoneTextField.attributedPlaceholder = .init(
            string: phoneTextField.placeholder ?? "",
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        )
        passwordTextField.attributedPlaceholder = .init(
            string: passwordTextField.placeholder ?? "",
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        )
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
    private func checkDoneStatus() {
        guard
            let phone = phoneTextField.text,
            let password = passwordTextField.text else {
            return
        }
        
        let ok = phone.count == 13 && !password.isEmpty
        UIView.beginAnimations("", context: nil)
        UIView.setAnimationDuration(0.25)
        doneButton.alpha = ok ? 1.0 : 0.5
        UIView.commitAnimations()
    }
}

extension TikTokPasswordLoginViewController {
    
    private func logging(_ phone: String,
                         _ password: String,
                         _ completion: @escaping (Bool) -> Void) {
        isLogging = true
        // 假装请求登录
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.isLogging = false
            // 随机返回成功 or 失败
            let result = Int.random(in: 0...1) == 0 ? true : false
            completion(result)
        }
    }
}

extension TikTokPasswordLoginViewController {
    
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
        guard isDidAppear else {
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
