//
//  EditImageViewController.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 11/03/25.
//


import UIKit

class EditImageViewController: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var drawingView: DrawingView!
    @IBOutlet weak var mainView: UIView!
   
    @IBOutlet weak var stack: UIStackView!
    var selectedImage:SelectedBodyPart?
    var updatedHandler:((SelectedBodyPart?)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = UIImage(named: self.selectedImage?.image ?? "")
        self.drawingView.strokeColor = UIColor(named: "appGreen") ?? .green
        self.lblName.text = self.selectedImage?.name
        stack.clipsToBounds = true
        stack.layer.cornerRadius = 8
        stack.layer.borderColor = UIColor(named: "appGreen")?.cgColor
        stack.layer.borderWidth = 1
        
    }
    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    @IBAction func undoDrawingAction(_ sender : UIButton){
        drawingView.undo()
    }
    @IBAction func redoDrawingAction(_ sender : UIButton){
        drawingView.redo()
    }
    @IBAction func closeAction(_ sender : UIButton){
        self.dismiss(animated: true)
    }
    @IBAction func saveAction(_ sender : UIButton){
       // guard let baseImage = self.imageView.image, let mergedImage = drawingView.mergeWithImage(baseImage) else { return }
        self.selectedImage?.updatedImage = self.mainView.renderImage()
        self.updatedHandler?(self.selectedImage)
        self.dismiss(animated: true)
    }
}
