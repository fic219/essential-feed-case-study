//
// Created by Mate Csengeri on 2022. 02. 05. at Essential Developer
// Copyright © 2022. Essential Developer. All rights reserved.
//
	

import UIKit
import EssentialFeed

final class FeedRefreshViewController: NSObject {
    
    private var feedLoader: FeedLoader?
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    private(set) lazy var view: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()
    
    @objc func refresh() {
        view.beginRefreshing()
        feedLoader?.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.onRefresh?(feed)
                
            case .failure:
                break
            }
            self?.view.endRefreshing()
        }
    }
    var onRefresh: (([FeedImage]) -> Void)?
}
