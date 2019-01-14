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
     Método chamando quando a sessão foi iniciada.
     
     - Parameter qrCameraManager: Classe qrCameraManagerViewController
     */
    
    func qrCameraManagerSessionDidStartRunning(_ qrCameraManager: QRCameraViewController)
    
    /**
     Método chamado quando a sessao foi parada.
     
     - Parameter qrCameraManager: Classe qrCameraManagerViewController
     */
    
    func qrCameraManagerSessionDidStopRunning(_ qrCameraManager: QRCameraViewController)
    
    /**
     Método que é chamado quando o processo de tirar a foto é disparado.
     
     - Parameter qrCameraManager: Classe qrCameraManagerViewController
     - Parameter photo: UIImage com a imagem fotografada.
     */
    func qrCameraManager(_ qrCameraManager: QRCameraViewController, didTake photo: UIImage)
    
    /**
     Método é chamado quando o video começa a ser gravado.
     
     - Parameter qrCameraManager: Classe qrCameraManagerViewController
     - Parameter camera: Camera selecionada.
     */
    func qrCameraManager(_ qrCameraManager: QRCameraViewController, didBeginRecordingVideo camera: QRCameraViewController.CameraSelection)
    
    /**
     qrCameraManagerViewControllerDelegate function called when qrCameraManagerViewController finishes recording video.
     
     - Parameter qrCameraManager: Classe qrCameraManagerViewController
     - Parameter camera: Camera selecionada.
     */
    
    func qrCameraManager(_ qrCameraManager: QRCameraViewController, didFinishRecordingVideo camera: QRCameraViewController.CameraSelection)
    
    /**
     Método que é chamado quando o processo de gravação e renderização do video está completo.
     
     - Parameter qrCameraManager: Classe qrCameraManagerViewController
     - Parameter url: URL do arquivo vinda do diretorio temporario.
     */
    func qrCameraManager(_ qrCameraManager: QRCameraViewController, didFinishProcessVideoAt url: URL)
    
    
    /**
     Método que é chamado quando acontece um erro ao tentar gravar o video.
     
     - Parameter qrCameraManager: Classe qrCameraManagerViewController
     - Parameter error
     */
    func qrCameraManager(_ qrCameraManager: QRCameraViewController, didFailToRecordVideo error: Error)
    
    /**
     Método chamado quando as camera são trocadas.
     
     - Parameter qrCameraManager: Classe qrCameraManagerViewController
     - Parameter camera: Camera selecionada.
     */
    func qrCameraManager(_ qrCameraManager: QRCameraViewController, didSwitchCameras camera: QRCameraViewController.CameraSelection)
    
    /**
     Método que é chamado quando o foco for alterado para um determinado ponto da tela.
     
     - Parameter qrCameraManager: Classe qrCameraManagerViewController
     - Parameter point: Ponto da view aonde foi precionado para ajustar o foco.
     */
    func qrCameraManager(_ qrCameraManager: QRCameraViewController, didFocusAtPoint point: CGPoint)
    
    
    /**
     Método que é chamado quando a view tem seu nivel de zoom alterado.
     
     - Parameter qrCameraManager: Classe qrCameraManagerViewController
     - Parameter zoom: Nivel aual de zoom.
     */
    func qrCameraManager(_ qrCameraManager: QRCameraViewController, didChangeZoomLevel zoom: CGFloat)
    
    
    /**
     Método que é chamado quando qrCameraManagerViewController não consegue configurar a sessão.
     
     - Parameter qrCameraManager: Classe qrCameraManagerViewController.
     */
    func qrCameraManagerDidFailToConfigure(_ qrCameraManager: QRCameraViewController)
    
    
    /**
     Método que é chamado quando não foi concedido acesso a camera ou ao microfone.
     
     - Parameter qrCameraManager: Classe qrCameraManagerViewController.
     */
    func qrCameraManagerNotAuthorized(_ qrCameraManager: QRCameraViewController)
    
    /**
     Método que centraliza todas mensagens de erro de qrCameraManager.
     */
    func qrCameraManagerErrorHandler(error: String)
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
    
    func qrCameraManagerErrorHandler(error: String) {
        
    }
}



