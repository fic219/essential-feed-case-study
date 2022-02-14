//
// Created by Mate Csengeri on 2022. 02. 06. at Essential Developer
// Copyright © 2022. Essential Developer. All rights reserved.
//
	

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool
    
    var hasLocation: Bool {
        return location != nil
    }
}
