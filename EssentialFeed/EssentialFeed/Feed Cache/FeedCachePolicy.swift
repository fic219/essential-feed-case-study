//
// Created by Mate Csengeri on 2022. 01. 14. at Essential Developer
// Copyright © 2022. Essential Developer. All rights reserved.
//
	

import Foundation

internal final class FeedCachePolicy {
    private init() {}
    private static let calendar = Calendar(identifier: .gregorian)
    
    private static let maxCacheAgeInDays = 7
    
    internal static func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        return date < maxCacheAge
    }
}
