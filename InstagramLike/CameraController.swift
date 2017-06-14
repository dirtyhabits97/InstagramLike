//
//  CameraController.swift
//  InstagramLike
//
//  Created by Gonzalo Reyes Huertas on 6/14/17.
//  Copyright © 2017 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate{
    
    // MARK: - ViewController Properties    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Object References
    let output = AVCapturePhotoOutput()
    
    // MARK: - Interface Objects
    
    let capturePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "capture_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "right_arrow_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
        setupCapturePhotoButton()
        setupDismissButton()
    }
    
    // MARK: - Setup Methods
    
    fileprivate func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        // 1. setup inputs
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let error {
            print("Could not setup camera input: ", error)
        }
        
        // 2. setup outputs
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        // 3. setup output preview
        guard let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) else { return }
        //whenever we add a layer, we have to scpecify a frame for said layer
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        //causes the avsession to use the input of the camera
        captureSession.startRunning()
    }
    fileprivate func setupCapturePhotoButton() {
        view.addSubview(capturePhotoButton)
        capturePhotoButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-24)
            make.width.height.equalTo(80)
        }
    }
    fileprivate func setupDismissButton() {
        view.addSubview(dismissButton)
        dismissButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(12)
            make.right.equalTo(self.view).offset(-12)
            make.width.height.equalTo(50)
        }
    }
    
    // MARK: - Handle Methods
    
    func handleCapturePhoto() {
        let settings = AVCapturePhotoSettings()
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String : previewFormatType]
        output.capturePhoto(with: settings, delegate: self)
    }
    func handleDismiss() {
        dismiss(animated: true)
    }
    
    // MARK: - CapturePhotoDelegate Methods
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        guard let buffer = photoSampleBuffer else { return }
        guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else { return }
        let previewImage = UIImage(data: imageData)
        
        let containerView = PreviewPhotoContainerView()
        containerView.previewImageView.image = previewImage
        view.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
}
