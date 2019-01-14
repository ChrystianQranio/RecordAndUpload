//
//  QRCameraViewControllerDelegate.swift
//  RecordAndUpload
//
//  Created by Chrystian Salgado on 10/01/2019.
//  Copyright © 2019 Qranio.com. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: Public Protocol Declaration

/// Delegate para qrCameraManagerViewController
public protocol QRCameraViewControllerDelegate: class {
    
    /**
     qrCameraManagerViewControllerDelegate function called when when qrCameraManagerViewController session did start running.
     Photos and video capture will be enabled.
     
     - Parameter qrCameraManager: Current qrCameraManagerViewController
     */
    
    func qrCameraManagerSessionDidStartRunning(_ qrCameraManager: QRCameraViewController)
    
    /**
     qrCameraManagerViewControllerDelegate function called when when qrCameraManagerViewController session did stops running.
     Photos and video capture will be disabled.
     
     - Parameter qrCameraManager: Current qrCameraManagerViewController
     */
    
    func qrCameraManagerSessionDidStopRunning(_ qrCameraManager: QRCameraViewController)
    
    /**
     qrCameraManagerViewControllerDelegate function called when the takePhoto() function is called.
     
     - Parameter qrCameraManager: Current qrCameraManagerViewController session
     - Parameter photo: UIImage captured from the current session
     */
    
    func qrCameraManager(_ qrCameraManager: QRCameraViewController, didTake photo: UIImage)
    
    /**
     qrCameraManagerViewControllerDelegate function called when qrCameraManagerViewController begins recording video.
     
     - Parameter qrCameraManager: Current qrCameraManagerViewController session
     - Parameter camera: Current camera orientation
     */
    
    func qrCameraManager(_ qrCameraManager: QRCameraViewController, didBeginRecordingVideo camera: QRCameraViewController.CameraSelection)
    
    /**
     qrCameraManagerViewControllerDelegate function called when qrCameraManagerViewController finishes recording video.
     
     - Parameter qrCameraManager: Current qrCameraManagerViewController session
     - Parameter camera: Current camera orientation
     */
    
    func qrCameraManager(_ qrCameraManager: QRCameraViewController, didFinishRecordingVideo camera: QRCameraViewController.CameraSelection)
    
    /**
     qrCameraManagerViewControllerDelegate function called when qrCameraManagerViewController is done processing video.
     
     - Parameter qrCameraManager: Current qrCameraManagerViewController session
     - Parameter url: URL location of video in temporary directory
     */
    
    func qrCameraManager(_ qrCameraManager: QRCameraViewController, didFinishProcessVideoAt url: URL)
    
    
    /**
     qrCameraManagerViewControllerDelegate function called when qrCameraManagerViewController fails to record a video.
     
     - Parameter qrCameraManager: Current qrCameraManagerViewController session
     - Parameter error: An error object that describes the problem
     */
    func qrCameraManager(_ qrCameraManager: QRCameraViewController, didFailToRecordVideo error: Error)
    
    /**
     qrCameraManagerViewControllerDelegate function called when qrCameraManagerViewController switches between front or rear camera.
     
     - Parameter qrCameraManager: Current qrCameraManagerViewController session
     - Parameter camera: Current camera selection
     */
    
    
    func qrCameraManager(_ qrCameraManager: QRCameraViewController, didSwitchCameras camera: QRCameraViewController.CameraSelection)
    
    /**
     qrCameraManagerViewControllerDelegate function called when qrCameraManagerViewController view is tapped and begins focusing at that point.
     
     - Parameter qrCameraManager: Current qrCameraManagerViewController session
     - Parameter point: Location in view where camera focused
     
     */
    
    func qrCameraManager(_ qrCameraManager: QRCameraViewController, didFocusAtPoint point: CGPoint)
    
    /**
     qrCameraManagerViewControllerDelegate function called when when qrCameraManagerViewController view changes zoom level.
     
     - Parameter qrCameraManager: Current qrCameraManagerViewController session
     - Parameter zoom: Current zoom level
     */
    
    func qrCameraManager(_ qrCameraManager: QRCameraViewController, didChangeZoomLevel zoom: CGFloat)
    
    /**
     qrCameraManagerViewControllerDelegate function called when when qrCameraManagerViewController fails to confiture the session.
     
     - Parameter qrCameraManager: Current qrCameraManagerViewController
     */
    
    func qrCameraManagerDidFailToConfigure(_ qrCameraManager: QRCameraViewController)
    
    /**
     qrCameraManagerViewControllerDelegate function called when when qrCameraManagerViewController does not have access to camera or microphone.
     
     - Parameter qrCameraManager: Current qrCameraManagerViewController
     */
    
    func qrCameraManagerNotAuthorized(_ qrCameraManager: QRCameraViewController)
}

public extension QRCameraViewControllerDelegate {
    
    func qrCameraManagerSessionDidStopRunning(_ qrCameraManager: QRCameraViewController) {
        // ...
    }
    
    func qrCameraManagerSessionDidStartRunning(_ qrCameraManager: QRCameraViewController) {
        // ...
    }
    
    func qrCameraManager(_ qrCameraManager: QRCameraViewController, didTake photo: UIImage) {
        // ...
    }

    
    func qrCameraManager(_ qrCameraManager: QRCameraViewController, didBeginRecordingVideo camera: QRCameraViewController.CameraSelection) {
        // ...
    }

    
    func qrCameraManager(_ qrCameraManager: QRCameraViewController, didFinishRecordingVideo camera: QRCameraViewController.CameraSelection) {
        // ...
    }

    
    func qrCameraManager(_ qrCameraManager: QRCameraViewController, didFinishProcessVideoAt url: URL) {
        // ...
    }
    
    func qrCameraManager(_ qrCameraManager: QRCameraViewController, didFailToRecordVideo error: Error) {
        // ...
    }
    
    func qrCameraManager(_ qrCameraManager: QRCameraViewController, didSwitchCameras camera: QRCameraViewController.CameraSelection) {
        // ...
    }

    
    func qrCameraManager(_ qrCameraManager: QRCameraViewController, didFocusAtPoint point: CGPoint) {
        // ...
    }

    
    func qrCameraManager(_ qrCameraManager: QRCameraViewController, didChangeZoomLevel zoom: CGFloat) {
        // ...
    }
    
    func qrCameraManagerDidFailToConfigure(_ qrCameraManager: QRCameraViewController) {
        // ...
    }
    
    func qrCameraManagerNotAuthorized(_ qrCameraController: QRCameraViewController) {
        // ...
    }
}



