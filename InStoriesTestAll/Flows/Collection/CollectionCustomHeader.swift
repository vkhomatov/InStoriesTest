//
//  CollectionCustomHeader.swift
//  InStoriesTestAll
//
//  Created by Vitaly Khomatov on 10.04.2021.
//

import UIKit

class CollectionCustomHeader: UICollectionReusableView {
    public var label = UILabel(frame: .zero)
    private var closeButton = UIButton(frame: .zero)
    public var buttonCallback: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        self.isUserInteractionEnabled = true
        self.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutViews()
    }
    
    func setupViews() {
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.text =  "Unsplash random pictures"
        label.sizeToFit()
        label.center = self.center
        self.addSubview(label)
        
        closeButton.contentMode = .scaleAspectFill
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.imageView?.contentMode = .scaleAspectFit
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.sizeToFit()
        closeButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        self.addSubview(closeButton)
        
    }
    
    private func layoutViews() {
        closeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        closeButton.leftAnchor.constraint(equalTo: self.rightAnchor, constant: -30.0).isActive = true
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        if let callback = self.buttonCallback {
            print("callback")
            callback()
        }
    }
    
}
