//
//  QRCameraButton.swift
//  RecordAndUpload
//
//  Created by Chrystian Salgado on 14/01/2019.
//

import UIKit

//MARK: Public Protocol Declaration

/// Delegate for QRCameraButton

public protocol QRCameraButtonDelegate: class {
    
    /// Called when UITapGestureRecognizer begins
    
    func buttonWasTapped()
    
    /// Called When UILongPressGestureRecognizer enters UIGestureRecognizerState.began
    
    func buttonDidBeginLongPress()
    
    /// Called When UILongPressGestureRecognizer enters UIGestureRecognizerState.end

    func buttonDidEndLongPress()
    
    /// Called when the maximum duration is reached
    
    func longPressDidReachMaximumDuration()
    
    /// Sets the maximum duration of the video recording
    
    func setMaxiumVideoDuration() -> Double
}

// MARK: Public View Declaration


/// UIButton Subclass for Capturing Photo and Video with QRCameraViewController

open class QRCameraButton: UIButton {
    
    /// Delegate variable
    
    public weak var delegate: QRCameraButtonDelegate?
    
    // Sets whether button is enabled
    
    public var buttonEnabled = true
    
    /// Maximum duration variable
    
    fileprivate var timer : Timer?
    
    /// Initialization Declaration
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        createGestureRecognizers()
    }
    
    /// Initialization Declaration

    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createGestureRecognizers()
    }
    
    /// UITapGestureRecognizer Function
    
    @objc fileprivate func Tap() {
        guard buttonEnabled == true else {
            return
        }
        
       delegate?.buttonWasTapped()
    }
    
    /// UILongPressGestureRecognizer Function
    @objc fileprivate func LongPress(_ sender:UILongPressGestureRecognizer!)  {
        guard buttonEnabled == true else {
            return
        }
        
        switch sender.state {
        case .began:
            delegate?.buttonDidBeginLongPress()
            startTimer()
        case .cancelled, .ended, .failed:
            invalidateTimer()
            delegate?.buttonDidEndLongPress()
        default:
            break
        }
    }
    
    /// Timer Finished
    
    @objc fileprivate func timerFinished() {
        invalidateTimer()
        delegate?.longPressDidReachMaximumDuration()
    }
    
    /// Start Maximum Duration Timer
    
    fileprivate func startTimer() {
        if let duration = delegate?.setMaxiumVideoDuration() {
            //Check if duration is set, and greater than zero
            if duration != 0.0 && duration > 0.0 {
                timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector:  #selector(QRCameraButton.timerFinished), userInfo: nil, repeats: false)
            }
        }
    }
    
    // End timer if UILongPressGestureRecognizer is ended before time has ended
    
    fileprivate func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // Add Tap and LongPress gesture recognizers
    
    fileprivate func createGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(QRCameraButton.Tap))
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(QRCameraButton.LongPress))
        self.addGestureRecognizer(tapGesture)
        self.addGestureRecognizer(longGesture)
    }
}
