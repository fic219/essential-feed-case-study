//
// Created by Mate Csengeri on 2022. 02. 06. at Essential Developer
// Copyright © 2022. Essential Developer. All rights reserved.
//
	

import Foundation
import EssentialFeed

final class FeedViewModel {
    
    typealias Observer<T> = (T) -> Void
    
    private var feedLoader: FeedLoader?
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var onLoadingStateChange: Observer<Bool>?
    var onFeedLoad: Observer<[FeedImage]>?
    
    func loadFeed() {
        onLoadingStateChange?(true)
        feedLoader?.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.onFeedLoad?(feed)
            case .failure:
                break
            }
            self?.onLoadingStateChange?(false)
        }
    }
}
