//
//  FetchViewController.swift
//  TheBackgrounder
//
//  Created by Ray Fix on 12/9/14.
//  Copyright (c) 2014 Razeware, LLC. All rights reserved.
//

import UIKit

// MARK: - Properties & Interface Builder
class FetchViewController: UIViewController {
    
    var time: Date?
    
    @IBOutlet weak var updateLabel: UILabel?
    
    @IBAction func didTapUpdate(_ sender: UIButton) {
        fetch { self.updateUI() }
    }
}

// MARK: - Lifecycle
extension FetchViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
}

// MARK: - Utility Methods
extension FetchViewController {
    
    func fetch(completion: () -> Void) {
        time = Date()
        completion()
    }
    
    func updateUI() {
        if let time = time {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .long
            updateLabel?.text = formatter.string(from: time)
        }
        else {
            updateLabel?.text = "Not yet updated"
        }
    }
}
