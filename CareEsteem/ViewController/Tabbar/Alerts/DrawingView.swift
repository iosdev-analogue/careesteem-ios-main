//
//  DrawingView.swift
//  CareEsteem
//
//  Created by Gaurav Gudaliya on 11/03/25.
//

import UIKit

class DrawingView: UIView {
    private var lines: [Line] = []  // Stores drawn lines
    private var undoneLines: [Line] = []  // Stores undone lines for redo
    private var currentLine: Line?
    
    var strokeColor: UIColor = .red
    var strokeWidth: CGFloat = 3.0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let newLine = Line(points: [touch.location(in: self)], color: strokeColor, width: strokeWidth)
        currentLine = newLine
        lines.append(newLine)
        undoneLines.removeAll()  // Clear redo history when new drawing is made
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let currentLine = currentLine else { return }
        currentLine.points.append(touch.location(in: self))
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentLine = nil
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        for line in lines {
            context.setStrokeColor(line.color.cgColor)
            context.setLineWidth(line.width)
            context.setLineCap(.round)
            context.beginPath()
            
            if let firstPoint = line.points.first {
                context.move(to: firstPoint)
                for point in line.points.dropFirst() {
                    context.addLine(to: point)
                }
            }
            
            context.strokePath()
        }
    }
    
    // Undo last drawing
    func undo() {
        guard !lines.isEmpty else { return }
        undoneLines.append(lines.removeLast())
        setNeedsDisplay()
    }
    
    // Redo last undone drawing
    func redo() {
        guard !undoneLines.isEmpty else { return }
        lines.append(undoneLines.removeLast())
        setNeedsDisplay()
    }
    
    // Clear all drawings
    func clear() {
        lines.removeAll()
        undoneLines.removeAll()
        setNeedsDisplay()
    }
    
    // Save image with drawings
    func mergeWithImage(_ baseImage: UIImage) -> UIImage? {
        self.renderImage()
        let image = baseImage.resizeImage(targetSize: self.bounds.size)
        let imageViewSize = self.bounds.size // Use UIImageView size
        
        UIGraphicsBeginImageContextWithOptions(imageViewSize, false, 0)
        image.draw(in: CGRect(origin: .zero, size: imageViewSize)) // Draw the base image in UIImageView size
        
        self.layer.render(in: UIGraphicsGetCurrentContext()!) // Render drawing on top
        
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return mergedImage
    }
}

// Data model for a drawn line
class Line {
    var points: [CGPoint]
    var color: UIColor
    var width: CGFloat
    
    init(points: [CGPoint], color: UIColor, width: CGFloat) {
        self.points = points
        self.color = color
        self.width = width
    }
}
