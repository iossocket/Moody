//
//  DetailViewController.swift
//  Moody
//
//  Created by XueliangZhu on 11/30/16.
//  Copyright © 2016 ThoughtWorks. All rights reserved.
//

import UIKit

class MoodDetailViewController: UIViewController {

    var mood: Mood!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func deleteMood(_ sender: Any) {
        mood.managedObjectContext?.performChanges { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.mood.managedObjectContext?.delete(strongSelf.mood)
            _ = strongSelf.navigationController?.popViewController(animated: true)
        }
    }
}
