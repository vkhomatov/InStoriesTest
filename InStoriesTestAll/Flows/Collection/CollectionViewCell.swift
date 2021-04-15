//
//  UsplashCollectionViewCell.swift
//  InStoriesTestAll
//
//  Created by Vitaly Khomatov on 07.04.2021.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    public var photoImageView = UIImageView(frame: .zero)
    public var cellHeight: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(photoImageView)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutViews()
    }
    
    func setupSubviews() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.backgroundColor = .black
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.clipsToBounds = true
    }
    
    func layoutViews() {
        photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        photoImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        photoImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
