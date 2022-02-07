//
// Created by Mate Csengeri on 2022. 02. 07. at Essential Developer
// Copyright © 2022. Essential Developer. All rights reserved.
//
	

import Foundation
import EssentialFeed

protocol FeedView {
    func display(feed: [FeedImage])
}

protocol FeedLoadingView: AnyObject {
    func display(isLoading: Bool)
}

final class FeedPresenter {
    
    typealias Observer<T> = (T) -> Void
    
    private var feedLoader: FeedLoader?
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var feedView: FeedView?
    weak var loadingView: FeedLoadingView?
    
    func loadFeed() {
        loadingView?.display(isLoading: true)
        feedLoader?.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.feedView?.display(feed: feed)
            case .failure:
                break
            }
            self?.loadingView?.display(isLoading: false)
        }
    }
}
