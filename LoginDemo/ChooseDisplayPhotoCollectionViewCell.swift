//
//  ChooseDisplayPhotoCollectionViewCell.swift
//  LoginDemo
//
//  Created by 塗詠順 on 2022/4/29.
//

import UIKit

class ChooseDisplayPhotoCollectionViewCell: UICollectionViewCell {
    
    static let shard = ChooseDisplayPhotoCollectionViewCell()
    
    @IBOutlet weak var displayPhoto: UIImageView!
    
    func configureCellSize(_ collectionView: UICollectionView, _ collectionViewWidth: CGFloat) {
        let itemSpace: CGFloat = 8
        let columCount: CGFloat = 4
        let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        let width = floor((collectionViewWidth - itemSpace * (columCount - 1) - 16) / columCount)
        print("\(width)")
        flowLayout?.itemSize = CGSize(width: width, height: width)
        flowLayout?.estimatedItemSize = .zero
        flowLayout?.minimumLineSpacing = itemSpace
        flowLayout?.minimumInteritemSpacing = itemSpace
    }
    
}
