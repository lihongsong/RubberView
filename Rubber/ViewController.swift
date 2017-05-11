//
//  ViewController.swift
//  Rubber
//
//  Created by 李泓松 on 2017/5/10.
//  Copyright © 2017年 yoser. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var rubberView: RubberView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rubberView.sourceImage = UIImage(named: "AAA.jpg")
        self.rubberView.clearRadius = 10
        
        self.view.backgroundColor = UIColor.yellow
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

