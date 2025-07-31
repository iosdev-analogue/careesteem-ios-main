//
//  AGPHPhotoLibrary.swift
//  BaseProject
//
//  Created by Gauravkumar Gudaliya on 11/15/17.
//  Copyright © 2017 GauravkumarGudaliya. All rights reserved.
//

import UIKit
import Photos
import PhotosUI
import MobileCoreServices

typealias AGImagePickerControllerDelegate = UIImagePickerControllerDelegate & UINavigationControllerDelegate

enum AGImagePickerMediaType {
    case photo
    case video
    case both
    
    var mediaTypes: [String] {
        switch self {
        case .photo:
            return [kUTTypeImage as String]
            
        case .video:
            return [kUTTypeMovie as String]
            
        case .both:
            return [kUTTypeMovie as String, kUTTypeImage as String]
        }
    }
}

open class AGImagePickerController: NSObject {
    
    private var pickerController = UIImagePickerController()
    private var isAllowsEditing: Bool = false
    
    typealias AGPickerController = UIViewController & AGImagePickerControllerDelegate
    
    private var iPadSetup: UIView
    private var media: AGImagePickerMediaType
    private var sourceType: UIImagePickerController.SourceType?
    private var rootViewController: AGPickerController
    
    @discardableResult
    init(with controller: AGPickerController, type: UIImagePickerController.SourceType? = nil, allowsEditing: Bool, media: AGImagePickerMediaType = .photo, iPadSetup: UIView){

        self.rootViewController = controller
        self.iPadSetup = iPadSetup
        self.media = media
        super.init()
        
        self.sourceType = type
        isAllowsEditing = allowsEditing
        setupAlertController()
    }
    
    func checkPermission() {
        switch self.sourceType {
        case .some(let type):
            switch type {
            case .photoLibrary:
                if PHPhotoLibrary.authorizationStatus() == .authorized {
                    self.presentPicker(with: type)
                }
                else{
                    self.photosAccessPermission()
                }
                
            default:
                if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .authorized {
                    self.presentPicker(with: type)
                }
                else{
                    self.cameraAccessPermission()
                }
            }
            break
            
        default:
            if PHPhotoLibrary.authorizationStatus() == .notDetermined {
                self.photosAccessPermission()
            }
            else if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .notDetermined {
                self.cameraAccessPermission()
            }
            else{
                let isPhotosPermision = PHPhotoLibrary.authorizationStatus() == .authorized
                let isCameraPermision = AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .authorized
                
                if isPhotosPermision && isCameraPermision {
                    setupAlertController()
                }
                else if isPhotosPermision {
                    self.presentPicker(with: .photoLibrary)
                }
                else if isCameraPermision {
                    self.presentPicker(with: .camera)
                }
            }
        }
    }
    
    func photosAccessPermission() {
        
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            checkPermission()
            break
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized{
                    self.checkPermission()
                }
            })
            break
            
        default:
            AGAlertBuilder(withAlert: "App Permission Denied", message: "To re-enable, please go to Settings and turn on Photo Library Service for this app.")
                .addAction(with: "Setting", style: .default, handler: { _ in
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                    } else {
                        UIApplication.shared.openURL(URL(string:UIApplication.openSettingsURLString)!)
                    }
                })
                .show()
            break
        }
    }
    
    func cameraAccessPermission() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch authStatus {
        case .authorized:
            checkPermission()
            break
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                if granted {
                    self.checkPermission()
                }
            })
            break
            
        default:
            AGAlertBuilder(withAlert: "App Permission Denied", message: "To re-enable, please go to Settings and turn on Photo Library Service for this app.")
                .addAction(with: "Setting", style: .default, handler: { _ in
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                    } else {
                        UIApplication.shared.openURL(URL(string:UIApplication.openSettingsURLString)!)
                    }
                })
                .show()
            break
        }
    }
    
    private func presentPicker(with sourceType: UIImagePickerController.SourceType){
        
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            return
        }
        
        pickerController.delegate = rootViewController
        pickerController.mediaTypes = media.mediaTypes
        pickerController.allowsEditing = isAllowsEditing
        pickerController.modalPresentationStyle = .overFullScreen
        pickerController.sourceType = sourceType
        
        self.rootViewController.present(pickerController, animated: true, completion: nil)
    }
    
    private func setupAlertController() {
        let alert = AGAlertBuilder(withActionSheet: "Choose Option", message: "Select an option to pick an image", iPadOpen: .sourceView(iPadSetup))
        
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            alert.defaultAction(with: "Camera", handler: { (alert) in
                self.presentPicker(with: .camera)
            })
        }
        
        alert.defaultAction(with: "Photo Library") { (alert) in
            self.presentPicker(with: .photoLibrary)
        }
        
        alert.cancelAction(with: "Cancel")
        
        alert.show()
    }
    
    private var isCameraSupports: Bool {
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            return true
        }
        
        //no camera found -- alert the user.
        AGAlertBuilder(withAlert: "No Camera", message: "Sorry, this device has no camera")
            .defaultAction(with: "OK")
            .show()
        return false
    }
}


