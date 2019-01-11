//
//  ViewController.swift
//  RecordAndUpload
//
//  Created by Chrystian Salgado on 10/01/2019.
//  Copyright © 2019 Qranio.com. All rights reserved.
//

import UIKit
import SwiftyCam

enum ActionEnum {
    case photo
    case video
}

class ViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate {
    
    @IBOutlet weak var segmentControll: UISegmentedControl!
    @IBOutlet weak var btnTakeShot: UIButton?
    @IBOutlet weak var containerProgress: UIView!
    @IBOutlet weak var lcLeftProgressRemaning: NSLayoutConstraint!
    
    // Timer
    var timer: Timer?
    var videoMaxTime: Double?
    var widthToRoll: CGFloat?
    
    // Camera
    var recording = false
    var cameraAction: ActionEnum = .photo

    // MARK: Life-Cicle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
        configure()
        self.lcLeftProgressRemaning.constant = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    /// Setup View Controller elements
    private func configure() {
        
        // Setup preferences
        self.videoQuality = .resolution1280x720
        self.doubleTapCameraSwitch = false
        self.defaultCamera = .front
        self.videoMaxTime = 10.0
        
        // Setup visal elements
        btnTakeShot?.setTitle("START", for: .normal)
        containerProgress.isHidden = segmentControll.selectedSegmentIndex == 0 ?  true : false
    }
    
    // MARK: SwiftyCam Delegates
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        performSegue(withIdentifier: "showPreviewController", sender: photo)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        performSegue(withIdentifier: "showPreviewController", sender: url)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPreviewController" {
            if let previewViewController = segue.destination as? PreviewViewController {
                previewViewController.image = sender as? UIImage
                previewViewController.videoUrl = sender as? URL
            }
        }
    }
    
    // MARK: Actions
    
    @IBAction func actionTakeShot(_ sender: Any) {
        if cameraAction == .photo {
            takePhoto()
        } else {
            if recording {
//                stopVideoRecording()
                timerFinished()
                btnTakeShot?.setTitleColor(.black, for: .normal)
                btnTakeShot?.setTitle("Take", for: .normal)
                
            } else {
                startVideoRecording()
                startTimer()
                
                btnTakeShot?.setTitleColor(.red, for: .highlighted)
                btnTakeShot?.setTitle("STOP", for: .normal)
            }
            recording = !recording
        }
    }
    
    @IBAction func actionChangeSegment(_ sender: UISegmentedControl) {
        switch segmentControll.selectedSegmentIndex {
        case 0:
            cameraAction = .photo
        case 1:
            cameraAction = .video
        default:
            cameraAction = .photo
        }
        
        setProgressBarVisible(by: cameraAction)
    }
}

extension ViewController {
    
    fileprivate func setProgressBarVisible(by type: ActionEnum) {
        self.containerProgress.isHidden = type == .video ? false : true
    }
    
    fileprivate func startTimer() {
        guard let duration = videoMaxTime else { return }
        
        if duration != 0.0 && duration > 0.0 {
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector:  #selector(updateTimer), userInfo: nil, repeats: true)
            RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
        }
    }
    
    @objc fileprivate func updateTimer() {
        self.videoMaxTime! -= 0.01
        if videoMaxTime! > 0.0 {
            updateProgressBar()
        }
        else {
            timerFinished()
        }
    }
    
    private func updateProgressBar() {
        
        if widthToRoll == nil {
            guard let _videoMaxTime = videoMaxTime else { return }
            let viewWidth = self.view.bounds.width
            let x = (viewWidth / CGFloat(_videoMaxTime) / 100)
            widthToRoll = x
        }
        
        guard let _widthToRoll = widthToRoll else { return }
        self.lcLeftProgressRemaning.constant -= _widthToRoll
    }
    
    fileprivate func timerFinished() {
        invalidateTimer()
        self.longPressDidReachMaximumDuration()
    }
    
    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
}

