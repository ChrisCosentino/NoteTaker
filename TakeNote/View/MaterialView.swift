//
//  MaterialView.swift
//  TakeNote
//
//  Created by Chris Cosentino on 2018-08-01.
//  Copyright © 2018 Chris Cosentino. All rights reserved.
//

import UIKit

class MaterialView: UIView {

    override func awakeFromNib() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 5
        self.layer.cornerRadius = 2.0
    }
}
