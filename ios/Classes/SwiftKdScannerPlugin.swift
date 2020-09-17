import Flutter
import AVFoundation
import UIKit

protocol BarcodeScannerDelegate {
  func barcodeScanner(_ barcodeScanner: BarcodeScannerViewController, didScannedCode code: String)
  func barcodeScanner(_ barcodeScanner: BarcodeScannerViewController, didFailWithError error: BarcodeScannerError)
  func barcodeScannerDidCancel(_ barcodeScanner: BarcodeScannerViewController)
}

enum BarcodeScannerError: Error {
  case cameraAccessDenied
  case scanningNotSupported
}

class BarcodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
  var delegate: BarcodeScannerDelegate?

  private var captureSession: AVCaptureSession!
  private var previewLayer: AVCaptureVideoPreviewLayer!

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.black
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    switch AVCaptureDevice.authorizationStatus(for: .video) {
      case .authorized: // The user has previously granted access to the camera.
        self.setupCaptureSession()
      case .notDetermined: // The user has not yet been asked for camera access.
        AVCaptureDevice.requestAccess(for: .video) { granted in
          if granted {
            DispatchQueue.main.async {
              self.setupCaptureSession()
            }
          }
        }
      default:
        delegate?.barcodeScanner(self, didFailWithError: BarcodeScannerError.cameraAccessDenied)
    }

    if (captureSession?.isRunning == false) {
      captureSession.startRunning()
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    if (captureSession?.isRunning == true) {
      captureSession.stopRunning()
    }
  }

  private func setupCaptureSession() {
    captureSession = AVCaptureSession()

    guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
    let videoInput: AVCaptureDeviceInput

    do {
      videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
    } catch {
      failed()
      return
    }

    if (captureSession.canAddInput(videoInput)) {
      captureSession.addInput(videoInput)
    } else {
      failed()
      return
    }

    let metadataOutput = AVCaptureMetadataOutput()

    if (captureSession.canAddOutput(metadataOutput)) {
      captureSession.addOutput(metadataOutput)

      metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
      metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417, .qr]
    } else {
      failed()
      return
    }

    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    previewLayer.frame = view.layer.bounds
    previewLayer.videoGravity = .resizeAspectFill
    view.layer.addSublayer(previewLayer)

    let button = UIButton(type: .custom)
    button.frame = CGRect(x: view.frame.width - 75, y: view.frame.height - 90, width: 56, height: 56)
    button.backgroundColor = .white
    button.tintColor = .black
    button.layer.cornerRadius = 0.5 * button.bounds.size.width
    button.clipsToBounds = true
    button.setTitle("✕", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
    view.addSubview(button)

    let redLine = UIView()
    redLine.frame = CGRect(x: view.frame.width * 0.25, y: view.frame.height/2, width: view.frame.width * 0.5, height: 1)
    redLine.backgroundColor = .red
    view.addSubview(redLine)

    captureSession.startRunning()
  }

  @objc func cancel() {
    captureSession?.stopRunning()
    delegate?.barcodeScannerDidCancel(self)
  }

  func failed() {
    delegate?.barcodeScanner(self, didFailWithError: BarcodeScannerError.scanningNotSupported)
    captureSession = nil
  }

  func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    captureSession.stopRunning()

    if let metadataObject = metadataObjects.first {
      guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
      guard let stringValue = readableObject.stringValue else { return }
      AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
      found(code: stringValue)
    }
  }

  func found(code: String) {
    delegate?.barcodeScanner(self, didScannedCode: code)
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
}

public class SwiftKdScannerPlugin: NSObject, FlutterPlugin, BarcodeScannerDelegate {
	public static func register(with registrar: FlutterPluginRegistrar) {
		let channel = FlutterMethodChannel(name: "kd_scanner", binaryMessenger: registrar.messenger())
		let instance = SwiftKdScannerPlugin()
		registrar.addMethodCallDelegate(instance, channel: channel)
	}

	private var viewController: UIViewController {
		get {
			return UIApplication.shared.delegate!.window!!.rootViewController!
		}
	}
	private var barcodeScanner: BarcodeScannerViewController!
	private var pendingResult: FlutterResult?

	override init() {
		super.init()
		barcodeScanner = BarcodeScannerViewController()
		if #available(iOS 13.0, *) {
			barcodeScanner.modalPresentationStyle = .fullScreen
		}
		barcodeScanner.delegate = self
	}

	public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
		if (call.method == "getPlatformVersion") {
			result("iOS " + UIDevice.current.systemVersion)
		} else if (call.method == "scan") {
			pendingResult = result
			viewController.present(barcodeScanner, animated: false, completion: nil)
		} else {
			result(FlutterMethodNotImplemented)
		}
	}

	func barcodeScanner(_ barcodeScanner: BarcodeScannerViewController, didScannedCode code: String) {
		pendingResult?(code)
		viewController.dismiss(animated: false)
	}

	func barcodeScannerDidCancel(_ barcodeScanner: BarcodeScannerViewController) {
		viewController.dismiss(animated: false)
	}

	func barcodeScanner(_ barcodeScanner: BarcodeScannerViewController, didFailWithError error: BarcodeScannerError) {
    var code = ""
    var message = ""
    switch error {
    case .cameraAccessDenied:
      code = "cameraAccessDenied"
      message = "Camera access is denied"
    default:
      message = "Scanning is not supported"
    }
		pendingResult?(
			FlutterError(
				code: code,
				message: message,
				details: error.localizedDescription
			)
		)
		viewController.dismiss(animated: false)
	}
}
