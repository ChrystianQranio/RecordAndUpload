//
//  QRCameraViewController.swift
//  RecordAndUpload
//
//  Created by Chrystian Salgado on 10/01/2019.
//  Copyright © 2019 Qranio.com. All rights reserved.
//

import UIKit
import AVFoundation

open class QRCameraViewController: UIViewController {
    
    public enum CameraSelection: String {
		case rear = "rear"
		case front = "front"
	}
    
    public enum FlashMode{
        //Return the equivalent AVCaptureDevice.FlashMode
        var AVFlashMode: AVCaptureDevice.FlashMode {
            switch self {
                case .on:
                    return .on
                case .off:
                    return .off
                case .auto:
                    return .auto
            }
        }
        //Flash mode is set to auto
        case auto
        
        //Flash mode is set to on
        case on
        
        //Flash mode is set to off
        case off
    }

	/// Enum correspondente a AVCaptureSessionPreset que define a qualidade do video.
	public enum VideoQuality {

		/// AVCaptureSessionPresetHigh
		case high

		/// AVCaptureSessionPresetMedium
		case medium

		/// AVCaptureSessionPresetLow
		case low

		/// AVCaptureSessionPreset352x288
		case resolution352x288

		/// AVCaptureSessionPreset640x480
		case resolution640x480

		/// AVCaptureSessionPreset1280x720
		case resolution1280x720

		/// AVCaptureSessionPreset1920x1080
		case resolution1920x1080

		/// AVCaptureSessionPreset3840x2160
		case resolution3840x2160

		/// AVCaptureSessionPresetiFrame960x540
		case iframe960x540

		/// AVCaptureSessionPresetiFrame1280x720
		case iframe1280x720
	}

	/**

	Resultado do setup de AVCaptureSession

	- success
	- notAuthorized
	- configurationFailed
	*/
	fileprivate enum SessionSetupResult {
		case success
		case notAuthorized
		case configurationFailed
	}

	// MARK: Public Variable Declarations

	public weak var cameraDelegate: QRCameraViewControllerDelegate?

	/// Tempo maximo de duração definido ao botão QRCameraButton.
	public var maximumVideoDuration : Double     = 0.0

	/// Qualidade do video.
	public var videoQuality : VideoQuality       = .high
    
    // Define se o flash está ligado ou não.
    public var flashMode:FlashMode               = .off

	/// Define se o gesto de pinsa será adicionado
	public var pinchToZoom                       = true

	/// Define o zoom maximo ao realizar o gesto .
	public var maxZoomScale				         = CGFloat.greatestFiniteMagnitude

    /// Define se ao precionar na tela o foco e a exposição será alterada.
	public var tapToFocus                        = true

    /**
     - Define se a captura tera o modo de low light definido automaticamente.
     - Only supported on iPhone 5 and 5C.
     */
	public var lowLightBoost                     = true

    /// Define se é possivel abilitar o audio em segundo plano vindo de outras aplicações.
	public var allowBackgroundAudio              = false

    /// Define se o gesto de double tap permite o switch das cameras.
	public var doubleTapCameraSwitch            = true

    /// Define se o método de swipe da o zoom.
    public var swipeToZoom                     = true

    /// Define o swipe por meio do zoom porem com a preferencia invertida.
    public var swipeToZoomInverted             = false

	/// Define a camera default (.rear, .front).
	public var defaultCamera                   = CameraSelection.rear

    /// Define se a foto ou o video será orientado de acordo com a orientação do device.
    public var shouldUseDeviceOrientation      = false {
        didSet {
            orientation.shouldUseDeviceOrientation = shouldUseDeviceOrientation
        }
    }

    /// Permite a rotação automatica do controller.
    public var allowAutoRotate                = false

    /// Specifies the [videoGravity](https://developer.apple.com/reference/avfoundation/avcapturevideopreviewlayer/1386708-videogravity) for the preview layer.
    public var videoGravity                   : QRCameraVideoGravity = .resizeAspect

