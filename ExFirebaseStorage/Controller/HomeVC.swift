//
//  HomeVC.swift
//  ExFirebaseStorage
//
//  Created by 김종권 on 2021/11/19.
//

import UIKit
import FirebaseStorage
import Firebase

enum FileContentType: String {
    case image
    
    var name: String {
        return self.rawValue
    }
}

class HomeVC: UIViewController {
    
    private lazy var imagePickerButton: UIButton = {
        let button = UIButton()
        button.setTitle("이미지 업로드", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.blue, for: .highlighted)
        button.addTarget(self, action: #selector(didTapImagePickerButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var loadImageFromFirebaseButton: UIButton = {
        let button = UIButton()
        button.setTitle("Firebase로부터 이미지 로드", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.blue, for: .highlighted)
        button.addTarget(self, action: #selector(didTapLoadImageFromFirebaseButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        return picker
    }()
    
    private lazy var downloadImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "홈 화면"
        
        view.addSubview(imagePickerButton)
        view.addSubview(downloadImageView)
        view.addSubview(loadImageFromFirebaseButton)
        
        imagePickerButton.translatesAutoresizingMaskIntoConstraints = false
        downloadImageView.translatesAutoresizingMaskIntoConstraints = false
        loadImageFromFirebaseButton.translatesAutoresizingMaskIntoConstraints = false
        
        imagePickerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 56).isActive = true
        imagePickerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        downloadImageView.topAnchor.constraint(equalTo: imagePickerButton.topAnchor, constant: 16).isActive = true
        downloadImageView.centerXAnchor.constraint(equalTo: imagePickerButton.centerXAnchor).isActive = true
        
        loadImageFromFirebaseButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -56).isActive = true
        loadImageFromFirebaseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc private func didTapImagePickerButton() {
        present(imagePicker, animated: true)
    }
    
    @objc private func didTapLoadImageFromFirebaseButton() {
        guard let urlString = UserDefaults.standard.string(forKey: "myImageUrl"),
              let url = URL(string: urlString) else { return }
        
        FirebaseStorageManager.downloadImage(url: url) { [weak self] image in
            self?.downloadImageView.image = image
        }
    }
}

extension HomeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
              let user = Auth.auth().currentUser else { return }
        
        FirebaseStorageManager.uploadImage(image: selectedImage, pathRoot: user.uid) { url in
            if let url = url {
                UserDefaults.standard.set(url, forKey: "myImageUrl")
                self.title = "이미지 업로드 완료"
            }
            print("완료 = \(url)")
        }
        
        picker.dismiss(animated: true)
    }
}
