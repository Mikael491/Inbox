//
//  BubbleImageView.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 11/22/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import UIKit

class BubbleImageView: UIImageView {
    
   private var bubbleImageName = "MessageBubble"

    func incomingBubble() {
        let image = UIImage(named: bubbleImageName)!
        let flippedImage = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: .upMirrored)
        let incoming = coloredImage(image: flippedImage, red: 211/255, green: 211/255, blue: 211/255, alpha: 1.0)
        self.image = incoming
    }
    
    func outgoingBubble() {
        let image = UIImage(named: bubbleImageName)!
        let outgoing = coloredImage(image: image, red: 33/255, green: 150/255, blue: 243/255, alpha: 1.0)
        self.image = outgoing
    }
    
    func coloredImage(image: UIImage, red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIImage! {
        
        let rect = CGRect(origin: CGPoint.zero, size: image.size)
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let context = UIGraphicsGetCurrentContext()
        image.draw(in: rect)
        
        context?.setFillColor(red: red, green: green, blue: blue, alpha: alpha)
        context?.setBlendMode(.sourceAtop)
        context?.fill(rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }

}
