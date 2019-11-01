//
//  TikTokPhoneLoginViewController.swift
//  Demo
//
//  Created by 李响 on 2018/11/5.
//  Copyright © 2018 swift. All rights reserved.
//

import UIKit

class TikTokPhoneLoginViewController: UIViewController {

    private lazy var layer = CAGradientLayer().then {
        let colors: [CGColor] =  [#colorLiteral(red: 0.4727493525, green: 0.4444301128, blue: 0.9979013801, alpha: 1), #colorLiteral(red: 0.5695798397, green: 0.2927905917, blue: 0.9881889224, alpha: 1), #colorLiteral(red: 0.6905713677, green: 0.1041976586, blue: 0.9767265916, alpha: 1), #colorLiteral(red: 0.7510715127, green: 0.002722046804, blue: 0.9681376815, alpha: 1)]
        $0.locations = [0.0, 0.4, 0.8, 1.0]
        $0.colors = colors
        $0.opacity = 0.9
    }
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var areaButton: UIButton!
    @IBOutlet weak var captchaButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var otherView: UIView!
    
    private var phone = ""
    private var isLogging = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupNotification()
        
        phoneTextField.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if phone.count < 13 {
            phoneTextField.becomeFirstResponder()
        } else {
            codeTextField.becomeFirstResponder()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layer.frame = view.bounds
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "password":
            guard let controller = segue.destination as? TikTokPasswordLoginViewController else {
                return
            }
            
            controller.phone = phone
            
        default: break
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard !isLogging else {
            return
        }
        
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
        guard
            let phone = phoneTextField.text,
            let code = codeTextField.text else {
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
        
        logging(phone.trimmingCharacters(in: .whitespaces), code) {
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
        UIView.setAnimationDuration(0.25)
        captchaButton.isEnabled = !text.isEmpty
        loginView.alpha = text.isEmpty ? 0 : 1
        otherView.alpha = text.isEmpty ? 1 : 0
        UIView.commitAnimations()
        
        checkDoneStatus()
    }
    
    @IBAction func codeChangeAction(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }
        
        if text.count >= 6 {
            sender.text = String(text.prefix(6))
        }
        
        checkDoneStatus()
    }
}

extension TikTokPhoneLoginViewController {
    
    private func setup() {
        view.layer.insertSublayer(layer, at: 0)
        view.layoutIfNeeded()
        
        if let button = phoneTextField.value(forKey: "_clearButton") as? UIButton {
            button.setImage(#imageLiteral(resourceName: "tiktok_textfield_clear"), for: .normal)
            button.adjustsImageWhenHighlighted = false
        }
        
        phoneTextField.attributedPlaceholder = .init(
            string: phoneTextField.placeholder ?? "",
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        )
        codeTextField.attributedPlaceholder = .init(
            string: codeTextField.placeholder ?? "",
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
            let code = codeTextField.text else {
            return
        }
        
        let ok = phone.count == 13 && code.count == 6
        UIView.beginAnimations("", context: nil)
        UIView.setAnimationDuration(0.25)
        doneButton.alpha = ok ? 1.0 : 0.5
        UIView.commitAnimations()
    }
}

extension TikTokPhoneLoginViewController {
    
    private func logging(_ phone: String,
                         _ code: String,
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
