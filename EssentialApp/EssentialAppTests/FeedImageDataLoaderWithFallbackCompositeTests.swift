//
// Created by Mate Csengeri on 2022. 03. 04. at Essential Developer
// Copyright © 2022. Essential Developer. All rights reserved.
//
	

import XCTest
import EssentialFeed

class FeedImageDataLoaderWithFallbackComposite: FeedImageDataLoader {
    
    struct FeedImageCompositeTask: FeedImageDataLoaderTask {
        
        func cancel() {
            
        }
    }
    
    private let primaryLoader: FeedImageDataLoader
    private let fallbackLoader: FeedImageDataLoader
    
    init(primaryLoader: FeedImageDataLoader, fallbackLoader: FeedImageDataLoader) {
        self.primaryLoader = primaryLoader
        self.fallbackLoader = fallbackLoader
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = primaryLoader.loadImageData(from: url) { [weak self] result in
            switch result {
            case let .success(feedImageData):
                completion(.success(feedImageData))
            case .failure:
                let _ = self?.fallbackLoader.loadImageData(from: url, completion: completion)
            }
        }
        return task
    }
    
    
}

class FeedImageDataLoaderWithFallbackCompositeTests: XCTestCase {

    func test_initDoesNotLoadAnything() {
        let (primaryLoader, fallbackLoader, _) = makeSut()
        
        XCTAssert(primaryLoader.loadedURLs.isEmpty)
        XCTAssert(fallbackLoader.loadedURLs.isEmpty)
    }
    
    func test_returnImageOnPrimaryLoadSuccess() {
        let (primaryLoader, _, sut) = makeSut()
        
        let expectedData = anyData()
        let exp = expectation(description: "Wait for load completion")
        let _ = sut.loadImageData(from: anyURL()) { result in
            switch result {
            case let .success(receivedData):
                XCTAssertEqual(receivedData, expectedData)
            case .failure:
                XCTFail("Expected to success")
            }
            exp.fulfill()
        }
        primaryLoader.complete(with: expectedData)
        wait(for: [exp], timeout: 1)
        
    }
    
    func test_returnResultOfFallbackLoaderOnPrimaryLoadFails() {
        let (primaryLoader, fallbackLoader, sut) = makeSut()
        
        let expectedData = anyData()
        let exp = expectation(description: "Wait for load completion")
        let _ = sut.loadImageData(from: anyURL()) { result in
            switch result {
            case let .success(receivedData):
                XCTAssertEqual(receivedData, expectedData)
            case .failure:
                XCTFail("Expected to success")
            }
            exp.fulfill()
        }
        primaryLoader.complete(with: anyNSError())
        fallbackLoader.complete(with: expectedData)
        wait(for: [exp], timeout: 1)
    }
    
    func test_returnErrorOnPrimaryAndFallbackLoadersBothFail() {
        let (primaryLoader, fallbackLoader, sut) = makeSut()
        
        let expectedError = anyNSError()
        let exp = expectation(description: "Wait for load completion")
        let _ = sut.loadImageData(from: anyURL()) { result in
            switch result {
            case .success:
                XCTFail("Expected to fail")
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError, expectedError)
            }
            exp.fulfill()
        }
        primaryLoader.complete(with: anyNSError())
        fallbackLoader.complete(with: expectedError)
        wait(for: [exp], timeout: 1)
    }
    
    private func makeSut(file: StaticString = #file, line: UInt = #line) -> (primaryLoader: LoaderSpy, fallbackLoader: LoaderSpy, sut: FeedImageDataLoaderWithFallbackComposite) {
        let primaryLoader = LoaderSpy()
        let fallbackLoader = LoaderSpy()
        let sut = FeedImageDataLoaderWithFallbackComposite(primaryLoader: primaryLoader, fallbackLoader: fallbackLoader)
        trackForMemoryLeaks(primaryLoader)
        trackForMemoryLeaks(fallbackLoader)
        trackForMemoryLeaks(sut)
        return (primaryLoader, fallbackLoader, sut)
    }
    
    private class LoaderSpy: FeedImageDataLoader {
        
        var messages = [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)]()
        
        var loadedURLs: [URL] {
            return messages.map { $0.url}
        }
        
        struct FeedImageCompositeTask: FeedImageDataLoaderTask {
            func cancel() {
                
            }
        }
        
        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
            messages.append((url, completion))
            return FeedImageCompositeTask()
        }
        
        func complete(with data: Data) {
            messages.first?.completion(.success(data))
        }
        
        func complete(with error: Error) {
            messages.first?.completion(.failure(error))
        }
        
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
    
    func anyData() -> Data {
        return Data("any data".utf8)
    }
    
    func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }

}
