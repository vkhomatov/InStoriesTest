//
//  MainView.swift
//  InStoriesTestAll
//
//  Created by Vitaly Khomatov on 07.04.2021.
//

import UIKit

class MainView: UIView {
    
    public var eyeButton = UIButton(frame: .zero)
    public var addButton = UIButton(frame: .zero)
    public var templateImageView = UIImageView(frame: .zero)
    var closeButton = UIButton(frame: .zero)
    public var buttonCallback: ((_ button: String) -> Void)?
    public var eyeButtonHeigh: CGFloat = 40
    public var deviceKoeff: CGFloat = 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutViews()
    }
    
    private func setupViews() {
        self.contentMode = .scaleAspectFill
        
        eyeButton.setTitle(" ", for: .normal)
        eyeButton.contentMode = .scaleAspectFill
        eyeButton.translatesAutoresizingMaskIntoConstraints = false
        eyeButton.clipsToBounds = true
        eyeButton.backgroundColor = .black
        eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
        eyeButton.imageView?.contentMode = .scaleAspectFit
        eyeButton.isEnabled = false
        eyeButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        self.addSubview(eyeButton)
        
        closeButton.setTitle("  ", for: .normal)
        closeButton.contentMode = .scaleAspectFill
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.imageView?.contentMode = .scaleAspectFit
        closeButton.setImage(UIImage(systemName: "xmark") , for: .normal)
        closeButton.sizeToFit()
        closeButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        closeButton.isHidden = true
        
        templateImageView.translatesAutoresizingMaskIntoConstraints = false
        templateImageView.backgroundColor = .systemGray5
        templateImageView.contentMode = .scaleAspectFit
        templateImageView.clipsToBounds = true
        templateImageView.sizeToFit()
        templateImageView.image = UIImage(named: "templateOld")
        templateImageView.isUserInteractionEnabled = true
        
        addButton.titleLabel?.textAlignment = .center
        addButton.titleLabel?.baselineAdjustment = .alignBaselines
        addButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        addButton.setTitle("add photo", for: .normal)
        addButton.setTitleColor(.gray, for: .normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.clipsToBounds = true
        addButton.setImage(UIImage(systemName: "photo"), for: .normal)
        addButton.imageView?.contentMode = .scaleAspectFit
        addButton.sizeToFit()
        addButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        addButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: (addButton.titleLabel?.bounds.height)! + 14, right: 0)
        addButton.titleEdgeInsets = UIEdgeInsets(top: (addButton.imageView?.bounds.height)! + 50, left: -(addButton.imageView?.bounds.width)!, bottom: 0, right: 0)
        addButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(addButton.titleLabel?.bounds.width)!)
        self.addSubview(templateImageView)
        
        templateImageView.addSubview(addButton)
        templateImageView.addSubview(closeButton)
    }
    
    private func layoutViews() {
        eyeButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        eyeButton.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        eyeButton.heightAnchor.constraint(equalToConstant: eyeButtonHeigh).isActive = true
        
        templateImageView.topAnchor.constraint(equalTo: eyeButton.bottomAnchor).isActive = true
        templateImageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        templateImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        addButton.centerYAnchor.constraint(equalTo: templateImageView.centerYAnchor, constant: -eyeButtonHeigh/deviceKoeff).isActive = true
        addButton.centerXAnchor.constraint(equalTo: templateImageView.centerXAnchor).isActive = true
        
        closeButton.topAnchor.constraint(equalTo: templateImageView.topAnchor, constant: 24).isActive = true
        closeButton.leftAnchor.constraint(equalTo: templateImageView.rightAnchor, constant: -40).isActive = true
    }
    
    
    @objc private func buttonPressed(_ sender: UIButton) {
        if let callback = self.buttonCallback {
            if let message = sender.titleLabel?.text {
                callback(message)
            }
        }
    }
    
}
