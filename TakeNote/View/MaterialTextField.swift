//
//  MaterialTextField.swift
//  TakeNote
//
//  Created by Chris Cosentino on 2018-08-01.
//  Copyright © 2018 Chris Cosentino. All rights reserved.
//

import UIKit

class MaterialTextField: UITextField {

    override func awakeFromNib() {
        self.layer.cornerRadius = 5.0
        self.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
    }

}
