//
//  ChooseImageViewController.swift
//  VK_iOSPhoto
//
//  Created by Светлана Мухина on 06.04.2022.
//

import UIKit
import Photos

class ChooseImageViewController: UIViewController {
    
    private var imageArray = [UIImage]()
    private let cellIdentity = "cell"
    private var arrayPhotos = [String]()
    static var chooseImage = UIImage()
   
    lazy private var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right:0)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: view.frame.width/3-2, height: view.frame.width/3-2)
        return layout
    }()
    
    lazy private var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collection.backgroundColor = .white
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    override func viewDidLoad() {
        navigationController?.navigationBar.tintColor = .black
        grabPhoto()
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        let buttonBar = UIBarButtonItem(title: "Internet", style: .plain, target: self, action: #selector(toApiVC))
        self.navigationItem.rightBarButtonItem  = buttonBar
        title = "Photos library"
        configuration()
    }
}

extension ChooseImageViewController {
    
    private func configuration() {
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentity)
        view.backgroundColor = .white
        view.addSubview(collectionView)
    }
    
    private func grabPhoto() {
        let imageManager = PHImageManager.default()
        let requestOption = PHImageRequestOptions()
        requestOption.isSynchronous = true
        requestOption.deliveryMode = .highQualityFormat
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        if let fetchResult = PHAsset.fetchAssets(with: .image, options:  fetchOptions) as? PHFetchResult {
            
            if fetchResult.count > 0 {
                for i in 0..<fetchResult.count {
                    imageManager.requestImage(for: fetchResult.object(at: i) , targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: requestOption) { image, error in
                        self.imageArray.append(image!)
                    }
                }
            } else {
                print(" You got not photos! ")
                let alert = UIAlertController(title: "Sorry!", message: "You got not photos!", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
                collectionView.reloadData()
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc
    private func toApiVC() {
        let newVC = ApiViewController()
        navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(newVC, animated: true)
    }
}
extension ChooseImageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentity, for: indexPath) as? CustomCollectionViewCell else {return UICollectionViewCell()}
        cell.image.image = imageArray[indexPath.row]
        return cell
    }
}
extension ChooseImageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ChooseImageViewController.chooseImage = imageArray[indexPath.row]
        let bigShow = BigImageViewController()
        navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(bigShow, animated: true)
    }
}


