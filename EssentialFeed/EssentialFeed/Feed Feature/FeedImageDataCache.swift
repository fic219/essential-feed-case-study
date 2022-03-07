//
// Created by Mate Csengeri on 2022. 03. 07. at Essential Developer
// Copyright © 2022. Essential Developer. All rights reserved.
//
	

import Foundation


public protocol FeedImageDataCache {
    typealias SaveResult = Result<Void, Error>
    
    func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void)
}