    /// Seta se o audio estará disponivel.
    public var audioEnabled                   = true

    /// Sets whether or not app should display prompt to app settings if audio/video permission is denied
    /// If set to false, delegate function will be called to handle exception
    public var shouldPrompToAppSettings       = true

    /// Define aonde o video ficará salvo.
    public var outputFolder: String           = NSTemporaryDirectory()
    
    /// Método publico para acessar pinchGesture.
    fileprivate(set) public var pinchGesture  : UIPinchGestureRecognizer!

    /// Método publico para acessar panGesture.
    fileprivate(set) public var panGesture    : UIPanGestureRecognizer!


	// MARK: Public Get-only Variable Declarations

	/// Retorna se o video está sendo gravado.
	private(set) public var isVideoRecording      = false

	/// Retorna se a sessão está em progresso.
	private(set) public var isSessionRunning     = false

	/// Retorna a current camera.
	private(set) public var currentCamera        = CameraSelection.rear

	// MARK: Private Constant Declarations

	/// Current Capture Session
	public let session                           = AVCaptureSession()

	/// Serial queue used for setting up session
	fileprivate let sessionQueue                 = DispatchQueue(label: "session queue", attributes: [])

	// MARK: Private Variable Declarations

	/// Variavel que armazena o zoomScale.
	fileprivate var zoomScale                    = CGFloat(1.0)

    /// Variabel que armazena o a escala e zoom inicial antes de realizar um Pinch ou Zoom.
	fileprivate var beginZoomScale               = CGFloat(1.0)

    /// Retorna se o flash está habilitado.
	fileprivate var isCameraTorchOn              = false

    /// Recebe o resultado da sessão que foi feita o setup.
	fileprivate var setupResult                  = SessionSetupResult.success

	/// BackgroundID variable for video recording
	fileprivate var backgroundRecordingID        : UIBackgroundTaskIdentifier? = nil

	/// Video Input
	fileprivate var videoDeviceInput             : AVCaptureDeviceInput!

	/// Movie File Output
	fileprivate var movieFileOutput              : AVCaptureMovieFileOutput?

	/// Photo File Output
	fileprivate var photoFileOutput              : AVCaptureStillImageOutput?

	/// Video Device
	fileprivate var videoDevice                  : AVCaptureDevice?

	/// PreviewView
	fileprivate var previewLayer                 : QRCameraPreviewView!

	/// UIView usada para acão do flash frontal.
	fileprivate var flashView                    : UIView?

    /// Pan Translation
    fileprivate var previousPanTranslation       : CGFloat = 0.0

	/// Ultima orientação.
    fileprivate var orientation                  : QRCameraOrientation = QRCameraOrientation()

    /// Booleano que retorna quando a sessão esta sendo executada.
    fileprivate var sessionRunning               = false

	/// Disable view autorotation for forced portrait recorindg
	override open var shouldAutorotate: Bool {
		return allowAutoRotate
	}

	// MARK: View Controller Life-Cicle
	override open func viewDidLoad() {
		super.viewDidLoad()
        previewLayer = QRCameraPreviewView(frame: view.frame, videoGravity: videoGravity)
        previewLayer.center = view.center
        view.addSubview(previewLayer)
        view.sendSubview(toBack: previewLayer)

		// Add Gesture Recognizers
        addGestureRecognizers()
		previewLayer.session = session

		// Teste de autorização pelo microfone e camera.
		switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
		case .authorized:
			break
		case .notDetermined:
			sessionQueue.suspend()
			AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { [unowned self] granted in
				if !granted {
					self.setupResult = .notAuthorized
				}
				self.sessionQueue.resume()
			})
		default:

