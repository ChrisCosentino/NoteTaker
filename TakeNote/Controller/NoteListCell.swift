//
//  NoteListCell.swift
//  TakeNote
//
//  Created by Chris Cosentino on 2018-07-30.
//  Copyright © 2018 Chris Cosentino. All rights reserved.
//

import UIKit

class NoteListCell: UITableViewCell {

    @IBOutlet weak var noteTitleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
