//
//  CollectionViewController.swift
//  SJSegmentedScrollViewDemo
//
//  Created by Subins on 12/10/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

private let reuseIdentifier = "CollectionCellIdentifier"

class CollectionViewController: UICollectionViewController {

	let colors = [UIColor.red, UIColor.gray,
	              UIColor.green,
	              UIColor.yellow,
	              UIColor.orange,
	              UIColor.brown,
	              UIColor.purple]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self,
                                      forCellWithReuseIdentifier: reuseIdentifier)
	}

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return 25
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath)

		let colorIndex = indexPath.row % colors.count
        let color = colors[colorIndex]
		cell.backgroundColor = color
    
        return cell
    }
}

extension CollectionViewController: SJSegmentedViewControllerViewSource {

	public func titleForSegment() -> String? {

		return "Collection View"
	}
}