			setupResult = .notAuthorized
		}
		sessionQueue.async { [unowned self] in
			self.configureSession()
		}
	}
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(captureSessionDidStartRunning), name: .AVCaptureSessionDidStartRunning, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(captureSessionDidStopRunning),  name: .AVCaptureSessionDidStopRunning,  object: nil)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Se inscreve para escutar as rotações do device.
        if shouldUseDeviceOrientation {
            orientation.start()
        }
        
        setBackgroundAudioPreference()
        sessionQueue.async {
            switch self.setupResult {
            case .success:
                self.session.startRunning()
                self.isSessionRunning = self.session.isRunning
                
                DispatchQueue.main.async {
                    self.previewLayer.videoPreviewLayer.connection?.videoOrientation = self.orientation.getPreviewLayerOrientation()
                }
                
            case .notAuthorized:
                if self.shouldPrompToAppSettings == true {
                    self.promptToAppSettings()
                }
                else {
                    self.cameraDelegate?.qrCameraManagerNotAuthorized(self)
                }
            case .configurationFailed:
                DispatchQueue.main.async {
                    self.cameraDelegate?.qrCameraManagerDidFailToConfigure(self)
                }
            }
        }
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        sessionRunning = false
        
        // Se a sessão estiver em execução pare a mesma.
        if self.isSessionRunning == true {
            self.session.stopRunning()
            self.isSessionRunning = false
        }
        
        // Desabilite o flash se o mesmo estiver habilitado.
        disableFlash()
        
        if shouldUseDeviceOrientation {
            orientation.stop()
        }
    }

    // MARK: ViewDidLayoutSubviews
    private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
        layer.videoOrientation = orientation
        previewLayer.frame = self.view.bounds

    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let connection =  self.previewLayer?.videoPreviewLayer.connection  {
            let currentDevice: UIDevice = UIDevice.current
            let orientation: UIDeviceOrientation = currentDevice.orientation
            let previewLayerConnection : AVCaptureConnection = connection

            if previewLayerConnection.isVideoOrientationSupported {

                switch (orientation) {
                case .portrait: updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                    break

                case .landscapeRight: updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeLeft)
                    break

                case .landscapeLeft: updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeRight)
                    break

                case .portraitUpsideDown: updatePreviewLayer(layer: previewLayerConnection, orientation: .portraitUpsideDown)
                    break

                default: updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                    break
                }
            }
        }
    }

	public func takePhoto() {
		guard let device = videoDevice else {
			return
		}

        if device.hasFlash == true && flashMode != .off /* TODO: Add Support for Retina Flash and add front flash */ {
            changeFlashSettings(device: device, mode: flashMode)
			capturePhotoAsyncronously(completionHandler: { (_) in })
        }
        else {
			if device.isFlashActive == true {
				changeFlashSettings(device: device, mode: flashMode)
			}
			capturePhotoAsyncronously(completionHandler: { (_) in })
		}
	}

	/**
	- Inicia o processo de gravação de video.
	- Disparado pelo delegate didBeginRecordingVideo...
	*/
	public func startVideoRecording() {

        guard sessionRunning == true else {
            print("[SwiftyCam]: Cannot start video recoding. Capture session is not running")
            return
        }
		guard let movieFileOutput = self.movieFileOutput else {
			return
		}

		if currentCamera == .rear && flashMode == .on {
			enableFlash()
		}

		if currentCamera == .front && flashMode == .on  {
			flashView = UIView(frame: view.frame)
			flashView?.backgroundColor = UIColor.white
			flashView?.alpha = 0.85
			previewLayer.addSubview(flashView!)
		}

        let previewOrientation = previewLayer.videoPreviewLayer.connection!.videoOrientation

		sessionQueue.async { [unowned self] in
			if !movieFileOutput.isRecording {
				if UIDevice.current.isMultitaskingSupported {
					self.backgroundRecordingID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
				}

				let movieFileOutputConnection = self.movieFileOutput?.connection(with: AVMediaType.video)

				if self.currentCamera == .front {
					movieFileOutputConnection?.isVideoMirrored = true
				}

				movieFileOutputConnection?.videoOrientation = self.orientation.getVideoOrientation() ?? previewOrientation
                
                // Grava em um arquivo temporario
				let outputFileName = UUID().uuidString
				let outputFilePath = (self.outputFolder as NSString).appendingPathComponent((outputFileName as NSString).appendingPathExtension("mov")!)
				movieFileOutput.startRecording(to: URL(fileURLWithPath: outputFilePath), recordingDelegate: self)
                
				self.isVideoRecording = true
				DispatchQueue.main.async {
                    self.cameraDelegate?.qrCameraManager(self, didBeginRecordingVideo: self.currentCamera)
				}
			}
			else {
				movieFileOutput.stopRecording()
			}
		}
	}

	/**
	- Realiza o stop do video, e processa a url.
	- didFinishRecordingVideo será chamado.
    - Quando o video acaba de ser processado, é disparado no delegate didFinishProcessVideoAt url...
	*/

	public func stopVideoRecording() {
		if self.isVideoRecording == true {
			self.isVideoRecording = false
			movieFileOutput!.stopRecording()
			disableFlash()

			if currentCamera == .front && flashMode == .on && flashView != nil {
				UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
					self.flashView?.alpha = 0.0
				}, completion: { (_) in
					self.flashView?.removeFromSuperview()
				})
			}
			DispatchQueue.main.async {
                self.cameraDelegate?.qrCameraManager(self, didFinishRecordingVideo: self.currentCamera)
			}
		}
	}

	/// Método que realiza o switch das cameras.
	public func switchCamera() {
		guard isVideoRecording != true else {
			print("[SwiftyCam]: Switching between cameras while recording video is not supported")
			return
		}

        guard session.isRunning == true else {
            return
        }

		switch currentCamera {
		case .front:
			currentCamera = .rear
		case .rear:
			currentCamera = .front
		}

		session.stopRunning()

		sessionQueue.async { [unowned self] in

			// Re adiciona os inputs e outputs
			for input in self.session.inputs {
				self.session.removeInput(input )
			}

			self.addInputs()
			DispatchQueue.main.async {
                self.cameraDelegate?.qrCameraManager(self, didSwitchCameras: self.currentCamera)
			}

			self.session.startRunning()
		}
        
        // Se o Flash estiver habilitado e o flash na tela frontal for requerido.
		disableFlash()
	}

	// MARK: Private Functions

	/// Configure session, inputs e outputs
	fileprivate func configureSession() {
		guard setupResult == .success else {
			return
		}

		currentCamera = defaultCamera

		// inicia a configuração da session
		session.beginConfiguration()
		configureVideoPreset()
		addVideoInput()
		addAudioInput()
		configureVideoOutput()
		configurePhotoOutput()

		session.commitConfiguration()
	}

	/// Adiciona os input após trocar de camera.
	fileprivate func addInputs() {
		session.beginConfiguration()
		configureVideoPreset()
		addVideoInput()
		addAudioInput()
		session.commitConfiguration()
	}


	/// Define a qualidade do video, se a qualidade não puder ser adicionada então adiciona como default .high
	fileprivate func configureVideoPreset() {
		if currentCamera == .front {
			session.sessionPreset = AVCaptureSession.Preset(rawValue: videoInputPresetFromVideoQuality(quality: .high))
		} else {
			if session.canSetSessionPreset(AVCaptureSession.Preset(rawValue: videoInputPresetFromVideoQuality(quality: videoQuality))) {
				session.sessionPreset = AVCaptureSession.Preset(rawValue: videoInputPresetFromVideoQuality(quality: videoQuality))
			} else {
				session.sessionPreset = AVCaptureSession.Preset(rawValue: videoInputPresetFromVideoQuality(quality: .high))
			}
		}
	}

	/// Adiciona Video Inputs
	fileprivate func addVideoInput() {
		switch currentCamera {
		case .front:
			videoDevice = QRCameraViewController.deviceWithMediaType(AVMediaType.video.rawValue, preferringPosition: .front)
		case .rear:
			videoDevice = QRCameraViewController.deviceWithMediaType(AVMediaType.video.rawValue, preferringPosition: .back)
		}

		if let device = videoDevice {
			do {
				try device.lockForConfiguration()
				if device.isFocusModeSupported(.continuousAutoFocus) {
					device.focusMode = .continuousAutoFocus
					if device.isSmoothAutoFocusSupported {
						device.isSmoothAutoFocusEnabled = true
					}
				}

				if device.isExposureModeSupported(.continuousAutoExposure) {
					device.exposureMode = .continuousAutoExposure
				}

				if device.isWhiteBalanceModeSupported(.continuousAutoWhiteBalance) {
					device.whiteBalanceMode = .continuousAutoWhiteBalance
				}

				if device.isLowLightBoostSupported && lowLightBoost == true {
					device.automaticallyEnablesLowLightBoostWhenAvailable = true
				}

				device.unlockForConfiguration()
			} catch {
				print("[SwiftyCam]: Error locking configuration")
			}
		}

		do {
            if let videoDevice = videoDevice {
                let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
                if session.canAddInput(videoDeviceInput) {
                    session.addInput(videoDeviceInput)
                    self.videoDeviceInput = videoDeviceInput
                }
                else {
                    print("[SwiftyCam]: Could not add video device input to the session")
                    print(session.canSetSessionPreset(AVCaptureSession.Preset(rawValue: videoInputPresetFromVideoQuality(quality: videoQuality))))
                    setupResult = .configurationFailed
                    session.commitConfiguration()
                    return
                }
            }
			
		} catch {
			print("[SwiftyCam]: Could not create video device input: \(error)")
			setupResult = .configurationFailed
			return
		}
	}

	/// Adiciona Audio Inputs
	fileprivate func addAudioInput() {
        guard audioEnabled == true else {
            return
        }
		do {
            if let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio){
                let audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice)
                if session.canAddInput(audioDeviceInput) {
                    session.addInput(audioDeviceInput)
                } else {
                    print("[SwiftyCam]: Could not add audio device input to the session")
                }
                
            } else {
                print("[SwiftyCam]: Could not find an audio device")
            }
            
		} catch {
			print("[SwiftyCam]: Could not create audio device input: \(error)")
		}
	}

	/// Configure Movie Output
	fileprivate func configureVideoOutput() {
		let movieFileOutput = AVCaptureMovieFileOutput()

		if self.session.canAddOutput(movieFileOutput) {
			self.session.addOutput(movieFileOutput)
			if let connection = movieFileOutput.connection(with: AVMediaType.video) {
				if connection.isVideoStabilizationSupported {
					connection.preferredVideoStabilizationMode = .auto
				}
			}
			self.movieFileOutput = movieFileOutput
		}
	}

	/// Configure Photo Output

	fileprivate func configurePhotoOutput() {
		let photoFileOutput = AVCaptureStillImageOutput()

		if self.session.canAddOutput(photoFileOutput) {
			photoFileOutput.outputSettings  = [AVVideoCodecKey: AVVideoCodecJPEG]
			self.session.addOutput(photoFileOutput)
			self.photoFileOutput = photoFileOutput
		}
	}


	/**
	Retorna a UIImage.
     
	- Parameter imageData: Image Data vindo da sessao de captura.
	- Returns: UIImage vindo da image Data.
	*/

	fileprivate func processPhoto(_ imageData: Data) -> UIImage {
		let dataProvider = CGDataProvider(data: imageData as CFData)
		let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)

		let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: self.orientation.getImageOrientation(forCamera: self.currentCamera))
		return image
	}

	fileprivate func capturePhotoAsyncronously(completionHandler: @escaping(Bool) -> ()) {
        guard sessionRunning == true else {
            print("[SwiftyCam]: Cannot take photo. Capture session is not running")
            return
        }

		if let videoConnection = photoFileOutput?.connection(with: AVMediaType.video) {
			photoFileOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: {(sampleBuffer, error) in
				if (sampleBuffer != nil) {
					let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer!)
					let image = self.processPhoto(imageData!)

					// Chama o delegate passando a nova imagem.
					DispatchQueue.main.async {
                        self.cameraDelegate?.qrCameraManager(self, didTake: image)
					}
					completionHandler(true)
				} else {
					completionHandler(false)
				}
			})
		} else {
			completionHandler(false)
		}
	}

    /// Handler caso as confiurações de privacidade forem negadas
	fileprivate func promptToAppSettings() {

		DispatchQueue.main.async(execute: { [unowned self] in
			let message = NSLocalizedString("AVCam doesn't have permission to use the camera, please change privacy settings", comment: "Alert message when the user has denied access to the camera")
			let alertController = UIAlertController(title: "AVCam", message: message, preferredStyle: .alert)
			alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil))
			alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Alert button to open Settings"), style: .default, handler: { action in
				if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
				}
                else {
                    if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
						UIApplication.shared.openURL(appSettings)
					}
				}
			}))
			self.present(alertController, animated: true, completion: nil)
		})
	}

	/**
	Retorna a AVCapturePreset vinda do enum VideoQuality
	- Parameter quality: ViewQuality
	- Returns: String(AVCapturePreset)
	*/
	fileprivate func videoInputPresetFromVideoQuality(quality: VideoQuality) -> String {
		switch quality {
		case .high: return AVCaptureSession.Preset.high.rawValue
		case .medium: return AVCaptureSession.Preset.medium.rawValue
		case .low: return AVCaptureSession.Preset.low.rawValue
		case .resolution352x288: return AVCaptureSession.Preset.cif352x288.rawValue
		case .resolution640x480: return AVCaptureSession.Preset.vga640x480.rawValue
		case .resolution1280x720: return AVCaptureSession.Preset.hd1280x720.rawValue
		case .resolution1920x1080: return AVCaptureSession.Preset.hd1920x1080.rawValue
		case .iframe960x540: return AVCaptureSession.Preset.iFrame960x540.rawValue
		case .iframe1280x720: return AVCaptureSession.Preset.iFrame1280x720.rawValue
		case .resolution3840x2160:
			if #available(iOS 9.0, *) {
				return AVCaptureSession.Preset.hd4K3840x2160.rawValue
			}
			else {
				print("[SwiftyCam]: Resolution 3840x2160 not supported")
				return AVCaptureSession.Preset.high.rawValue
			}
		}
	}

	/// Método de get dos devices.
	fileprivate class func deviceWithMediaType(_ mediaType: String, preferringPosition position: AVCaptureDevice.Position) -> AVCaptureDevice? {
		if #available(iOS 10.0, *) {
				let avDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType(rawValue: mediaType), position: position)
				return avDevice
		} else {
				// Fallback on earlier versions
				let avDevice = AVCaptureDevice.devices(for: AVMediaType(rawValue: mediaType))
				var avDeviceNum = 0
				for device in avDevice {
						print("deviceWithMediaType Position: \(device.position.rawValue)")
						if device.position == position {
								break
						} else {
								avDeviceNum += 1
						}
				}

				return avDevice[avDeviceNum]
		}
	}

	/// Habilita o flash para foto.
    fileprivate func changeFlashSettings(device: AVCaptureDevice, mode: FlashMode) {
		do {
			try device.lockForConfiguration()
			device.flashMode = mode.AVFlashMode
			device.unlockForConfiguration()
		} catch {
			print("[SwiftyCam]: \(error)")
		}
	}

	/// Método que seta o flash como ativo.
	fileprivate func enableFlash() {
		if self.isCameraTorchOn == false {
			toggleFlash()
		}
	}

	/// Método que desabilita o flash.
	fileprivate func disableFlash() {
		if self.isCameraTorchOn == true {
			toggleFlash()
		}
	}

	/// Alterna o flash entre ativado e desativado.
	fileprivate func toggleFlash() {
		guard self.currentCamera == .rear else {
			// Flash is not supported for front facing camera
			return
		}

		let device = AVCaptureDevice.default(for: AVMediaType.video)
		// Check if device has a flash
		if (device?.hasTorch)! {
			do {
				try device?.lockForConfiguration()
				if (device?.torchMode == AVCaptureDevice.TorchMode.on) {
					device?.torchMode = AVCaptureDevice.TorchMode.off
					self.isCameraTorchOn = false
				} else {
					do {
						try device?.setTorchModeOn(level: 1.0)
						self.isCameraTorchOn = true
					} catch {
						print("[SwiftyCam]: \(error)")
					}
				}
				device?.unlockForConfiguration()
			} catch {
				print("[SwiftyCam]: \(error)")
			}
		}
	}

    /// Seta o audio para aplicações em background e outras fontes.
	fileprivate func setBackgroundAudioPreference() {
		guard allowBackgroundAudio == true else {
			return
		}

        guard audioEnabled == true else {
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with: [.duckOthers, .defaultToSpeaker])
            session.automaticallyConfiguresApplicationAudioSession = false
        }
        catch {
            print("[SwiftyCam]: Failed to set background audio preference")
            
        }
	}

    /// Chamado quando é disparado a notificação que a sessao esta em execução.
    @objc private func captureSessionDidStartRunning() {
        sessionRunning = true
        DispatchQueue.main.async {
            self.cameraDelegate?.qrCameraManagerSessionDidStartRunning(self)
        }
    }

    /// Chamado quando é disparado a notificação que a sessao foi pausada.
    @objc private func captureSessionDidStopRunning() {
        sessionRunning = false
        DispatchQueue.main.async {
            self.cameraDelegate?.qrCameraManagerSessionDidStopRunning(self)
        }
    }
}

