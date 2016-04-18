//
//  BubbleCell.swift
//  BubblUp
//
//  Created by Suyeon Kang on 4/14/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit

class BubbleCell: UICollectionViewCell {
    @IBOutlet weak var bubbleLabel: UILabel!
    @IBOutlet weak var typeImage: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = self.frame.height / 2
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
}
