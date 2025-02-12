//
//  CameraView.swift
//  iOS14VisionHandPoseSwipe
//
//  Created by Anupam Chugh on 15/12/20.
//

import UIKit
import AVFoundation

class CameraView: UIView {

    private var overlayThumbLayer = CAShapeLayer()
    private var overlayindexLayer = CAShapeLayer()

    var previewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }

    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupOverlay()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupOverlay()
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        if layer == previewLayer {
            overlayThumbLayer.frame = layer.bounds
            overlayindexLayer.frame = layer.bounds//0505
        }
    }

    private func setupOverlay() {
        previewLayer.addSublayer(overlayThumbLayer)
        previewLayer.addSublayer(overlayindexLayer)
    }
    
    func showPoints(_ points: [CGPoint]) {
        
        guard let wrist: CGPoint = points.last else {
            // Clear all CALayers
            clearLayers()
            return
        }
        
        let thumbColor = UIColor.white
        drawFinger(overlayThumbLayer, Array(points[0...5]), thumbColor, wrist)
        drawFinger(overlayThumbLayer, Array(points[0...5]), thumbColor, wrist)
        drawFinger(overlayThumbLayer, Array(points[0...5]), thumbColor, wrist)
        drawFinger(overlayThumbLayer, Array(points[0...5]), thumbColor, wrist)
        drawFinger(overlayThumbLayer, Array(points[0...5]), thumbColor, wrist)
    }
    
    func drawFinger(_ layer: CAShapeLayer, _ points: [CGPoint], _ color: UIColor, _ wrist: CGPoint) {
        let fingerPath = UIBezierPath()
        
        for point in points {
            fingerPath.move(to: point)
            fingerPath.addArc(withCenter: point, radius: 5, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        }
        
        fingerPath.move(to: points[0])
        fingerPath.addLine(to: points[points.count - 1])
        fingerPath.move(to: points[1])
        fingerPath.addLine(to: points[points.count - 1])
        fingerPath.move(to: points[2])
        fingerPath.addLine(to: points[points.count - 1])
        fingerPath.move(to: points[3])
        fingerPath.addLine(to: points[points.count - 1])
        fingerPath.move(to: points[4])
        fingerPath.addLine(to: points[points.count - 1])
//        fingerPath.move(to: points[0])
//        fingerPath.addLine(to: points[points.count - 1])
        
        layer.fillColor = color.cgColor
        layer.strokeColor = color.cgColor
        layer.lineWidth = 5.0
        layer.lineCap = .round
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        layer.path = fingerPath.cgPath
        CATransaction.commit()
    }
    
    func clearLayers() {
        let emptyPath = UIBezierPath()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        overlayThumbLayer.path = emptyPath.cgPath
        CATransaction.commit()
    }
}
