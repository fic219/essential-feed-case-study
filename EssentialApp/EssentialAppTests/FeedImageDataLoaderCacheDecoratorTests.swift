//
// Created by Mate Csengeri on 2022. 03. 07. at Essential Developer
// Copyright © 2022. Essential Developer. All rights reserved.
//
	

import XCTest
import EssentialFeed

class FeedImageDataLoaderCacheDecorator: FeedImageDataLoader {
    
    private let decoratee: FeedImageDataLoader
    private let cache: FeedImageDataCache
    
    init(decoratee: FeedImageDataLoader, cache: FeedImageDataCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        return decoratee.loadImageData(from: url) { [weak self] result in
            switch result {
            case let .success(data):
                self?.cache.save(data, for: url) { _ in }
                completion(result)
            case .failure:
                completion(result)
            }
        }
    }
    
    
}

class FeedImageDataLoaderCacheDecoratorTests: XCTestCase {

    func test_init_doesNotLoad() {
        let (_, loader) = makeSut()
        
        XCTAssertEqual(loader.loadedURLs, [])
    }
    
    func test_load_loadsFromURL() {
        
        let url = anyURL()
        
        let (sut, loader) = makeSut()
        
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(loader.loadedURLs, [url])
        
    }
    
    func test_cancelLoadImageData_cancelsLoaderTask() {
        
        let url = anyURL()
        
        let (sut, loader) = makeSut()
        
        let task = sut.loadImageData(from: anyURL(), completion: { _ in })
        
        task.cancel()
        
        XCTAssertEqual(loader.cancelledURLs, [url])
    }
    
    func test_load_deliversImageDataOnLoaderSuccess() {
        
        let imagedata = anyData()
        
        let (sut, loader) = makeSut()
        
        expect(sut, toCompleteWith: .success(imagedata)) {
            loader.complete(with: imagedata)
        }
    }
    
    func test_loadImageData_deliversErrorOnLoaderFailure() {
        let error = anyNSError()
        
        let (sut, loader) = makeSut()
        
        expect(sut, toCompleteWith: .failure(error)) {
            loader.complete(with: error)
        }
    }
    
    func test_loadImageData_cacheReceivesSaveOnSuccesLoad() {
        
        let url = anyURL()
        let data = anyData()
        let loader = LoaderSpy()
        let cache = CacheSpy()
        let sut = FeedImageDataLoaderCacheDecorator(decoratee: loader, cache: cache)
        
        _ = sut.loadImageData(from: url, completion: { _ in })
        loader.complete(with: data)
        
        XCTAssertEqual(cache.receivedMessages, [.save(url: url, data: data)])
    }
    
    private func makeSut(file: StaticString = #file, line: UInt = #line) -> (sut: FeedImageDataLoaderCacheDecorator, loader: LoaderSpy) {
        let decoratee = LoaderSpy()
        let cache = CacheSpy()
        let sut = FeedImageDataLoaderCacheDecorator(decoratee: decoratee, cache: cache)
        trackForMemoryLeaks(decoratee, file: file, line: line)
        trackForMemoryLeaks(cache, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, decoratee)
    }
    
    private func expect(_ sut: FeedImageDataLoader, toCompleteWith expectedResult: FeedImageDataLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        _ = sut.loadImageData(from: anyURL()) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedFeed), .success(expectedFeed)):
                XCTAssertEqual(receivedFeed, expectedFeed, file: file, line: line)
                
            case (.failure, .failure):
                break
                
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private class LoaderSpy: FeedImageDataLoader {
        private var messages = [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)]()

        private(set) var cancelledURLs = [URL]()

        var loadedURLs: [URL] {
            return messages.map { $0.url }
        }

        private struct Task: FeedImageDataLoaderTask {
            let callback: () -> Void
            func cancel() { callback() }
        }

        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
            messages.append((url, completion))
            return Task { [weak self] in
                self?.cancelledURLs.append(url)
            }
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(with data: Data, at index: Int = 0) {
            messages[index].completion(.success(data))
        }
    }
    
    private class CacheSpy: FeedImageDataCache {
        
        private(set) var receivedMessages = [Message]()
        
        enum Message: Equatable {
            case save(url: URL, data: Data)
        }
        
        func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void) {
            receivedMessages.append(.save(url: url, data: data))
        }
        
        
    }

}
