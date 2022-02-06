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
    
    var onChange: ((FeedViewModel) -> Void)?
    var onFeedLoad: (([FeedImage]) -> Void)?
    
    private(set) var isLoading: Bool = false {
        didSet {
            onChange?(self)
        }
    }
    
    func loadFeed() {
        isLoading = true
        feedLoader?.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.onFeedLoad?(feed)
            case .failure:
                break
            }
            self?.isLoading = false
            
        }
        
        
    }
}
