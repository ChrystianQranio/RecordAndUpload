//
//  PreviewViewController.swift
//  RecordAndUpload
//
//  Created by Chrystian Salgado on 10/01/2019.
//  Copyright © 2019 Qranio.com. All rights reserved.
//

import QRUIKit
import AVFoundation

class PreviewViewController: UIViewController {
    
    var image: UIImage?
    var videoUrl: URL?
    
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let imageTaked = image {
            imageView.image = imageTaked
            playerView.removeFromSuperview()
        }
        else if let videoStoragePath = videoUrl {
            guard let urlString = videoUrl?.absoluteString else { return }
            playerView.load(controllerParent: self, link: urlString)
            imageView.removeFromSuperview()
            
            transformMovieInData(from: videoStoragePath)
        }
    }
    
    private func transformMovieInData(from url: URL) {
        do {
            let videoData = try Data.init(contentsOf: url)
            print(videoData)
        } catch {
            print("Erro ao criar um data")
        }
    }
    
    @IBAction func actionDiscart(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionUpload(_ sender: Any) {
        guard let url = videoUrl else { return }
        capture(outputFileURL: url) { (nsData) in
//            print(data)
        }
    }
    
    func capture(outputFileURL: URL!, handler: @escaping (_ exportSession: NSData?)-> Void) {
        var contentData: NSData?
        
        guard let data = NSData(contentsOf: outputFileURL as URL) else {
            return
        }
        
        print("File size before compression: \(Double(data.length / 1048576)) mb")
        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".m4v")
        compressVideo(inputURL: outputFileURL as URL, outputURL: compressedURL) { (exportSession) in
            guard let session = exportSession else {
                return
            }
            
            switch session.status {
            case .unknown:
                handler(nil)
                break
            case .waiting:
                handler(nil)
                break
            case .exporting:
                handler(nil)
                break
            case .completed:
                guard let compressedData = NSData(contentsOf: compressedURL) else {
                    return
                }
                
                print("File size after compression: \(Double(compressedData.length / 1048576)) mb")
                handler(compressedData)
                break
            case .failed:
                handler(nil)
                break
            case .cancelled:
                handler(nil)
                break
            }
        }
    }
    
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality) else {
            handler(nil)
            
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
}
