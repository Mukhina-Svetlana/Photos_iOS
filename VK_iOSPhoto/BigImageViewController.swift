//
//  BigImageViewController.swift
//  VK_iOSPhoto
//
//  Created by Светлана Мухина on 07.04.2022.
//

import UIKit
import CoreImage

class BigImageViewController: UIViewController {
    private var CIFilterNames = [
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CISepiaTone",
        "CIColorInvert",
        "CIPhotoEffectMono"
    ]
    
    lazy private var bigImage : UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var editPhoto: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapEdit), for: .touchUpInside)
        return button
    }()
    
    private lazy var savePhoto: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        return button
    }()
    
    lazy private var scroolView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.indicatorStyle =  .black
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    override func viewDidLoad() {
        let buttonBar = UIBarButtonItem(title: "Выбрать", style: .plain, target: self, action: #selector(toMainViewController))
        self.navigationItem.rightBarButtonItem  = buttonBar
        super.viewDidLoad()
        configuration()
        configurationScrool()
    }
}
extension BigImageViewController {
        private func configuration() {
            view.backgroundColor = .secondarySystemBackground
            scroolView.isHidden = true
            view.addSubview(bigImage)
            view.addSubview(editPhoto)
            view.addSubview(scroolView)
            view.addSubview(savePhoto)
            
            if ChooseImageViewController.chooseImage != UIImage() {
            bigImage.image = ChooseImageViewController.chooseImage
            } else {
                bigImage.image = ApiViewController.chooseImage
            }
            
            NSLayoutConstraint.activate([
                bigImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                bigImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                bigImage.widthAnchor.constraint(equalTo: view.widthAnchor),
                bigImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3),
                
                editPhoto.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                editPhoto.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
                
                savePhoto.bottomAnchor.constraint(equalTo: editPhoto.bottomAnchor),
                savePhoto.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
                
                
                scroolView.bottomAnchor.constraint(equalTo: editPhoto.topAnchor),
                scroolView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scroolView.heightAnchor.constraint(equalToConstant: 80),
                scroolView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                
            ])
        }
    private func configurationScrool() {
        var xCoord: CGFloat = 5
        let yCoord: CGFloat = 5
        let buttonWidth:CGFloat = 70
        let buttonHeight: CGFloat = 70
        let gapBetweenButtons: CGFloat = 5
        for i in 0..<CIFilterNames.count {
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            button.layer.cornerRadius = 6
            button.clipsToBounds = true
            button.tag = i
            let ciContext = CIContext()
            let baseImage = bigImage.image
            let bgImage = CIImage(image: baseImage!)
            let filter = CIFilter(name: "\(CIFilterNames[i])")
            filter?.setDefaults()
            filter?.setValue(bgImage, forKey: kCIInputImageKey)
            // let outputImage = filter?.outputImage
            let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
            let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
            let imageNew = UIImage(cgImage: filteredImageRef!)
            button.setBackgroundImage(imageNew, for: .normal)
            xCoord += buttonWidth + gapBetweenButtons
            button.addTarget(self, action: #selector(photoPress(button:)), for: .touchUpInside)
            scroolView.addSubview(button)
            
        }
        scroolView.contentSize = CGSize(width: buttonWidth * CGFloat(CIFilterNames.count+1), height: yCoord + buttonHeight)
    }
    
    @objc
    private func didTapEdit() {
        scroolView.isHidden = false
    }
    @objc
    private func toMainViewController() {
          let newViewController = UINavigationController(rootViewController: MainViewController())
        newViewController.modalPresentationStyle = .fullScreen
        Base.shared.saveUser(name: ViewController.name, password: ViewController.password, image:  bigImage.image!)
        present(newViewController, animated: true, completion: nil)
    }
    
    @objc
    private func photoPress(button: UIButton){
        bigImage.image = button.backgroundImage(for: .normal)
    }
    
    @objc
    private func didTapSave() {
    UIImageWriteToSavedPhotosAlbum(bigImage.image!, nil, nil, nil)
    let alert = UIAlertController(title: "Успешно!",
                                  message: "Ваше фото сохранено в Photo Library!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}
