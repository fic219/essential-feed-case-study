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
    
    private let feedView: FeedView
    private let loadingView: FeedLoadingView
    
    init(feedView: FeedView, loadingView: FeedLoadingView) {
            self.feedView = feedView
            self.loadingView = loadingView
        }
    
    func didStartLoadingFeed() {
        loadingView.display(viewModel: FeedLoadingViewModel(isLoading: true))
    }
    
    func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(viewModel: FeedViewModel(feed: feed))
        loadingView.display(viewModel: FeedLoadingViewModel(isLoading: false))
    }
    
    func didFinishLoadingFeed(with error: Error) {
        loadingView.display(viewModel: FeedLoadingViewModel(isLoading: false))
    }
}
