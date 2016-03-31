//
//  BubbleTransition.swift
//  BubblUp
//
//  Created by WUSTL STS on 3/24/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit

public class BubbleTransition: NSObject {
    
    /**
     The point that originates the bubble. The bubble starts from this point
     and shrinks to it on dismiss
     */
    public var startingPoint = CGPointZero {
        didSet {
            bubble.center = startingPoint
        }
    }
    
    /**
     The transition duration. The same value is used in both the Present or Dismiss actions
     Defaults to `0.5`
     */
    public var duration = 0.5
    
    /**
     The transition direction. Possible values `.Present`, `.Dismiss` or `.Pop`
     Defaults to `.Present`
     */
    public var transitionMode: BubbleTransitionMode = .Present
    
    /**
     The transition type. Possible values `.Audio`, `.Photo` or `.Video`
     Defaults to `.Audio`
     */
    public var transitionType: BubbleTransitionType = .Text
    
    
    /**
     The color of the bubble. Make sure that it matches the destination controller's background color.
     */
    public var bubbleColor: UIColor = .whiteColor()
    
    public private(set) var bubble = UIView()
    
    /**
     The possible directions of the transition.
     
     - Present: For presenting a new modal controller
     - Dismiss: For dismissing the current controller
     - Pop: For a pop animation in a navigation controller
     */
    @objc public enum BubbleTransitionMode: Int {
        case Present, Dismiss, Pop
    }
    /**
     The possible directions of the transition.
     
     - Audio: Transition to Audio VC
     - Photo: Transition to Photo VC
     - Video: Transition to Video VC
     */
    
    @objc public enum BubbleTransitionType: Int {
        case Draw, Photo, Text
    }
    
}

extension BubbleTransition: UIViewControllerAnimatedTransitioning {
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    /**
    Required by UIViewControllerAnimatedTransitioning
    */
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    /**
     Required by UIViewControllerAnimatedTransitioning
     */
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let containerView = transitionContext.containerView() else {
            return
        }
        
        if transitionMode == .Present {
            let presentedControllerView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            let originalCenter = presentedControllerView.center
            let originalSize = presentedControllerView.frame.size
            
            bubble = UIView()
            bubble.frame = frameForBubble(originalCenter, size: originalSize, start: startingPoint)
            bubble.layer.cornerRadius = bubble.frame.size.height / 2
            bubble.center = startingPoint
            bubble.transform = CGAffineTransformMakeScale(0.001, 0.001)
            bubble.backgroundColor = bubbleColor
            containerView.addSubview(bubble)
            
            presentedControllerView.center = startingPoint
            presentedControllerView.transform = CGAffineTransformMakeScale(0.001, 0.001)
            presentedControllerView.alpha = 0
            containerView.addSubview(presentedControllerView)
            
            UIView.animateWithDuration(duration, animations: {
                self.bubble.transform = CGAffineTransformIdentity
                presentedControllerView.transform = CGAffineTransformIdentity
                presentedControllerView.alpha = 1
                presentedControllerView.center = originalCenter
                }) { (_) in
                    transitionContext.completeTransition(true)
            }
        } else {
            let key = (transitionMode == .Pop) ? UITransitionContextToViewKey : UITransitionContextFromViewKey
            let returningControllerView = transitionContext.viewForKey(key)!
            let originalCenter = returningControllerView.center
            let originalSize = returningControllerView.frame.size
            
            bubble.frame = frameForBubble(originalCenter, size: originalSize, start: startingPoint)
            bubble.layer.cornerRadius = bubble.frame.size.height / 2
            bubble.center = startingPoint
            
            UIView.animateWithDuration(duration, animations: {
                self.bubble.transform = CGAffineTransformMakeScale(0.001, 0.001)
                returningControllerView.transform = CGAffineTransformMakeScale(0.001, 0.001)
                returningControllerView.center = self.startingPoint
                returningControllerView.alpha = 0
                
                if self.transitionMode == .Pop {
                    containerView.insertSubview(returningControllerView, belowSubview: returningControllerView)
                    containerView.insertSubview(self.bubble, belowSubview: returningControllerView)
                }
                }) { (_) in
                    returningControllerView.center = originalCenter;
                    returningControllerView.removeFromSuperview()
                    self.bubble.removeFromSuperview()
                    transitionContext.completeTransition(true)
            }
        }
    }
}

private extension BubbleTransition {
    private func frameForBubble(originalCenter: CGPoint, size originalSize: CGSize, start: CGPoint) -> CGRect {
        let lengthX = fmax(start.x, originalSize.width - start.x);
        let lengthY = fmax(start.y, originalSize.height - start.y)
        let offset = sqrt(lengthX * lengthX + lengthY * lengthY) * 2;
        let size = CGSize(width: offset, height: offset)
        
        return CGRect(origin: CGPointZero, size: size)
    }
}
