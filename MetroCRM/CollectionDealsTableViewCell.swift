//
//  CollectionDealsTableViewCell.swift
//  MetroCRM
//
//  Created by Harsha Krishnarao Warjurkar on 29/03/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class CollectionDealsTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 178.0), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "dealsCollectionCell")
        collectionView.backgroundColor = UIColor.lightGray
        
        self.addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: UICollectionViewDataSource
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "dealsCollectionCell", for: indexPath)
        if indexPath.row%2 == 0 {
            cell.backgroundColor = UIColor.red
        } else {
            cell.backgroundColor = UIColor.yellow
        }
        
        return cell
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cellsAcross: CGFloat = 4
//        var widthRemainingForCellContent = collectionView.bounds.width
//        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
//            let borderSize: CGFloat = flowLayout.sectionInset.left + flowLayout.sectionInset.right
//            widthRemainingForCellContent -= borderSize + ((cellsAcross - 1) * flowLayout.minimumInteritemSpacing)
//        }
//        let cellWidth = widthRemainingForCellContent / cellsAcross
//        return CGSize(width: cellWidth, height: cellWidth)
//        //return CGSize(width: 90, height: 90)
//    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfCell: CGFloat = 4   //you need to give a type as CGFloat
        let cellWidth = UIScreen.main.bounds.size.width / numberOfCell
        return CGSize(width:cellWidth, height:cellWidth)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let itemsPerRow:CGFloat = 3
//        let hardCodedPadding:CGFloat = 5
//        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
//        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
//        return CGSize(width: itemWidth, height: itemHeight)
//    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
