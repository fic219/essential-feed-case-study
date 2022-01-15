//
// Created by Mate Csengeri on 2022. 01. 09. at Essential Developer
// Copyright © 2022. Essential Developer. All rights reserved.
//
	

import Foundation

public struct LocalFeedImage: Equatable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let url: URL
    
    public init(id: UUID, description: String?, location: String?, url: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.url = url
    }
}
