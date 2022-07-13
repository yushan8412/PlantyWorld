//
//  QRcodeScanVC.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/7/4.
//

import Foundation
import UIKit
import AVFoundation

protocol SendFriendDateDelegate: AnyObject {
    func getEmailValue(useremail: String)
}

class ScanVC: UIViewController {
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    
    var delegate: SendFriendDateDelegate?
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    var label = UILabel()
    var stringValue: String = ""
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        view.backgroundColor = .pyellow
        // Get the back-facing camera for capturing videos
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            //            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
//            let baseImageView = UIImageView(frame: CGRect(x: 145, y: 0, width: 560, height: 1260))
            let baseImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height))
            
//            let gradientLayer = CAGradientLayer()
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
            
//            videoPreviewLayer?.frame = view.layer.bounds
            videoPreviewLayer?.frame = baseImageView.bounds

//            view.layer.masksToBounds = true
//            view.lkCornerRadius = 20
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture
            captureSession.startRunning()
            
            // Move the message label and top bar to the front
            
            // Initialize QR Code Frame to highlight the QR Code
            
            qrCodeFrameView = UIView()
            
            if let qrcodeFrameView = qrCodeFrameView {
                qrcodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrcodeFrameView.layer.borderWidth = 10
                view.addSubview(qrcodeFrameView)
                view.bringSubviewToFront(qrcodeFrameView)
                view.addSubview(label)
                view.bringSubviewToFront(label)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue anymore
            print(error)
            return
        }
        
        style()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        
        if captureSession.isRunning == false {
            captureSession.startRunning()
        }
        captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func style() {
        
        label.text = "hi"
        label.font = UIFont.systemFont(ofSize: 40, weight: .medium)
        label.backgroundColor = .green
    }
    
    func layout() {
        
        label.translatesAutoresizingMaskIntoConstraints = true
        
        NSLayoutConstraint.activate([
            
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
        ])
    }
}

extension ScanVC: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        // Get the metadata object
        guard let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else {return}
        
        if supportedCodeTypes.contains(metadataObj.type) {
            let barCode = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCode!.bounds
            
            if metadataObj.stringValue != nil {
                
                stringValue = metadataObj.stringValue ?? "can not find"
                print("0000000\(stringValue)")
                
                self.delegate?.getEmailValue(useremail: stringValue)

                if captureSession.isRunning == true {
                    captureSession.stopRunning()
                }
                navigationController?.popViewController(animated: true)
            }
        }
    }
}
