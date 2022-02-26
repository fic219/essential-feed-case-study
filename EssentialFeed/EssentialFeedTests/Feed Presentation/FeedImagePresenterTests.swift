//
// Created by Mate Csengeri on 2022. 02. 26. at Essential Developer
// Copyright © 2022. Essential Developer. All rights reserved.
//
	

import XCTest

class FeedImagePresenter {
    init(view: Any) {
        
    }
}

class FeedImagePresenterTests: XCTestCase {
    
    func test_init_doesNotSentMessageToView() {
        let view = ViewSpy()
        let _ = FeedImagePresenter(view: view)
        XCTAssertTrue(view.messages.isEmpty, "Excepted no view message")
    }
    
    private class ViewSpy {
        let messages = [Any]()
    }
}
