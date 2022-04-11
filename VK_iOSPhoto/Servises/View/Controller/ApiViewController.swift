//
//  ApiViewController.swift
//  VK_iOSPhoto
//
//  Created by Светлана Мухина on 09.04.2022.
//

import UIKit

class ApiViewController: UIViewController {
    private let cellIdentity = "cell"
    private let networkService = Networking()
    private var arrayPhotos = [String]()
    private var arrayImages = [UIImage]()
    static var chooseImage = UIImage()
    
    lazy private var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.estimatedItemSize = .zero
        layout.itemSize = CGSize(width: view.frame.width/3 - 2, height: view.frame.width/3 - 2)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
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
        getArrays()
        super.viewDidLoad()
        title = "Photo from internet"
        configuration()
    }
}

extension ApiViewController {
    private func configuration() {
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentity)
        view.backgroundColor = .white
        view.addSubview(collectionView)
    }
    
    private func getArrays() {
        networkService.alert = {
            let alert = UIAlertController(title: "Warning", message: "Request couldn't be completed", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default) { action in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        networkService.request { model in
            for i in model {
                self.arrayPhotos.append(i.urlPhoto)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

extension ApiViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentity, for: indexPath) as? CustomCollectionViewCell else {return UICollectionViewCell()}
        cell.image.set(imageURL: arrayPhotos[indexPath.row], completion: { [weak self] images in
            self!.arrayImages.append(images)
        })
        return cell
    }
}

extension ApiViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ApiViewController.chooseImage = arrayImages[indexPath.row]
        let bigShow = BigImageViewController()
        navigationItem.backButtonTitle = ""
        show(bigShow, sender: nil)
    }
}


    
