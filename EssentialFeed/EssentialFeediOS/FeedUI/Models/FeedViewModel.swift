//
// Created by Mate Csengeri on 2022. 02. 06. at Essential Developer
// Copyright © 2022. Essential Developer. All rights reserved.
//
	

import Foundation
import EssentialFeed

final class FeedViewModel {
    private var feedLoader: FeedLoader?
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    private enum State {
        case pending
        case loading
        case loaded([FeedImage])
        case failed
    }
    
    private var state = State.pending {
        didSet {
            onChange?(self)
        }
    }
    
    var onChange: ((FeedViewModel) -> Void)?
    
    var isLoading: Bool {
        switch state {
        case .loading:
            return true
        case .pending, .loaded, .failed:
            return false
        }
    }
    
    var feed: [FeedImage]? {
        switch state {
        case let .loaded(feed):
            return feed
        case .pending, .loading, .failed:
            return nil
        }
    }
    
    func loadFeed() {
        state = .loading
        feedLoader?.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.state = .loaded(feed)
            case .failure:
                self?.state = .failed
            }
        }
    }
}
