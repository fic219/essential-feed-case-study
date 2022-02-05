//
// Created by Mate Csengeri on 2022. 02. 05. at Essential Developer
// Copyright © 2022. Essential Developer. All rights reserved.
//
	

import UIKit

extension UIRefreshControl {
    func simulatePullToRefresh() {
        simulate(event: .valueChanged)
    }
}
