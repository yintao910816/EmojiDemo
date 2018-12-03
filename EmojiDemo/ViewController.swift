//
//  ViewController.swift
//  EmojiDemo
//
//  Created by sw on 02/12/2018.
//  Copyright © 2018 sw. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var inputTextView: InputBoxView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        inputTextView.placeholder = "评论"
        inputTextView.textFont = 15
        
        inputTextView.actionDelegate = self
    }

}

extension ViewController: InputBoxViewDelegate {
    
    func send(input content: String) {
        print(content)
    }
}

