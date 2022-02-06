//
// Created by Mate Csengeri on 2022. 02. 05. at Essential Developer
// Copyright © 2022. Essential Developer. All rights reserved.
//
	

import UIKit
import EssentialFeed

final class FeedImageCellController {
    
    private let viewModel: FeedImageViewModel
    
    init(viewModel: FeedImageViewModel) {
        self.viewModel = viewModel
    }
    
    func view() -> UITableViewCell {
        let cell = FeedImageCell()
        bind(cell)
        cell.locationContainer.isHidden = !viewModel.hasLocation
        cell.locationLabel.text = viewModel.location
        cell.descriptionLabel.text = viewModel.description
        
        cell.onRetry = viewModel.loadImage
        viewModel.loadImage()
        
        return cell
    }
    
    func preload() {
        viewModel.preload()
    }
    
    func cancelLoad() {
        viewModel.cancel()
    }
    
    private func bind(_ cell: FeedImageCell) {
        viewModel.onImageLoad = { [weak cell] image in
            cell?.feedImageView.image = image
            
        }
        
        viewModel.onLoadStateChange = { [weak cell]  isLoading in
            if isLoading {
                cell?.feedImageView.image = nil
                cell?.feedImageContainer.startShimmering()
            } else {
                cell?.feedImageContainer.stopShimmering()
            }
        }
        
        viewModel.onShowRetyStatChange = { [weak cell] showRetry in
            cell?.feedImageRetryButton.isHidden = !showRetry
        }
    }
}