extension QRCameraViewController : QRCameraButtonDelegate {

	/// Define a duração maxima para o video.
	public func setMaxiumVideoDuration() -> Double {
		return maximumVideoDuration
	}

	/// Define UITapGesture para tirar foto.
	public func buttonWasTapped() {
		takePhoto()
	}

	/// Define UILongPressGesture para iniciar um video.
	public func buttonDidBeginLongPress() {
		startVideoRecording()
	}

	/// Define UILongPressGesture quando não houver mais ação para pausar o video.
	public func buttonDidEndLongPress() {
		stopVideoRecording()
	}

	/// Método que é chamado quando a duração maxima é atingida.
	public func longPressDidReachMaximumDuration() {
		stopVideoRecording()
	}
}

// MARK: AVCaptureFileOutputRecordingDelegate
extension QRCameraViewController : AVCaptureFileOutputRecordingDelegate {

	/// Processa a captura e salva na pasta de arquivos temporarios.
    public func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let currentBackgroundRecordingID = backgroundRecordingID {
            backgroundRecordingID = UIBackgroundTaskInvalid

            if currentBackgroundRecordingID != UIBackgroundTaskInvalid {
                UIApplication.shared.endBackgroundTask(currentBackgroundRecordingID)
            }
        }

        if let currentError = error {
            print("[SwiftyCam]: Movie file finishing error: \(currentError)")
            DispatchQueue.main.async {
                self.cameraDelegate?.qrCameraManager(self, didFailToRecordVideo: currentError)
            }
        }
        else {
            //Chama o método de delegate didFinishProcessVideoAt... passando a url do arquivo.
            DispatchQueue.main.async {
                self.cameraDelegate?.qrCameraManager(self, didFinishProcessVideoAt: outputFileURL)
            }
        }
    }
}

