//
//  ChooseDisplayPhotoViewController.swift
//  LoginDemo
//
//  Created by 塗詠順 on 2022/4/29.
//

import UIKit

protocol ChooseDisplayPhotoViewControllerDelegate {
    func chooseDisplayPhoto(displayPhoto image: DisplayPhoto)
}

class ChooseDisplayPhotoViewController: UIViewController {
    
    @IBOutlet weak var displayPhotoCollectionView: UICollectionView!
    
    var photoItems = [DisplayPhoto]() {
        didSet {
            DispatchQueue.main.async {
                self.displayPhotoCollectionView.reloadData()
            }
        }
    }
    
    var delegate: ChooseDisplayPhotoViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ChooseDisplayPhotoCollectionViewCell.shard.configureCellSize(self.displayPhotoCollectionView, UIScreen.main.bounds.width)
        print("\(UIScreen.main.bounds.width)")


        
        
        for i in 1...80 {
            if let url = URL(string: "https://picsum.photos/id/\(i)/200/300") {
                updataDisplayPhotoItems(url)
            }
        }
        
    }
        
    func updataDisplayPhotoItems(_ displayPhotoURL: URL?) {
        guard let URL = displayPhotoURL else { return }
        let photoItem = DisplayPhoto(photo: URL)
        photoItems.append(photoItem)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}

extension ChooseDisplayPhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = displayPhotoCollectionView.dequeueReusableCell(withReuseIdentifier: "\(ChooseDisplayPhotoCollectionViewCell.self)", for: indexPath) as? ChooseDisplayPhotoCollectionViewCell else { return UICollectionViewCell() }
        
        let photoItem = photoItems[indexPath.row]
        cell.displayPhoto.image = UIImage(named: "camera")
        
        ChooseDisplayPhotoController.shard.fetchImage(photoItem.photo) { image in
            DispatchQueue.main.async {
                cell.displayPhoto.image = image
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoItem = photoItems[indexPath.row]
        delegate?.chooseDisplayPhoto(displayPhoto: photoItem)
        dismiss(animated: true)
    }
    
    
}

extension ChooseDisplayPhotoViewController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        ChooseDisplayPhotoCollectionViewCell.shard.configureCellSize(self.displayPhotoCollectionView, size.width)
    }

}
