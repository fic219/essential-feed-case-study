//
// Created by Mate Csengeri on 2022. 01. 09. at Essential Developer
// Copyright © 2022. Essential Developer. All rights reserved.
//
	

import Foundation

internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL
}
