//
// Created by Mate Csengeri on 2022. 02. 26. at Essential Developer
// Copyright © 2022. Essential Developer. All rights reserved.
//
	

import XCTest
import EssentialFeed

struct FeedImageViewModel {
    let description: String?
    let location: String?
    let image: Any?
    let isLoading: Bool
    let shouldRetry: Bool
    
    var hasLocation: Bool {
        return location != nil
    }
}

protocol FeedImageView {
    
    func display(_ model: FeedImageViewModel)
}

class FeedImagePresenter {
    func didStartLoadingImageData(for model: FeedImage) {
        view.display(FeedImageViewModel(
            description: model.description,
            location: model.location,
            image: nil,
            isLoading: true,
            shouldRetry: false))
    }
    
    private let view: FeedImageView
    init(view: FeedImageView) {
        self.view = view
    }
}

class FeedImagePresenterTests: XCTestCase {
    
    func test_init_doesNotSentMessageToView() {
        let (_, view) = makeSut()
        
        XCTAssertTrue(view.messages.isEmpty, "Excepted no view message")
    }
    
    func test_startLoadingSendFeedImageDisplayToView() {
        let (sut, view) = makeSut()
        
        let feedImage = uniqueImage()
        sut.didStartLoadingImageData(for: feedImage)
        
        let viewModel = view.messages.first
        
        XCTAssertEqual(viewModel?.isLoading, true)
        XCTAssertEqual(viewModel?.description, feedImage.description)
        XCTAssertEqual(viewModel?.location, feedImage.location)
        XCTAssertEqual(viewModel?.shouldRetry, false)
        XCTAssertNil(viewModel?.image)
    }
    
    
    private func makeSut(file: StaticString = #file, line: UInt = #line) -> (sut: FeedImagePresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedImagePresenter(view: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
    
    
    
    private class ViewSpy: FeedImageView {
        func display(_ model: FeedImageViewModel) {
            messages.append(model)
        }
        
        
        private(set) var messages = [FeedImageViewModel]()
    }
}
