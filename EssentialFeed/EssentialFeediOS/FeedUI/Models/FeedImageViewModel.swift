//
// Created by Mate Csengeri on 2022. 02. 06. at Essential Developer
// Copyright © 2022. Essential Developer. All rights reserved.
//
	

import Foundation
import EssentialFeed

final class FeedImageViewModel<Image> {
    
    typealias Observer<T> = (T) -> Void
    
    private let imageTransformer: (Data) -> Image?
    
    private let model: FeedImage
    private let imageLoader: FeedImageDataLoader
    private var task: FeedImageDataLoaderTask?
    
    init(model: FeedImage, imageLoader: FeedImageDataLoader, imageTransformer: @escaping (Data) -> Image?) {
        self.model = model
        self.imageLoader = imageLoader
        self.imageTransformer = imageTransformer
    }
    
    var hasLocation: Bool {
        return model.location != nil
    }
    
    var location: String? {
        return model.location
    }
    
    var description: String? {
        return model.description
    }
    
    func preload() {
        task = self.imageLoader.loadImageData(from: self.model.url) { result in }
    }
    
    func cancel() {
        task?.cancel()
    }
    
    var onLoadStateChange: Observer<Bool>?
    var onShowRetyStatChange: Observer<Bool>?
    var onImageLoad: Observer<Image?>?
    
    func loadImage() {
        onLoadStateChange?(true)
        onShowRetyStatChange?(false)
        self.task = imageLoader.loadImageData(from: model.url) { [weak self] result in
            guard let self = self else { return }
            self.onLoadStateChange?(false)
            let data = try? result.get()
            let image = data.map(self.imageTransformer) ?? nil
            self.onShowRetyStatChange?(image == nil)
            self.onImageLoad?(image)
        }
    }
}
