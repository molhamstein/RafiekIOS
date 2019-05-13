//
//  SVGHelper.swift
//  Al-Rafik
//
//  Created by Nour  on 4/9/19.
//  Copyright © 2019 Nour . All rights reserved.
//

import Foundation
import SVGKit
import PocketSVG

public class SVGManager{
    public var url:URL?
    public var svgContent:String?
    public var actions:[Action] = []
    
    public static var shared = SVGManager()
    
    public init(){}
    
   public init(url:URL) {
        self.url = url
    }
    
    public init(svgContent:String){
        self.svgContent = svgContent
    }
    
    
    public func viewBox(with url:URL) -> CGSize{
        let image = SVGKImage(contentsOf: url)
        let box = image?.domTree.viewBox
        guard let width = box?.width ,  let height = box?.height else { return CGSize()}
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
    
    public func viewBox(with content:String) -> CGSize{
        let image = SVGKImage(source: svgSource(of: content))
        let box = image?.domTree.viewBox
        guard let width = box?.width ,  let height = box?.height else { return CGSize()}
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }

    public func svgSource(of url:URL) -> SVGKSource{
        return SVGKSourceURL.source(from: url)
    }
    
    
    public func svgSource(of content:String) -> SVGKSource{
        return SVGKSourceString.source(fromContentsOf: content)
    }
    
    public func paths(of url:URL) -> [SVGBezierPath]{
        return SVGBezierPath.pathsFromSVG(at: url)
    }

    public func paths(of content:String) -> [SVGBezierPath]{
        return SVGBezierPath.paths(fromSVGString: content)
    }
    
    public func drawSVG(of url:URL,containerView:UIView) ->[SVGLayer]{

        var layers = [SVGLayer]()
        for path in paths(of: url) {
            // Create a layer for each path
            let layer = SVGLayer()
            layer.path = path.cgPath
            // Default Settings
            var strokeWidth = CGFloat(4.0)
            var strokeColor = UIColor.black.cgColor
            var fillColor = UIColor.white.cgColor
            // Inspect the SVG Path Attributes
            print("path.svgAttributes = \(path.svgAttributes)")
            if let strokeValue = path.svgAttributes["stroke-width"] {
                if let strokeN = NumberFormatter().number(from: strokeValue as! String) {
                    strokeWidth = CGFloat(truncating: strokeN)
                }
            }
            if let strokeValue = path.svgAttributes["stroke"] {
                strokeColor = strokeValue as! CGColor
            }
            if let fillColorVal = path.svgAttributes["fill"] {
                fillColor = fillColorVal as! CGColor
            }
            
            if let id = path.svgAttributes["id"] as? String{
                print("id \(id)")
                layer.id = id
            }
            // Set its display properties
            layer.lineWidth = strokeWidth
            layer.strokeColor = strokeColor
            layer.fillColor = fillColor
    
            let scaleFactor = getRatio(viewBox: viewBox(with: url), bounds: containerView.bounds)
            var affineTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
            let transformedPath = layer.path?.copy(using: &affineTransform)
            layer.path = transformedPath
            
            // Add it to the layer hierarchy
            layers.append(layer)
        }
     
        return layers
    }
    
    
    public func drawSVG(of content:String,containerView:UIView) ->[SVGLayer]{
      
    //    let Layer = CALayer()
        var layers = [SVGLayer]()
        for path in paths(of: content) {
            // Create a layer for each path
            let layer = SVGLayer()
            layer.path = path.cgPath
            // Default Settings
            var strokeWidth = CGFloat(4.0)
            var strokeColor = UIColor.black.cgColor
            var fillColor = UIColor.white.cgColor
            // Inspect the SVG Path Attributes
            print("path.svgAttributes = \(path.svgAttributes)")
            if let strokeValue = path.svgAttributes["stroke-width"] {
                if let strokeN = NumberFormatter().number(from: strokeValue as! String) {
                    strokeWidth = CGFloat(truncating: strokeN)
                }
            }
            if let strokeValue = path.svgAttributes["stroke"] {
                strokeColor = strokeValue as! CGColor
            }
            if let fillColorVal = path.svgAttributes["fill"] {
                fillColor = fillColorVal as! CGColor
            }
            
            if let id = path.svgAttributes["id"] as? String{
                print("id \(id)")
                layer.id = id
            }
            
            // Set its display properties
            layer.lineWidth = strokeWidth
            layer.strokeColor = strokeColor
            layer.fillColor = fillColor
            
            let scaleFactor = getRatio(viewBox: viewBox(with: content), bounds: containerView.bounds)
            var affineTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
            let transformedPath = layer.path?.copy(using: &affineTransform)
            layer.path = transformedPath
            
            // Add it to the layer hierarchy
            layers.append(layer)
        }
        return layers
    }
    
    
    func getRatio(viewBox:CGSize,bounds:CGRect) ->CGFloat{
        
        let width = viewBox.width
        let height = viewBox.height
        
        let boundingBoxAspectRatio = width / height
        let viewAspectRatio =  bounds.width/bounds.height
        
        let scaleFactor: CGFloat
        if (boundingBoxAspectRatio > viewAspectRatio) {
            // Width is limiting factor
            scaleFactor = bounds.width / width
        } else {
            // Height is limiting factor
            scaleFactor = bounds.height / height
        }
        return scaleFactor
        
    }
    
    
}
