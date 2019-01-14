//
//  QRCameraPreviewView.swift
//  RecordAndUpload
//
//  Created by Chrystian Salgado on 10/01/2019.
//  Copyright © 2019 Qranio.com. All rights reserved.
//

import UIKit
import AVFoundation

public enum QRCameraVideoGravity {

    /**
     - Specifies that the video should be stretched to fill the layer’s bounds
     - Corrsponds to `AVLayerVideoGravityResize`
    */
    case resize
    /**
     - Specifies that the player should preserve the video’s aspect ratio and fit the video within the layer’s bounds.
     - Corresponds to `AVLayerVideoGravityResizeAspect`
     */
    case resizeAspect
    /**
     - Specifies that the player should preserve the video’s aspect ratio and fill the layer’s bounds.
     - Correponds to `AVLayerVideoGravityResizeAspectFill`
    */
    case resizeAspectFill
}

class QRCameraPreviewView: UIView {
    
    private var gravity: QRCameraVideoGravity = .resizeAspect
    
    init(frame: CGRect, videoGravity: QRCameraVideoGravity) {
        gravity = videoGravity
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
	var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        let previewlayer = layer as! AVCaptureVideoPreviewLayer
        switch gravity {
        case .resize:
            previewlayer.videoGravity = AVLayerVideoGravity.resize
        case .resizeAspect:
            previewlayer.videoGravity = AVLayerVideoGravity.resizeAspect
        case .resizeAspectFill:
            previewlayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        }
		return previewlayer
	}
	
	var session: AVCaptureSession? {
		get {
			return videoPreviewLayer.session
		}
		set {
			videoPreviewLayer.session = newValue
		}
	}
	
	// MARK: UIView
	
	override class var layerClass : AnyClass {
		return AVCaptureVideoPreviewLayer.self
	}
}
