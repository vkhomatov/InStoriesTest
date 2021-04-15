//
//  Spinner.swift
//  InStoriesTestAll
//
//  Created by Vitaly Khomatov on 13.04.2021.
//

import UIKit

class Spinner {
    private var spinner = UIActivityIndicatorView(style: .medium)
    
    func start(forView: UIView, forframe: CGRect ) {
        forView.addSubview(self.spinner)
        self.spinner.frame = forframe
        self.spinner.startAnimating()
    }
    
    func stop() {
        self.spinner.removeFromSuperview()
        self.spinner.stopAnimating()
    }
    
    init() {
        spinner.color = .systemBlue
    }
    
}
