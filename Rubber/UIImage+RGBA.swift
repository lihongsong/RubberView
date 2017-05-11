//
//  UIImage+RGBA.swift
//  Rubber
//
//  Created by 李泓松 on 2017/5/10.
//  Copyright © 2017年 yoser. All rights reserved.
//

import UIKit
import CoreGraphics

extension UIImage {
    
    
    static func createImageWithData(_ data:UnsafePointer<CUnsignedChar>, size:CGSize) -> UIImage? {
        
        let colorSpaceRef:CGColorSpace = CGColorSpaceCreateDeviceRGB()
        
        // UnsafePointer<Pointee> -> OpaquePointer -> UnsafeRawPoint
        let opaquePointer = OpaquePointer(data)
        let rawData = UnsafeMutableRawPointer(opaquePointer)
        let context = CGContext(data: rawData,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: 8,
                                bytesPerRow: Int(size.width) * 4,
                                space: colorSpaceRef,
                                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        if let bitmapContext = context {
            let cgImage:CGImage? = bitmapContext.makeImage()
            if let cgImage = cgImage {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }
    
    static func getDataWithImage(_ image:UIImage) -> UnsafePointer<CUnsignedChar>?{
    
        let imageRef = image.cgImage
        
        if let imageRef = imageRef {
            
            // Image -> CFData -> NSData
            let dataProvider = imageRef.dataProvider
            let dataRef:CFData? = dataProvider!.data
            let dataImg:NSData = NSData(data: dataRef! as Data)
            
            // UnsafeRawPoint -> OpaquePointer -> UnsafePointer<Pointee>
            let rawPoint = dataImg.bytes
            let opaquePoint = OpaquePointer(rawPoint)
            return  UnsafePointer<CUnsignedChar>(opaquePoint)
        }
        return nil
    }
    
}
