//
//  CustomBorder.swift
//  mockup_SketchBot
//
//  Created by Gimin Moon on 4/21/18.
//  Copyright © 2018 Dorothy Peng. All rights reserved.
//

import UIKit

class CustomBorder: UIView {


    @IBOutlet var fullContentView: CustomBorder!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("MyCustomView", owner: self, options: nil)
        addSubview(fullContentView)
        fullContentView.frame = self.bounds
        fullContentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
