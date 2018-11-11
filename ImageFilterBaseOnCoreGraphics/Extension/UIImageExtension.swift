//
//  UIImageExtension.swift
//  ImageFilterBaseOnCoreGraphics
//
//  Created by 周伟克 on 2018/11/9.
//  Copyright © 2018 周伟克. All rights reserved.
//

import Foundation
import CoreGraphics

extension UIImage {
    
    /// 遍历图片上像素，获取像素色彩信息
    func traversePixels(handler: ((CUnsignedChar, CUnsignedChar, CUnsignedChar, CUnsignedChar) -> (CUnsignedChar, CUnsignedChar, CUnsignedChar, CUnsignedChar))?) -> UIImage? {
        
        
        guard let cgImage = cgImage else {
            return nil
        }
        
        let ctx = CGContext(data: nil, width: cgImage.width,
                            height: cgImage.height,
                            bitsPerComponent: cgImage.bitsPerComponent,
                            bytesPerRow: cgImage.bytesPerRow,
                            space: cgImage.colorSpace ?? CGColorSpaceCreateDeviceRGB(),
                            bitmapInfo: cgImage.bitmapInfo.rawValue)!
        let drawInRect = CGRect(origin: .zero, size: self.size)
        ctx.draw(cgImage, in: drawInRect)
        let sourceData = ctx.data!
        for row in 0 ..< cgImage.height {
            for column in 0 ..< cgImage.width {
                
                let bitMapIndex = (cgImage.width * row + column) * 4 // 每个像素有4个字节
                
                let red = sourceData.load(fromByteOffset: bitMapIndex,
                                          as: CUnsignedChar.self)
                let green = sourceData.load(fromByteOffset: bitMapIndex + 1,
                                            as: CUnsignedChar.self)
                let blue = sourceData.load(fromByteOffset: bitMapIndex + 2,
                                           as: CUnsignedChar.self)
                let alpha = sourceData.load(fromByteOffset: bitMapIndex + 3,
                                            as: CUnsignedChar.self)

                if let newRGBA = handler?(red, green, blue, alpha) {

        
                    sourceData.storeBytes(of: newRGBA.0,
                                          toByteOffset: bitMapIndex,
                                          as: type(of: newRGBA.0))
                    sourceData.storeBytes(of: newRGBA.1,
                                          toByteOffset: bitMapIndex + 1,
                                          as: type(of: newRGBA.1))
                    sourceData.storeBytes(of: newRGBA.2,
                                          toByteOffset: bitMapIndex + 2,
                                          as: type(of: newRGBA.2))
                    sourceData.storeBytes(of: newRGBA.3,
                                          toByteOffset: bitMapIndex + 3,
                                          as: type(of: newRGBA.3))

                }
            }
        }
        
        let size = cgImage.bytesPerRow * cgImage.height
        let newData = malloc(size)
        memset(newData, 0, size)
        memcpy(newData, sourceData, size)
        // 直接使用ctx.data会发生野指针异常，所以必须要把ctx.data中的色彩信息拷贝到另一块内存中
        // 通过官方APIctx.image获取图片，内部应该也是开辟了新内存
        let provider = CGDataProvider.init(dataInfo: nil, data: newData!, size: size) { (dataInfo, newData, size) in
            
        }!
        
        if let newCGImage = CGImage(width: cgImage.width, height: cgImage.height,
                                    bitsPerComponent: cgImage.bitsPerComponent,
                                    bitsPerPixel: cgImage.bitsPerPixel,
                                    bytesPerRow: cgImage.bytesPerRow,
                                    space: cgImage.colorSpace ?? CGColorSpaceCreateDeviceRGB(),
                                    bitmapInfo: cgImage.bitmapInfo,
                                    provider: provider,
                                    decode: cgImage.decode,
                                    shouldInterpolate: cgImage.shouldInterpolate,
                                    intent: cgImage.renderingIntent) {
            let filteredImage = FilterImage(cgImage: newCGImage)
            filteredImage.rawData = newData
            return filteredImage
        }
        return nil
    }
    
    
    func filter(colorMatrix: [Float]) -> UIImage? {
        
        return traversePixels { (red, green, blue, alpha) -> (CUnsignedChar, CUnsignedChar, CUnsignedChar, CUnsignedChar) in
            
            let tempRed = colorMatrix[0] * Float(red) + colorMatrix[1] * Float(green) + colorMatrix[2] * Float(blue) + colorMatrix[3] * Float(alpha) + colorMatrix[4]
            let tempGreen = colorMatrix[0 + 5] * Float(red) + colorMatrix[1 + 5] * Float(green) + colorMatrix[2 + 5] * Float(blue) + colorMatrix[3 + 5] * Float(alpha) + colorMatrix[4 + 5]
            let tempBlue = colorMatrix[0 + 5 * 2] * Float(red) + colorMatrix[1 + 5 * 2] * Float(green) + colorMatrix[2 + 5 * 2] * Float(blue) + colorMatrix[3 + 5 * 2] * Float(alpha) + colorMatrix[4 + 5 * 2]
            let tempAlpha = colorMatrix[0 + 5 * 3] * Float(red) + colorMatrix[1 + 5 * 3] * Float(green) + colorMatrix[2 + 5 * 3] * Float(blue) + colorMatrix[3 + 5 * 3] * Float(alpha) + colorMatrix[4 + 5 * 3]
            let newRed = self.fixColorComponent(tempRed)
            let newGreen = self.fixColorComponent(tempGreen)
            let newBlue = self.fixColorComponent(tempBlue)
            let newAlpha = self.fixColorComponent(tempAlpha)
            return (newRed, newGreen, newBlue, newAlpha)
        }
    }
    
    /// 颜色色值限制在0 - 255
    private func fixColorComponent(_ component: Float) -> CUnsignedChar {
        if component > 255 {
            return 255
        }
        if component < 0 {
            return 0
        }
        return CUnsignedChar(component)
    }
}
