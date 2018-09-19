//
//  PreviewCollectionViewCell.swift
//  PrenatalCalc
//
//  Created by Leon Yannik Lopez Rojas on 8/26/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//



//
//import UIKit
//
//class PreviewCollectionViewCell: UICollectionViewCell {
//
//    @IBOutlet weak var collectionView: UICollectionView!
//    @IBOutlet weak var logoSpace: UIImageView!
//    @IBOutlet weak var doctorNameLabel: UILabel!
//    @IBOutlet weak var headerView: UIView!
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        collectionView.dataSource = self
//        collectionView.delegate = self
//    }
//
//}
//
//extension PreviewCollectionViewCell: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        var size = CGSize(width: (collectionView.frame.size.width / 2) - (collectionView.frame.size.width / 160), height: (collectionView.frame.size.width / 22) - (collectionView.frame.size.width / 160))
//        if indexPath.section == 1 {
//            size = CGSize(width: (collectionView.frame.size.width / 3) - (collectionView.frame.size.width / 160), height: (collectionView.frame.size.width / 22) - (collectionView.frame.size.width / 160))
//        }else if indexPath.section == 2 {
//            size = CGSize(width: (collectionView.frame.size.width / 3) - (collectionView.frame.size.width / 160), height: (collectionView.frame.size.width / 22) - (collectionView.frame.size.width / 160))
//        }
//        return size
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return collectionView.frame.size.width / 180
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return collectionView.frame.size.width / 180
//    }
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerCell", for: indexPath)
//
//        return view
//    }
//}
//
//extension PreviewCollectionViewCell: UICollectionViewDataSource {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 3
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch section {
//        case 0:
//            return 6
//        case 1:
//            return 33
//        default:
//            return 17
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "valueCell", for: indexPath) as! ValueCollectionViewCell
//
//        return cell
//    }
//}
//
//extension PreviewCollectionViewCell: UICollectionViewDelegate {
//
//}

