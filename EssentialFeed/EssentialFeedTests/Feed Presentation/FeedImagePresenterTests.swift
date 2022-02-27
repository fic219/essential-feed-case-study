//
// Created by Mate Csengeri on 2022. 02. 26. at Essential Developer
// Copyright © 2022. Essential Developer. All rights reserved.
//
	

import XCTest
import EssentialFeed

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

protocol FeedImageView {
    associatedtype Image
    func display(_ model: FeedImageViewModel<Image>)
}

class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image {
    func didStartLoadingImageData(for model: FeedImage) {
        view.display(FeedImageViewModel(
            description: model.description,
            location: model.location,
            image: nil,
            isLoading: true,
            shouldRetry: false))
    }
    
    func didFinishLoadingImageData(with error: Error, for model: FeedImage) {
        view.display(FeedImageViewModel(
            description: model.description,
            location: model.location,
            image: nil,
            isLoading: false,
            shouldRetry: true))
    }
    
    func didFinishLoadingImageData(with data: Data, for model: FeedImage) {
        guard let image = imageTransformer(data) else {
            return didFinishLoadingImageData(with: InvalidImageDataError(), for: model)
        }
        
        view.display(FeedImageViewModel(
            description: model.description,
            location: model.location,
            image: image,
            isLoading: false,
            shouldRetry: false))
    }
    
    private let view: View
    private let imageTransformer: (Data) -> Image?
    private struct InvalidImageDataError: Error {}
    init(view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransformer = imageTransformer
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
    
    func test_displaysRetryWhenImageLoadingFailed() {
        let (sut, view) = makeSut()
        
        let feedImage = uniqueImage()
        
        sut.didFinishLoadingImageData(with: anyNSError(), for: feedImage)
        
        let viewModel = view.messages.first
        
        XCTAssertEqual(viewModel?.isLoading, false)
        XCTAssertEqual(viewModel?.description, feedImage.description)
        XCTAssertEqual(viewModel?.location, feedImage.location)
        XCTAssertEqual(viewModel?.shouldRetry, true)
        XCTAssertNil(viewModel?.image)
        
    }
    
    func test_failingImageTransformationDisplaysRety() {
        let (sut, view) = makeSut(imageTransformer: fail)
        
        let feedImage = uniqueImage()
        
        sut.didFinishLoadingImageData(with: Data(), for: feedImage)
        
        let viewModel = view.messages.first
        
        XCTAssertEqual(viewModel?.isLoading, false)
        XCTAssertEqual(viewModel?.description, feedImage.description)
        XCTAssertEqual(viewModel?.location, feedImage.location)
        XCTAssertEqual(viewModel?.shouldRetry, true)
        XCTAssertNil(viewModel?.image)
    }
    
    func test_displayImageOnSuccessfulImageLoafing() {
        let transformedData = AnyImage()
        let (sut, view) = makeSut(imageTransformer: { _ in return transformedData})
        
        let feedImage = uniqueImage()
        sut.didFinishLoadingImageData(with: Data(), for: feedImage)
        
        let viewModel = view.messages.first
        
        XCTAssertEqual(viewModel?.isLoading, false)
        XCTAssertEqual(viewModel?.description, feedImage.description)
        XCTAssertEqual(viewModel?.location, feedImage.location)
        XCTAssertEqual(viewModel?.shouldRetry, false)
        XCTAssertEqual(viewModel?.image, transformedData)
        
    }
    
    private struct AnyImage: Equatable {}
    
    
    private func makeSut(imageTransformer: @escaping (Data) -> AnyImage? = { _ in return nil}, file: StaticString = #file, line: UInt = #line) -> (sut: FeedImagePresenter<ViewSpy, AnyImage>, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedImagePresenter(view: view, imageTransformer: imageTransformer)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
    
    private var fail: (Data) -> AnyImage? {
        return { _ in nil }
    }
    
    private class ViewSpy: FeedImageView {
        func display(_ model: FeedImageViewModel<AnyImage>) {
            messages.append(model)
        }
        
        
        private(set) var messages = [FeedImageViewModel<AnyImage>]()
    }
}
