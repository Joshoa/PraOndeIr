//
//  NoPlaceStackView.swift
//  PraOndeIr
//
//  Created by Marcos Joshoa on 29/02/20.
//  Copyright © 2020 Marcos Joshoa. All rights reserved.
//

import UIKit

class NoPlaceStackView: UIStackView {
    @IBOutlet weak var lbText: UILabel!
    
    public func setText(_ text: String) {
        lbText.text = text
    }
    
    public class func initializeFromNib() -> NoPlaceStackView {
       return UINib(nibName: "NoPlaceStackView", bundle: nil).instantiate(withOwner: self, options: nil).first as! NoPlaceStackView
    }
}
