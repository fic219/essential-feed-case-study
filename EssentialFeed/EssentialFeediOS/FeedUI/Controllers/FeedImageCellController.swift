//
// Created by Mate Csengeri on 2022. 02. 05. at Essential Developer
// Copyright © 2022. Essential Developer. All rights reserved.
//
	

import UIKit
import EssentialFeed

final class FeedImageCellController {
    
    private let viewModel: FeedImageViewModel<UIImage>
    
    init(viewModel: FeedImageViewModel<UIImage>) {
        self.viewModel = viewModel
    }
    
    func view() -> UITableViewCell {
        let cell = binded(FeedImageCell())
        viewModel.loadImage()
        return cell
    }
    
    func preload() {
        viewModel.preload()
    }
    
    func cancelLoad() {
        viewModel.cancel()
    }
    
    private func binded(_ cell: FeedImageCell) -> FeedImageCell{
        cell.locationContainer.isHidden = !viewModel.hasLocation
        cell.locationLabel.text = viewModel.location
        cell.descriptionLabel.text = viewModel.description
        cell.onRetry = viewModel.loadImage
        
        viewModel.onImageLoad = { [weak cell] image in
            cell?.feedImageView.image = image
        }
        
        viewModel.onLoadStateChange = { [weak cell]  isLoading in
            cell?.feedImageContainer.isShimmering = isLoading
        }
        
        viewModel.onShowRetyStatChange = { [weak cell] showRetry in
            cell?.feedImageRetryButton.isHidden = !showRetry
        }
        
        return cell
    }
}
