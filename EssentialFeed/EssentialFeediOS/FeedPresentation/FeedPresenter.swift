//
// Created by Mate Csengeri on 2022. 02. 07. at Essential Developer
// Copyright © 2022. Essential Developer. All rights reserved.
//
	

import Foundation
import EssentialFeed

struct FeedViewModel {
    let feed: [FeedImage]
}

protocol FeedView {
    func display(viewModel: FeedViewModel)
}

struct FeedLoadingViewModel {
    let isLoading: Bool
}

protocol FeedLoadingView {
    func display(viewModel: FeedLoadingViewModel)
}

final class FeedPresenter {
    
    typealias Observer<T> = (T) -> Void
    
    private var feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var feedView: FeedView?
    var loadingView: FeedLoadingView?
    
    func loadFeed() {
        loadingView?.display(viewModel: FeedLoadingViewModel(isLoading: true))
        feedLoader.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.feedView?.display(viewModel: FeedViewModel(feed: feed))
            case .failure:
                break
            }
            self?.loadingView?.display(viewModel: FeedLoadingViewModel(isLoading: false))
        }
    }
}
