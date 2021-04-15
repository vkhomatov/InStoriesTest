//
//  ErrorMessage.swift
//  InStoriesTestAll
//
//  Created by Vitaly Khomatov on 10.04.2021.
//

import UIKit

class ErrorMessage: UIView {
    
    private var parentView = UIView()
    private var errorMessageView = UIView()
    private var errorMessageLabel = UILabel()
    private var errorHeight: CGFloat = 60
    private var topHeight: CGFloat = 5
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutViews()
    }
    
    convenience init(view: UIView) {
        self.init()
        parentView = view
        setupSubviews()
        layoutViews()
    }
    
    private func setupSubviews() {
        
        if ErrorMessage.newIphoneModel() {
            errorHeight = 90
            topHeight = 35
        }
        
        errorMessageView = UIView(frame: CGRect(x: parentView.frame.minX , y: errorHeight*(-1), width: parentView.bounds.width, height: errorHeight))
        errorMessageView.center.x = parentView.center.x
        errorMessageView.backgroundColor = .systemYellow
        errorMessageView.layer.cornerRadius = 6
        parentView.addSubview(errorMessageView)
        
        errorMessageLabel = UILabel(frame: .zero)
        errorMessageLabel.lineBreakMode = .byWordWrapping
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.text = "Loading message ..."
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.font = .systemFont(ofSize: 15, weight: .medium)
        errorMessageLabel.textColor = .white
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageView.addSubview(errorMessageLabel)
        
    }
    
    private func layoutViews() {
        errorMessageLabel.topAnchor.constraint(equalTo: errorMessageView.topAnchor, constant: topHeight).isActive = true
        errorMessageLabel.bottomAnchor.constraint(equalTo: errorMessageView.bottomAnchor, constant: -5.0).isActive = true
        errorMessageLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 22).isActive = true
        errorMessageLabel.leftAnchor.constraint(equalTo: errorMessageView.leftAnchor, constant: 5.0).isActive = true
        errorMessageLabel.rightAnchor.constraint(equalTo: errorMessageView.rightAnchor, constant: -5.0).isActive = true
    }
    
    private func animationView(reverse: Bool, duration: Double, delay: Double,  offsetY: CGFloat, opacity: Float) {
        UIView.animate(withDuration: duration, delay: 0.2, options: .curveEaseOut, animations: { [weak self] in
                        guard let self = self else { return }
                        self.errorMessageView.frame = self.errorMessageView.frame.offsetBy(dx: 0, dy: offsetY)
                        self.errorMessageView.layer.opacity = opacity }) { (finish) in
            if reverse {
                UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: { [weak self] in
                                guard let self = self else { return }
                                self.errorMessageView.frame = self.errorMessageView.frame.offsetBy(dx: 0, dy: offsetY * -1)
                                self.errorMessageView.layer.opacity = opacity }) { (finish) in
                    self.errorMessageView.removeFromSuperview()
                }
            }
        }
    }
    
    func showError(reverse: Bool, message: String, delay: Double) {
        self.errorMessageLabel.text = message
        self.animationView(reverse: reverse, duration: 1.0, delay: delay, offsetY: errorHeight, opacity: 1.0)
    }
    
    static func newIphoneModel() -> Bool {
        
        let deviceModel = UIDevice.current.name
        if deviceModel.contains("X") || deviceModel.contains("11") || deviceModel.contains("12")  {
            return true
        } else {
            return false
        }
        
    }
    
}
