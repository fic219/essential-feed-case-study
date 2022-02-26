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
        
        let (_, view) = makeSut()
        
        XCTAssertTrue(view.messages.isEmpty, "Excepted no view message")
    }
    
    private func makeSut(file: StaticString = #file, line: UInt = #line) -> (sut: FeedImagePresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedImagePresenter(view: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
    
    private class ViewSpy {
        let messages = [Any]()
    }
}
