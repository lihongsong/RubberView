//
//  RubberView.swift
//  Rubber
//
//  Created by yoser on 2017/5/10.
//  Copyright © 2017年 yoser. All rights reserved.
//

import UIKit

infix operator <->:ATPrecedence

precedencegroup ATPrecedence{
    associativity:left
    higherThan:MultiplicationPrecedence
}

func <-> (lhs:CGPoint,rhs:CGPoint) -> Int {
    return Int(sqrt(pow((lhs.x - rhs.x), 2) + pow((lhs.y - rhs.y), 2)))
}

class RubberView: UIView {
    
    var sourceColor:UIColor? {
        didSet{
            sourceImage = RubberView.getImageByColor(sourceColor ?? UIColor.clear, size: self.frame.size)
        }
    }
    
    var rubberImage:UIImage?
    
    var clearRadius:Int = 5 {
        didSet{
            rubberImage = RubberView.getRubberRoundImageByRadius(raduis: clearRadius)
        }
    }
    
    private var backImageView:UIImageView = UIImageView()

    var sourceImage:UIImage? {
        didSet{
            backImageView.image = sourceImage
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.backImageView)
        self.rubberImage = RubberView.getRubberRoundImageByRadius(raduis: clearRadius)
        self.backgroundColor = UIColor.clear
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(self.backImageView)
        self.rubberImage = RubberView.getRubberRoundImageByRadius(raduis: clearRadius)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backImageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchesMoved(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if sourceImage != nil && clearRadius > 0 {
            
            let size = frame.size
            let rect = bounds
            
            let touchPoint = touches.first!.location(in: self)
            let clearRect = CGRect(x: Int(touchPoint.x) - clearRadius,
                                   y: Int(touchPoint.y) - clearRadius,
                                   width: clearRadius * 2,
                                   height: clearRadius * 2)
            
            UIGraphicsBeginImageContext(size)
            let context = UIGraphicsGetCurrentContext()
            if  context != nil {
                sourceImage!.draw(in: rect, blendMode: .normal, alpha: 1)
                rubberImage!.draw(in: clearRect, blendMode: .destinationIn, alpha: 1) /* R = D*Sa */
                let image:UIImage? = UIGraphicsGetImageFromCurrentImageContext()
                if let image = image {
                    self.sourceImage = image
                }
            }
        }
    }
    
    private static func getImageByColor(_ color:UIColor ,size:CGSize) -> UIImage?{
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        if let context = context {
            context.saveGState()
            context.addRect(rect)
            context.setFillColor(color.cgColor)
            context.fillPath()
            context.restoreGState()
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }else {
            return nil
        }
    }
    
    private static func getRubberRoundImageByRadius(raduis:Int) -> UIImage? {
        
        guard raduis > 0  else {
            return nil
        }
        
        let width = raduis * 2
        let height = raduis * 2
        let byteWidthPerRow = width * 4
        
        let byteSize = width * height * 4 //R G B A
        
//        var rawpoint:UnsafeMutableRawPointer = UnsafeMutableRawPointer.allocate(bytes: byteSize, alignedTo: MemoryLayout<CUnsignedChar>.alignment)
        
        let unsignedCharPoint = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: byteSize * MemoryLayout<CUnsignedChar>.alignment);
        
//      R G B A 分布 占用8个字节 00000000 ~ 11111111 = 0 ~ 255
        
        let centerPoint = CGPoint(x: raduis, y: raduis)
        
        for  i in 0..<height{
                for j in 0..<width {
                    var pixValue:CUnsignedChar;
                    if CGPoint(x:j, y:i) <-> centerPoint < raduis {
                        pixValue = 0
                    }else{
                        pixValue = 255
                    }
                    
                    unsignedCharPoint[j * 4 + i * byteWidthPerRow + 0] = pixValue
                    unsignedCharPoint[j * 4 + i * byteWidthPerRow + 1] = pixValue
                    unsignedCharPoint[j * 4 + i * byteWidthPerRow + 2] = pixValue
                    unsignedCharPoint[j * 4 + i * byteWidthPerRow + 3] = pixValue
            }
        }
        
        let image = UIImage.createImageWithData(unsignedCharPoint, size: CGSize(width: width, height: height))
        
        return image
    }
}
