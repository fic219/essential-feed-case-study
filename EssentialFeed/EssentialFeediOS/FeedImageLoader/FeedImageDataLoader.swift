//
// Created by Mate Csengeri on 2022. 02. 05. at Essential Developer
// Copyright © 2022. Essential Developer. All rights reserved.
//
	

import Foundation

public protocol FeedImageDataLoaderTask {
    func cancel()
}

public protocol FeedImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> FeedImageDataLoaderTask
}
