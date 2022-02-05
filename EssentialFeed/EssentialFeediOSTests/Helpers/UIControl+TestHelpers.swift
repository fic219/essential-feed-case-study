//
// Created by Mate Csengeri on 2022. 02. 05. at Essential Developer
// Copyright © 2022. Essential Developer. All rights reserved.
//
	

import UIKit

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
