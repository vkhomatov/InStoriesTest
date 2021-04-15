//
//  ViewController.swift
//  InStoriesTestAll
//
//  Created by Vitaly Khomatov on 02.04.2021.
//

import UIKit
import Kingfisher

class MainViewController: UIViewController, CAAnimationDelegate {
    
    private var mainView = MainView(frame: .zero)
    private var collectionViewController = CollectionViewController()
    private var animator = Animator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setCallbacks()
    }
    
    func setupViews() {
        mainView = MainView(frame: self.view.bounds)
        if ErrorMessage.newIphoneModel() {
            mainView.eyeButtonHeigh = 80
            mainView.eyeButton.imageEdgeInsets = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
            mainView.templateImageView.image = UIImage(named: "templateNew")
            mainView.deviceKoeff = 4
        }
        self.view = mainView
        animator = Animator(view: self.view, header: mainView.eyeButtonHeigh)
    }
    
    private func setCallbacks() {
        
        collectionViewController.addNewPhoto = { [weak self] url in
            guard let self = self else { return }
            
            KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    DispatchQueue.main.async {
                        self.mainView.templateImageView.backgroundColor = .clear
                        self.mainView.layer.contents = value.image.cgImage
                        self.mainView.closeButton.isHidden = false
                        self.mainView.addButton.isHidden = true
                        self.mainView.eyeButton.isEnabled = true
                        self.collectionViewController.spinner.stop()
                        self.collectionViewController.dismiss(animated: true, completion: nil)
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
        
        mainView.buttonCallback = { [weak self] message in
            guard let self = self else { return }
            switch message {
            case " ":
                DispatchQueue.main.async {
                    if !self.animator.progress {
                        self.mainView.templateImageView.isHidden = true
                        self.animator.startAnimation()
                    } else {
                        self.mainView.templateImageView.isHidden = false
                        self.animator.stopAnimation()
                    }
                }
            case "add photo":
                self.collectionViewController.modalPresentationStyle = .fullScreen
                self.present(self.collectionViewController, animated: true, completion: nil)
            case "  ":
                UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve, animations: { [weak self] in
                    guard let self = self else { return }
                    self.mainView.closeButton.isHidden = true
                    self.mainView.addButton.isHidden = false
                    self.mainView.layer.contents = nil
                    self.mainView.templateImageView.backgroundColor = .systemGray5
                    self.mainView.eyeButton.isEnabled = false
                }, completion: nil )
            default:
                break
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
//    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//        animator.whiteViewCopy.isHidden = false
//        animator.whiteView.isHidden = true
//        if let subLayers = animator.whiteView.layer.sublayers {
//            subLayers.forEach { $0.removeAllAnimations() }
//        }
//    }
    
}

