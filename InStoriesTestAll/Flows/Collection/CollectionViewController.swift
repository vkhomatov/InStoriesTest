//
//  UnsplashCollectionViewController.swift
//  InStoriesTestAll
//
//  Created by Vitaly Khomatov on 07.04.2021.
//

import UIKit
import Kingfisher

private let reuseIdentifier = "usplashCell"

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CustomLayoutDelegate {
        
    private var networkService = NetworkService()
    private var photos = [Photo]()
    private var network = NetworkMonitor()
    public var spinner = Spinner()
    private var cellHeight: CGFloat = 0
    public var addNewPhoto: ((_ url: URL) -> Void)?
    private var header = CollectionCustomHeader()
    private var flowLayout = CollectionCustomViewLayout()
    
    init() {
        super.init(collectionViewLayout: flowLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNetworkMonitor()
        setupCollectionView()
        self.view.backgroundColor = .black
    }
    
    // MARK: - NetworkMonitor
    private func startNetworkMonitor() {
        
        #if targetEnvironment(simulator)
        
        #else
        model.network.monitor.pathUpdateHandler = { path in
            if path.status == .satisfied  {
                DispatchQueue.main.async {
                    self.showError(message: "Online Mode", delay: 2)
                }
                if self.model.photos.count < 30 {
                    self.loadPhotos()
                }
            } else if path.status == .unsatisfied  {
                DispatchQueue.main.async {
                    self.model.spinner.stop()
                    self.showError(message: "Offline Mode", delay: 2)
                }
            }
        }
        #endif
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadPhotos()
    }
    
    private func setupCollectionView() {
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionHeadersPinToVisibleBounds = true
        flowLayout.delegate = self
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: view.frame.height)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.keyboardDismissMode = .onDrag
        collectionView.backgroundColor = .black
    }
    
    private func loadPhotos() {
        DispatchQueue.main.async {
            self.spinner.start(forView: self.header, forframe: CGRect(x: self.header.label.frame.minX-20, y: self.header.center.y, width: 0, height: 0))
        }
        networkService.getRandomPhotos(value: 30) { [weak self] result, message in
            guard let self = self else { return }
            switch result {
            case let .success(photos):
                self.photos = photos
                DispatchQueue.main.async {
                    UIView.transition(with: self.view, duration: 0.8, options: .transitionCrossDissolve, animations: { [weak self] in
                        guard let self = self else { return }
                        self.collectionView.reloadData()
                    }, completion: nil )
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showError(message: error.localizedDescription, delay: 2)
                    self.spinner.stop()
                }
            case .none:
                DispatchQueue.main.async {
                    self.showError(message: "Ошибка сервера: \(message ?? "Unknown")", delay: 2)
                    self.spinner.stop()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let columns: CGFloat = 2
        let itemWeight: CGFloat = collectionView.frame.width / columns
        cellHeight = CGFloat(CGFloat(photos[indexPath.item].height)/CGFloat(photos[indexPath.item].width)) * itemWeight
        return cellHeight
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        cell.photoImageView.kf.setImage(with: URL(string: photos[indexPath.row].urls.thumb)) { result, error in
            DispatchQueue.main.async {
                self.spinner.stop()
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {        
        if let callback = self.addNewPhoto {
            if let url = URL(string: self.photos[indexPath.row].urls.regular) {
                callback(url)
                guard let cell = self.collectionView.cellForItem(at: indexPath)?.contentView else { return }
                DispatchQueue.main.async {
                    self.spinner.start(forView: cell, forframe: CGRect(x: cell.frame.midX, y: cell.frame.midY, width: 0, height: 0))
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        collectionView.register(CollectionCustomHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? CollectionCustomHeader ?? CollectionCustomHeader()
            header.buttonCallback  = { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: nil)
            }
            return header
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: 50)
    }
    
    private func showError(message: String, delay: Double) {
        DispatchQueue.main.async {
            let errorMessage = ErrorMessage(view: self.view)
            errorMessage.showError(reverse: true, message: message, delay: delay)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

