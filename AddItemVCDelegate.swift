//
//  AddItemVCDelegate.swift
//  beastListExam
//
//  Created by Josh Harsono on 3/23/18.
//  Copyright © 2018 Josh Harsono. All rights reserved.
//

import UIKit


protocol AddItemVCDelegate: class {
    func itemSaved(by controller: AddItemVC, with text: String, at indexPath: NSIndexPath?)
    
    func cancelButtonPressed(by controller: AddItemVC)
}

