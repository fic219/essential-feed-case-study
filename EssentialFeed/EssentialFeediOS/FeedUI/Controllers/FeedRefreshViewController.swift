//
// Created by Mate Csengeri on 2022. 02. 05. at Essential Developer
// Copyright © 2022. Essential Developer. All rights reserved.
//
	

import UIKit

final class FeedRefreshViewController: NSObject {
    
     private(set) lazy var view = bind(UIRefreshControl())
    
    private let viewModel: FeedViewModel
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }
    
    @objc func refresh() {
        viewModel.loadFeed()
    }
    
    private func bind(_ view: UIRefreshControl) -> UIRefreshControl {
        viewModel.onChange = { viewModel in
            if viewModel.isLoading {
                view.beginRefreshing()
            } else {
                view.endRefreshing()
            }
        }
        
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