// Mark: UIGestureRecognizer Declarations

extension QRCameraViewController {

	/// Manipula o gesto de pinch
	@objc fileprivate func zoomGesture(pinch: UIPinchGestureRecognizer) {
		guard pinchToZoom == true && self.currentCamera == .rear else {
			// Ignore gesture.
			return
		}
		do {
			let captureDevice = AVCaptureDevice.devices().first
			try captureDevice?.lockForConfiguration()

			zoomScale = min(maxZoomScale, max(1.0, min(beginZoomScale * pinch.scale,  captureDevice!.activeFormat.videoMaxZoomFactor)))

			captureDevice?.videoZoomFactor = zoomScale

			// Call Delegate function with current zoom scale
			DispatchQueue.main.async {
                self.cameraDelegate?.qrCameraManager(self, didChangeZoomLevel: self.zoomScale)
			}

			captureDevice?.unlockForConfiguration()

		} catch {
			print("[SwiftyCam]: Error locking configuration")
		}
	}

	/// Handle single tap gesture

	@objc fileprivate func singleTapGesture(tap: UITapGestureRecognizer) {
		guard tapToFocus == true else {
			// Ignore taps
			return
		}

		let screenSize = previewLayer!.bounds.size
		let tapPoint = tap.location(in: previewLayer!)
		let x = tapPoint.y / screenSize.height
		let y = 1.0 - tapPoint.x / screenSize.width
		let focusPoint = CGPoint(x: x, y: y)

		if let device = videoDevice {
			do {
				try device.lockForConfiguration()

				if device.isFocusPointOfInterestSupported == true {
					device.focusPointOfInterest = focusPoint
					device.focusMode = .autoFocus
				}
				device.exposurePointOfInterest = focusPoint
				device.exposureMode = AVCaptureDevice.ExposureMode.continuousAutoExposure
				device.unlockForConfiguration()
				//Call delegate function and pass in the location of the touch

				DispatchQueue.main.async {
                    self.cameraDelegate?.qrCameraManager(self, didFocusAtPoint: tapPoint)
				}
			}
			catch {
				// ...
			}
		}
	}

