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

open class QRCameraButton: UIButton {
    
    /// Delegate
    public weak var delegate: QRCameraButtonDelegate?
    
    // Define quando o botão estará ativo.
    public var buttonEnabled = true
    
    /// Define o tempo maximo.
    fileprivate var timer : Timer?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        createGestureRecognizers()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createGestureRecognizers()
    }
    
    /// UITapGestureRecognizer
    @objc fileprivate func Tap() {
        guard buttonEnabled == true else {
            return
        }
        
       delegate?.buttonWasTapped()
    }
    
    /// UILongPressGestureRecognizer
    @objc fileprivate func longPress(_ sender:UILongPressGestureRecognizer!)  {
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
    
    /// Método que é chamado quando o tempo definido é alcançado.
    @objc fileprivate func timerFinished() {
        invalidateTimer()
        delegate?.longPressDidReachMaximumDuration()
    }
    
    /// Inicia o contador para o tempo definido.
    fileprivate func startTimer() {
        if let duration = delegate?.setMaxiumVideoDuration() {
            //Check if duration is set, and greater than zero
            if duration != 0.0 && duration > 0.0 {
                timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector:  #selector(QRCameraButton.timerFinished), userInfo: nil, repeats: false)
            }
        }
    }
    
    // Método que invalida o timer.
    fileprivate func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // Add Tap and LongPress gesture recognizers
    fileprivate func createGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(QRCameraButton.Tap))
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(QRCameraButton.longPress))
        self.addGestureRecognizer(tapGesture)
        self.addGestureRecognizer(longGesture)
    }
}
