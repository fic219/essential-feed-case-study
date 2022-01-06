//
// Created by Mate Csengeri on 2022. 01. 06. at Essential Developer
// Copyright © 2022. Essential Developer. All rights reserved.
//
	

import XCTest

class LocalFeedLoader {
    init(store: FeedStore) {
        
    }
}

class FeedStore {
    var deleteCachedFeedItemCount = 0
}

class CacheFeedUseCaseTests: XCTestCase {

    func test_init_doesNotDeleteCacheUponCreation() {
        let store = FeedStore()
        _ = LocalFeedLoader(store: store)
        XCTAssertEqual(store.deleteCachedFeedItemCount, 0)
    }

}
