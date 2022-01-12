//
// Created by Mate Csengeri on 2022. 01. 12. at Essential Developer
// Copyright © 2022. Essential Developer. All rights reserved.
//
	

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}
