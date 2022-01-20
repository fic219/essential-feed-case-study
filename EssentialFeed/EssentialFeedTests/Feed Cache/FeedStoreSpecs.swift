//
// Created by Mate Csengeri on 2022. 01. 20. at Essential Developer
// Copyright © 2022. Essential Developer. All rights reserved.
//
	

import Foundation

protocol FeedStoreSpecs {
    
    func test_retrieve_deliversEmptyOnEmptyCache()
    func test_retrieve_hasNoSideEffectsOnEmptyCache()
    func test_retrieve_deliversFoundValueOfNonEmptyCache()
    func test_retrieve_hasNoSedeEffectsOnNonEmptyCache()
    
    func test_insert_overridesPreviouslyInsertedCache()
    func test_insert_deliversNoErrorOnEmptyCache()
    func test_insert_deliversNoErrorOnNonEmptyCache()
    
    func test_delete_hasNoSideEffectOnEmptyCache()
    func test_delete_deliversNoErrorOnEmptyCache()
    func test_delete_emptiesPreviouslyInsertedCache()
    func test_delete_deliversNoErrorOnNonEmptyCache()

    func test_storeSideEffects_runSerially()
}

protocol FailableRetrieveFeedStoreSpecs: FeedStoreSpecs {
    func test_retrieve_deliversFailureOnRetrievalError()
    func test_retrieve_hasNoSideEffectsOnFailure()
}

protocol FailableInsertFeedStoreSpecs: FeedStoreSpecs {
    func test_insert_deliversErrorOnInsertionError()
    func test_insert_hasNoSideEffectOnInsertionError()
}

protocol FailableDeleteFeedStoreSpecs: FeedStoreSpecs {
    func test_delete_deliversErrorOnDeletionError()
    func test_delete_hasNoSideEffectsOnDeletionError()
}

typealias FailableFeedStoreSpecs = FailableRetrieveFeedStoreSpecs & FailableInsertFeedStoreSpecs & FailableDeleteFeedStoreSpecs