	/// Trata o gesto de double tap.
	@objc fileprivate func doubleTapGesture(tap: UITapGestureRecognizer) {
		guard doubleTapCameraSwitch == true else {
			return
		}
		switchCamera()
	}

    @objc private func panGesture(pan: UIPanGestureRecognizer) {

        guard swipeToZoom == true && self.currentCamera == .rear else {
            //ignore pan
            return
        }
        let currentTranslation    = pan.translation(in: view).y
        let translationDifference = currentTranslation - previousPanTranslation

        do {
            let captureDevice = AVCaptureDevice.devices().first
            try captureDevice?.lockForConfiguration()

            let currentZoom = captureDevice?.videoZoomFactor ?? 0.0

            if swipeToZoomInverted == true {
                zoomScale = min(maxZoomScale, max(1.0, min(currentZoom - (translationDifference / 75),  captureDevice!.activeFormat.videoMaxZoomFactor)))
            }
            else {
                zoomScale = min(maxZoomScale, max(1.0, min(currentZoom + (translationDifference / 75),  captureDevice!.activeFormat.videoMaxZoomFactor)))
            }

            captureDevice?.videoZoomFactor = zoomScale

            // Chama o método de delegate avisando que o nivel de zoom foi alterado.
            DispatchQueue.main.async {
                self.cameraDelegate?.qrCameraManager(self, didChangeZoomLevel: self.zoomScale)
            }

            captureDevice?.unlockForConfiguration()

        } catch {
            print("[SwiftyCam]: Error locking configuration")
        }

        if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {
            previousPanTranslation = 0.0
        } else {
            previousPanTranslation = currentTranslation
        }
    }

	fileprivate func addGestureRecognizers() {
		pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(zoomGesture(pinch:)))
		pinchGesture.delegate = self
		previewLayer.addGestureRecognizer(pinchGesture)

		let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(singleTapGesture(tap:)))
		singleTapGesture.numberOfTapsRequired = 1
		singleTapGesture.delegate = self
		previewLayer.addGestureRecognizer(singleTapGesture)

		let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapGesture(tap:)))
		doubleTapGesture.numberOfTapsRequired = 2
		doubleTapGesture.delegate = self
		previewLayer.addGestureRecognizer(doubleTapGesture)

        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(pan:)))
        panGesture.delegate = self
        previewLayer.addGestureRecognizer(panGesture)
	}
}


// MARK: UIGestureRecognizerDelegate

extension QRCameraViewController : UIGestureRecognizerDelegate {

	
	public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		if gestureRecognizer.isKind(of: UIPinchGestureRecognizer.self) {
			beginZoomScale = zoomScale;
		}
		return true
	}
}
