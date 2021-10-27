//
//  CoProgressIndicator.swift
//  CocoaUIKit
//
//  Created by nenhall on 2021/10/27.
//

import Foundation
import Cocoa


// progress bar gradient colors from top to bottom, aqua
let kProgressBarGradientColor0 = NSColor(calibratedRed:0.635, green: 0.766, blue: 0.957, alpha: 1)
let kProgressBarGradientColor1 = NSColor(calibratedRed:0.395, green: 0.647, blue: 0.935, alpha: 1)
let kProgressBarGradientColor2 = NSColor(calibratedRed:0.248, green: 0.582, blue: 0.935, alpha: 1)
let kProgressBarGradientColor3 = NSColor(calibratedRed:0.425, green: 0.7, blue: 0.947, alpha: 1)
let kProgressBarGradientColor4 = NSColor(calibratedRed:0.622, green: 0.842, blue: 0.957, alpha: 1)

// progress bar gradient colors from top to bottom,, green
let kProgressBarGreenGradientColor0 = NSColor(calibratedRed:0.787, green:0.904, blue:0.765, alpha:1.000)
let kProgressBarGreenGradientColor1 = NSColor(calibratedRed:0.562, green:0.795, blue:0.518, alpha:1.000)
let kProgressBarGreenGradientColor2 = NSColor(calibratedRed:0.460, green:0.742, blue:0.404, alpha:1.000)
let kProgressBarGreenGradientColor3 = NSColor(calibratedRed:0.546, green:0.786, blue:0.501, alpha:1.000)
let kProgressBarGreenGradientColor4 = NSColor(calibratedRed:0.732, green:0.876, blue:0.701, alpha:1.000)

// progress bar gradient colors from top to bottom, red
let kProgressBarRedGradientColor0 = NSColor(calibratedRed:0.873, green:0.637, blue:0.643, alpha:1.000)
let kProgressBarRedGradientColor1 = NSColor(calibratedRed:0.761, green:0.344, blue:0.357, alpha:1.000)
let kProgressBarRedGradientColor2 = NSColor(calibratedRed:0.729, green:0.263, blue:0.279, alpha:1.000)
let kProgressBarRedGradientColor3 = NSColor(calibratedRed:0.780, green:0.396, blue:0.408, alpha:1.000)
let kProgressBarRedGradientColor4 = NSColor(calibratedRed:0.853, green:0.583, blue:0.590, alpha:1.000)

// progress bar gradient colors from top to bottom, pink
let kProgressBarPinkGradientColor0 = NSColor(calibratedRed:0.860, green:0.708, blue:0.811, alpha:1.000)
let kProgressBarPinkGradientColor1 = NSColor(calibratedRed:0.801, green:0.552, blue:0.714, alpha:1.000)
let kProgressBarPinkGradientColor2 = NSColor(calibratedRed:0.777, green:0.473, blue:0.669, alpha:1.000)
let kProgressBarPinkGradientColor3 = NSColor(calibratedRed:0.820, green:0.592, blue:0.751, alpha:1.000)
let kProgressBarPinkGradientColor4 = NSColor(calibratedRed:0.894, green:0.739, blue:0.864, alpha:1.000)

// progress bar gradient colors from top to bottom, orange
let kProgressBarOrangeGradientColor0 = NSColor(calibratedRed:0.926, green:0.682, blue:0.535, alpha:1.000)
let kProgressBarOrangeGradientColor1 = NSColor(calibratedRed:0.885, green:0.522, blue:0.320, alpha:1.000)
let kProgressBarOrangeGradientColor2 = NSColor(calibratedRed:0.865, green:0.446, blue:0.225, alpha:1.000)
let kProgressBarOrangeGradientColor3 = NSColor(calibratedRed:0.885, green:0.526, blue:0.332, alpha:1.000)
let kProgressBarOrangeGradientColor4 = NSColor(calibratedRed:0.936, green:0.727, blue:0.604, alpha:1.000)

// progress bar gradient colors from top to bottom, graphite
let kProgressBarGraphiteGradientColor0 = NSColor(calibratedRed:0.688, green:0.718, blue:0.765, alpha:1.000)
let kProgressBarGraphiteGradientColor1 = NSColor(calibratedRed:0.527, green:0.580, blue:0.646, alpha:1.000)
let kProgressBarGraphiteGradientColor2 = NSColor(calibratedRed:0.448, green:0.511, blue:0.598, alpha:1.000)
let kProgressBarGraphiteGradientColor3 = NSColor(calibratedRed:0.493, green:0.554, blue:0.633, alpha:1.000)
let kProgressBarGraphiteGradientColor4 = NSColor(calibratedRed:0.729, green:0.779, blue:0.807, alpha:1.000)

// progress bar gradient colors from top to bottom, inactive window
let kProgressBarInactiveGradientColor0 = NSColor(calibratedWhite:0.845, alpha:1.000)
let kProgressBarInactiveGradientColor1 = NSColor(calibratedWhite:0.737, alpha:1.000)
let kProgressBarInactiveGradientColor2 = NSColor(calibratedWhite:0.665, alpha:1.000)
let kProgressBarInactiveGradientColor3 = NSColor(calibratedWhite:0.585, alpha:1.000)
let kProgressBarInactiveGradientColor4 = NSColor(calibratedRed:0.53, green: 0.587, blue: 0.662, alpha: 1)

// progress bar inner shadow, aqua
let kProgressBarInnerShadowColor = NSColor(calibratedRed:1, green: 1, blue: 1, alpha: 0.293)

// progress bar inner shadow, graphite
let kProgressBarGraphiteInnerShadowColor = NSColor(calibratedRed:0.776, green: 0.801, blue: 0.828, alpha: 1)

// line after progress bar gradient colors from top to bottom
let kProgressBarProgressLineGradient0 = NSColor(calibratedRed:0.742, green: 0.742, blue: 0.742, alpha: 1)
let kProgressBarProgressLineGradient1 = NSColor(calibratedRed:0.463, green: 0.463, blue: 0.463, alpha: 1)


enum GRProgressIndicatorTheme {
    case `default`
    case forceGraphite
    case green
    case red
    case pink
    case orange
    case custom(_ color: NSColor)
}

class GRProgressIndicator: NSView {
    
    // cached data
    var particleGrad1: NSColor? = nil
    var particleGrad2: NSColor? = nil
    var particleGradient: NSGradient? = nil
    var progressBarInnerShadow: NSShadow? = nil
    var progressBarGradient: NSGradient? = nil
    var progressBarLineGradient: NSGradient? = nil
    var indeterminateGradientColor0: NSColor? = nil
    var indeterminateGradientColor1: NSColor? = nil
    var indeterminateGradientColor2: NSColor? = nil
    var indeterminateGradientColor3: NSColor? = nil
    var indeterminateGradient: NSGradient? = nil
    
    // theme colors
    var gradientColor0: NSColor = kProgressBarGraphiteGradientColor0
    var gradientColor1: NSColor = kProgressBarGraphiteGradientColor1
    var gradientColor2: NSColor = kProgressBarGraphiteGradientColor2
    var gradientColor3: NSColor = kProgressBarGraphiteGradientColor3
    var gradientColor4: NSColor = kProgressBarGraphiteGradientColor4
    var graphiteGradientColor0: NSColor = kProgressBarGraphiteGradientColor0
    var graphiteGradientColor1: NSColor = kProgressBarGraphiteGradientColor0
    var graphiteGradientColor2: NSColor = kProgressBarGraphiteGradientColor2
    var graphiteGradientColor3: NSColor = kProgressBarGraphiteGradientColor3
    var graphiteGradientColor4: NSColor = kProgressBarGraphiteGradientColor4
    var inactiveGradientColor0: NSColor = kProgressBarInactiveGradientColor0
    var inactiveGradientColor1: NSColor = kProgressBarInactiveGradientColor1
    var inactiveGradientColor2: NSColor = kProgressBarInactiveGradientColor2
    var inactiveGradientColor3: NSColor = kProgressBarInactiveGradientColor3
    var inactiveGradientColor4: NSColor = kProgressBarInactiveGradientColor4
    
    // defines if we are currently animating or not
    var animating: Bool = false
    
    // animation counter
    var currentAnimationStep: Int = 0
    
     var doubleValue = 0.0 {
        didSet {
            if doubleValue > self.doubleValue && !self.isIndeterminate {
                self.animator().internalDoubleValue = doubleValue;
            } else {
                self.internalDoubleValue = doubleValue;
            }
        }
    }
    var minValue = 0.0
    var maxValue = 0.0
    var indeterminate = false
    var theme: GRProgressIndicatorTheme = .default {
        didSet {
            setupTheme()
            progressBarGradient = nil
        }
    }
    var isIndeterminate: Bool = false
    var internalDoubleValue: Double = 0.0 {
        didSet {
            if(!animating) { needsDisplay = true }
        }
    }
    var animationDuration = 0.3
    var particleWidth: CGFloat = 34
    var particleSpacing: CGFloat = 15
    var animationSleepInterval: TimeInterval = 0.02
    var barCornerRadius: CGFloat = 3.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // setup defaults
        minValue = 0
        maxValue = 100
        doubleValue = 0
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        // setup defaults
        minValue = 0
        maxValue = 100
        doubleValue = 0
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func setupTheme() {
        switch theme {
        case .forceGraphite:
            gradientColor0 = kProgressBarGraphiteGradientColor0
            gradientColor1 = kProgressBarGraphiteGradientColor1
            gradientColor2 = kProgressBarGraphiteGradientColor2
            gradientColor3 = kProgressBarGraphiteGradientColor3
            gradientColor4 = kProgressBarGraphiteGradientColor4
            graphiteGradientColor0 = kProgressBarGraphiteGradientColor0
            graphiteGradientColor1 = kProgressBarGraphiteGradientColor1
            graphiteGradientColor2 = kProgressBarGraphiteGradientColor2
            graphiteGradientColor3 = kProgressBarGraphiteGradientColor3
            graphiteGradientColor4 = kProgressBarGraphiteGradientColor4
            inactiveGradientColor0 = kProgressBarInactiveGradientColor0
            inactiveGradientColor1 = kProgressBarInactiveGradientColor1
            inactiveGradientColor2 = kProgressBarInactiveGradientColor2
            inactiveGradientColor3 = kProgressBarInactiveGradientColor3
            inactiveGradientColor4 = kProgressBarInactiveGradientColor4
        case .green:
            gradientColor0 = kProgressBarGreenGradientColor0;
            gradientColor1 = kProgressBarGreenGradientColor1;
            gradientColor2 = kProgressBarGreenGradientColor2;
            gradientColor3 = kProgressBarGreenGradientColor3;
            gradientColor4 = kProgressBarGreenGradientColor4;
            graphiteGradientColor0 = kProgressBarGraphiteGradientColor0;
            graphiteGradientColor1 = kProgressBarGraphiteGradientColor1;
            graphiteGradientColor2 = kProgressBarGraphiteGradientColor2;
            graphiteGradientColor3 = kProgressBarGraphiteGradientColor3;
            graphiteGradientColor4 = kProgressBarGraphiteGradientColor4;
            inactiveGradientColor0 = kProgressBarInactiveGradientColor0;
            inactiveGradientColor1 = kProgressBarInactiveGradientColor1;
            inactiveGradientColor2 = kProgressBarInactiveGradientColor2;
            inactiveGradientColor3 = kProgressBarInactiveGradientColor3;
            inactiveGradientColor4 = kProgressBarInactiveGradientColor4;
        case .red:
            gradientColor0 = kProgressBarRedGradientColor0;
            gradientColor1 = kProgressBarRedGradientColor1;
            gradientColor2 = kProgressBarRedGradientColor2;
            gradientColor3 = kProgressBarRedGradientColor3;
            gradientColor4 = kProgressBarRedGradientColor4;
            graphiteGradientColor0 = kProgressBarGraphiteGradientColor0;
            graphiteGradientColor1 = kProgressBarGraphiteGradientColor1;
            graphiteGradientColor2 = kProgressBarGraphiteGradientColor2;
            graphiteGradientColor3 = kProgressBarGraphiteGradientColor3;
            graphiteGradientColor4 = kProgressBarGraphiteGradientColor4;
            inactiveGradientColor0 = kProgressBarInactiveGradientColor0;
            inactiveGradientColor1 = kProgressBarInactiveGradientColor1;
            inactiveGradientColor2 = kProgressBarInactiveGradientColor2;
            inactiveGradientColor3 = kProgressBarInactiveGradientColor3;
            inactiveGradientColor4 = kProgressBarInactiveGradientColor4;
        case .pink:
            gradientColor0 = kProgressBarPinkGradientColor0;
            gradientColor1 = kProgressBarPinkGradientColor1;
            gradientColor2 = kProgressBarPinkGradientColor2;
            gradientColor3 = kProgressBarPinkGradientColor3;
            gradientColor4 = kProgressBarPinkGradientColor4;
            graphiteGradientColor0 = kProgressBarGraphiteGradientColor0;
            graphiteGradientColor1 = kProgressBarGraphiteGradientColor1;
            graphiteGradientColor2 = kProgressBarGraphiteGradientColor2;
            graphiteGradientColor3 = kProgressBarGraphiteGradientColor3;
            graphiteGradientColor4 = kProgressBarGraphiteGradientColor4;
            inactiveGradientColor0 = kProgressBarInactiveGradientColor0;
            inactiveGradientColor1 = kProgressBarInactiveGradientColor1;
            inactiveGradientColor2 = kProgressBarInactiveGradientColor2;
            inactiveGradientColor3 = kProgressBarInactiveGradientColor3;
            inactiveGradientColor4 = kProgressBarInactiveGradientColor4;
        case .orange:
            gradientColor0 = kProgressBarOrangeGradientColor0;
            gradientColor1 = kProgressBarOrangeGradientColor1;
            gradientColor2 = kProgressBarOrangeGradientColor2;
            gradientColor3 = kProgressBarOrangeGradientColor3;
            gradientColor4 = kProgressBarOrangeGradientColor4;
            graphiteGradientColor0 = kProgressBarGraphiteGradientColor0;
            graphiteGradientColor1 = kProgressBarGraphiteGradientColor1;
            graphiteGradientColor2 = kProgressBarGraphiteGradientColor2;
            graphiteGradientColor3 = kProgressBarGraphiteGradientColor3;
            graphiteGradientColor4 = kProgressBarGraphiteGradientColor4;
            inactiveGradientColor0 = kProgressBarInactiveGradientColor0;
            inactiveGradientColor1 = kProgressBarInactiveGradientColor1;
            inactiveGradientColor2 = kProgressBarInactiveGradientColor2;
            inactiveGradientColor3 = kProgressBarInactiveGradientColor3;
            inactiveGradientColor4 = kProgressBarInactiveGradientColor4;
        case .custom(let color):
            gradientColor0 = color;
            gradientColor1 = color;
            gradientColor2 = color;
            gradientColor3 = color;
            gradientColor4 = color;
            graphiteGradientColor0 = color;
            graphiteGradientColor1 = color;
            graphiteGradientColor2 = color;
            graphiteGradientColor3 = color;
            graphiteGradientColor4 = color;
            inactiveGradientColor0 = color;
            inactiveGradientColor1 = color;
            inactiveGradientColor2 = color;
            inactiveGradientColor3 = color;
            inactiveGradientColor4 = color;
        default:
            gradientColor0 = kProgressBarGradientColor0;
            gradientColor1 = kProgressBarGradientColor1;
            gradientColor2 = kProgressBarGradientColor2;
            gradientColor3 = kProgressBarGradientColor3;
            gradientColor4 = kProgressBarGradientColor4;
            graphiteGradientColor0 = kProgressBarGraphiteGradientColor0;
            graphiteGradientColor1 = kProgressBarGraphiteGradientColor1;
            graphiteGradientColor2 = kProgressBarGraphiteGradientColor2;
            graphiteGradientColor3 = kProgressBarGraphiteGradientColor3;
            graphiteGradientColor4 = kProgressBarGraphiteGradientColor4;
            inactiveGradientColor0 = kProgressBarInactiveGradientColor0;
            inactiveGradientColor1 = kProgressBarInactiveGradientColor1;
            inactiveGradientColor2 = kProgressBarInactiveGradientColor2;
            inactiveGradientColor3 = kProgressBarInactiveGradientColor3;
            inactiveGradientColor4 = kProgressBarInactiveGradientColor4;
        }
        if(!animating) { needsDisplay = true }
    }
    
    // setup our observation of the window's properties
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector:#selector(windowKeyChanged(_:)), name: NSWindow.didBecomeKeyNotification, object: window)
        NotificationCenter.default.addObserver(self, selector:#selector(windowKeyChanged(_:)), name: NSWindow.didResignKeyNotification, object: window)
    }
    
    @objc func windowKeyChanged(_ notification: NSNotification) {
        progressBarGradient = nil;
        
        // we avoid calling setNeedsDisplay: while animation is on to prevent glitches
        if(!animating) { needsDisplay = true }
    }

    // calculate the rect of the progress bar inside based on the current doubleValue
    func progressBarRect() -> NSRect {
        var scaledDoubleValue: Double = 0
        if indeterminate {
            scaledDoubleValue = 1.0; // 100%
        } else {
            // the below line is wrong.  It just multiplies internalDoubleValue by 1.0
            // scaledDoubleValue = internalDoubleValue*(maxValue-minValue)/maxValue-minValue;
            scaledDoubleValue = (internalDoubleValue - minValue) / (maxValue - minValue);
        }
        return NSMakeRect(0, 0, round(CGFloat(scaledDoubleValue) * NSWidth(self.frame)), NSHeight(self.frame));
    }
    
    func startAnimation(sender: AnyObject) {
        if animating { return };
        
        // detach a new thread to handle animation updates
        Thread.detachNewThreadSelector(#selector(render(_:)), toTarget:self, with:nil)
    }

    func stopAnimation(sender: AnyObject) {
        if !animating { return };
        
        animating = false;
        needsDisplay = true
    }

    override func animation(forKey key: NSAnimatablePropertyKey) -> Any? {
        // our internalDoubleValue is used to make the value increments smoother
        if key == "internalDoubleValue" {
            let animation = CABasicAnimation()
            animation.duration = animationDuration;
            return animation;
        }
        return super.animation(forKey: key)
    }
    
    // animation thread loop
    @objc func render(_ sender: AnyObject) {
        autoreleasepool {
            // we are now animating
            animating = true
            
            // animation loop
            while (animating) {
                // the animation happens until it's walked back the width of a particle,
                // when this is the case, the frame will look the same as in the start, so we go back and loop
                if CGFloat(currentAnimationStep) >= particleWidth {
                    currentAnimationStep = 0
                }

                currentAnimationStep += 1
                
                // render the view in the main thread
                
                DispatchQueue.main.async(execute: {
                    self.needsDisplay = true
                })
                
                // delay to control framerate
                Thread.sleep(forTimeInterval: animationSleepInterval)
            }
            
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        // draw bezel using nine images
//        NSDrawNinePartImage(dirtyRect, bezelTopLeftCorner, bezelTopEdgeFill, bezelTopRightCorner, bezelLeftEdgeFill, bezelCenterFill, bezelRightEdgeFill, bezelBottomLeftCorner, bezelBottomEdgeFill, bezelBottomRightCorner, .sourceOver, 1.0, false)
       
        barCornerRadius = NSHeight(progressBarRect()) * 0.5
        // this will limit our drawing to the inside of the bezel
        let clipRect = NSMakeRect(0, 0, NSWidth(self.frame), NSHeight(progressBarRect()));
        let path = NSBezierPath(roundedRect: clipRect, xRadius: barCornerRadius, yRadius: barCornerRadius)
        path.addClip()
        NSColor.gray.setFill()
        path.fill()

        // draw progress bar
        drawProgressBar()
        
        // draw particle animation step if needed
        if(animating) {
            if (!self.isIndeterminate) {
                drawAnimationStep()
            } else {
               drawIndeterminateAnimationStep()
            }
        }
    }

    // this method is responsible of drawing the progress bar itself
    func drawProgressBar() {
        if self.doubleValue <= 0 { return };
        
        let progressBarRect = self.progressBarRect()
        
        // the progress bar innner shadow
        if (progressBarInnerShadow == nil) {
            progressBarInnerShadow = NSShadow()
            progressBarInnerShadow?.shadowOffset = NSMakeSize(0.1, -1.1)
            progressBarInnerShadow?.shadowBlurRadius = 1
        }
        
        // determine the correct gradient and shadow colors based on
        // the window's key state, the system's appearance preferences and current theme
        if progressBarGradient == nil {
            if window?.isKeyWindow ?? false {
                if NSColor.currentControlTint == NSControlTint.graphiteControlTint {
                    progressBarInnerShadow?.shadowColor = kProgressBarGraphiteInnerShadowColor
                    progressBarGradient = NSGradient(colorsAndLocations:
                                                        (graphiteGradientColor0, 0.0),
                                                     (graphiteGradientColor1, 0.48),
                                                     (graphiteGradientColor2, 0.49),
                                                     (graphiteGradientColor3, 0.82),
                                                     (graphiteGradientColor4, 1.0))
                } else {
                    progressBarInnerShadow?.shadowColor = kProgressBarInnerShadowColor
                    progressBarGradient = NSGradient(colorsAndLocations:
                                (gradientColor0, 0.0),
                                (gradientColor1, 0.48),
                                (gradientColor2, 0.49),
                                (gradientColor3, 0.82),
                                (gradientColor4, 1.0))
                }
            } else {
                progressBarInnerShadow?.shadowColor = kProgressBarInnerShadowColor
                progressBarGradient = NSGradient(colorsAndLocations:
                            (inactiveGradientColor0, 0.0),
                            (inactiveGradientColor1, 0.48),
                            (inactiveGradientColor2, 0.49),
                            (inactiveGradientColor3, 1.0))
            }
        }
        
        // the progress bar rectangle
        let rectanglePath = NSBezierPath(rect: progressBarRect)
        progressBarGradient?.draw(in: rectanglePath, angle: -90)
        
        // this huge code section is used to draw a tiny whiteish inner shadow
        var roundedRectangleBorderRect = NSInsetRect(rectanglePath.bounds, -(progressBarInnerShadow?.shadowBlurRadius ?? 0), -(progressBarInnerShadow?.shadowBlurRadius ?? 0));
        roundedRectangleBorderRect = NSOffsetRect(roundedRectangleBorderRect, -(progressBarInnerShadow?.shadowOffset.width ?? 0), -(progressBarInnerShadow?.shadowOffset.height ?? 0));
        roundedRectangleBorderRect = NSInsetRect(NSUnionRect(roundedRectangleBorderRect, rectanglePath.bounds), -1, -1);
        
        let roundedRectangleNegativePath = NSBezierPath(rect: roundedRectangleBorderRect)
        roundedRectangleNegativePath.append(rectanglePath)
        roundedRectangleNegativePath.windingRule = .evenOdd
        
        NSGraphicsContext.saveGraphicsState()
        do {
            if let shadowWithOffset = progressBarInnerShadow?.copy as? NSShadow {
                let xOffset: CGFloat = shadowWithOffset.shadowOffset.width + round(roundedRectangleBorderRect.size.width);
                let yOffset: CGFloat = shadowWithOffset.shadowOffset.height;
                shadowWithOffset.shadowOffset = NSMakeSize(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset));
                shadowWithOffset.set()
                NSColor.orange.setFill()
                rectanglePath.addClip()
                let transform = NSAffineTransform()
                transform.translateX(by: -round(roundedRectangleBorderRect.size.width), yBy: 0)
                transform.transform(roundedRectangleNegativePath).fill()
            }
        }
        NSGraphicsContext.restoreGraphicsState()
        
        // draw line after progress bar
        if progressBarLineGradient == nil {
            progressBarLineGradient = NSGradient(starting: kProgressBarProgressLineGradient0, ending: kProgressBarProgressLineGradient1)
        }

        let progressLinePath = NSBezierPath(rect: NSMakeRect(NSWidth(progressBarRect), progressBarRect.origin.y, 1, NSHeight(progressBarRect)))
//        progressBarLineGradient?.draw(in: progressLinePath, angle: 90)
    }


    // this method is responsible of drawing the aqua "water" particles animation
    func drawAnimationStep() {
        // initialize colors and gradient only once
        if particleGrad1 == nil {
            particleGrad1 = NSColor(calibratedRed: 1, green: 1, blue: 1, alpha: 0.07)
            particleGrad2 = NSColor(calibratedRed: 1, green: 1, blue: 1, alpha: 0)
            particleGradient = NSGradient(starting: particleGrad1!, ending: particleGrad2!)
        }

        // get progress rect and check if it's empty
        var progressBarRect = self.progressBarRect()
        let progressPath = NSBezierPath(roundedRect: progressBarRect, xRadius:barCornerRadius, yRadius:barCornerRadius)
        // if the rect is empty we don't do anything
        if progressPath.isEmpty { return }
        
        // limits the drawing of the particles to be only inside the progress area
        progressPath.addClip()
        
        // calculate how many particles we can fit inside the progress rect and add some extra for good luck :P
        let particlePitch = round(NSWidth(progressBarRect) / particleWidth) + 2
        
        // value used to calculate the X position of a particle
        let particleDelta: CGFloat = particleWidth + particleSpacing - particleWidth / 2
        for i in 0..<Int(particlePitch) {
            // calculate X position of particle
            let particleX: CGFloat = CGFloat((i * Int(particleDelta)) - currentAnimationStep)
            
            // make circle used do draw the particle's gradient
            let particlePath = NSBezierPath(ovalIn: NSMakeRect(particleX, 3, particleWidth, 15))
            NSGraphicsContext.saveGraphicsState()
            NSGraphicsContext.current?.compositingOperation = .plusLighter
            particlePath.addClip()
            
            // draw particle gradient
            let gradientPoint = NSMakePoint(particleX + 17, NSHeight(self.frame) / 2.0);
            let options: NSGradient.DrawingOptions = [.drawsBeforeStartingLocation, .drawsAfterEndingLocation]
            particleGradient?.draw(fromCenter: gradientPoint, radius: 0,
                            toCenter: gradientPoint, radius: 12.72,
                             options: options)
            
            NSGraphicsContext.restoreGraphicsState()
        }
    }

    // this method is responsible of drawing the stripes animation when the PI is indeterminate
    func drawIndeterminateAnimationStep() {
        
        let kIndeterminateParticleWidth: CGFloat = 34.0
        let kIndeterminateParticleSpacing: CGFloat = 16.0
        
        if indeterminateGradient == nil {
            indeterminateGradientColor0 = NSColor(calibratedRed: 0.917, green: 0.917, blue: 0.916, alpha: 1)
            indeterminateGradientColor1 = NSColor(calibratedRed: 1, green: 1, blue: 1, alpha: 1)
            indeterminateGradientColor2 = NSColor(calibratedRed: 0.951, green: 0.951, blue: 0.951, alpha: 1)
            indeterminateGradientColor3 = NSColor(calibratedRed: 0.907, green: 0.907, blue: 0.907, alpha: 1)
            
            self.indeterminateGradient = NSGradient(colorsAndLocations:
                                      (indeterminateGradientColor0!, 0.0),
                                      (indeterminateGradientColor1!, 0.48),
                                      (indeterminateGradientColor2!, 0.49),
                                      (indeterminateGradientColor3!, 1.0))
        }
        
        let progressBarRect = self.progressBarRect()
        let particlePitch: CGFloat = round(NSWidth(progressBarRect) / CGFloat(kIndeterminateParticleWidth)) + 2
        let particleDelta: CGFloat = CGFloat(kIndeterminateParticleWidth + kIndeterminateParticleSpacing - kIndeterminateParticleWidth / 2)
        
        for i in 0..<Int(particlePitch) {
            let particleX: CGFloat = CGFloat((i * Int(particleDelta)) + currentAnimationStep)
            
            let particlePath = NSBezierPath()
            particlePath.move(to: NSMakePoint(particleX - 10, NSHeight(self.frame)))
            particlePath.line(to: NSMakePoint(particleX + kIndeterminateParticleWidth / 2 - 30, NSHeight(self.frame)))
            particlePath.line(to: NSMakePoint(particleX + kIndeterminateParticleWidth - 30, 0))
            particlePath.line(to: NSMakePoint(particleX + kIndeterminateParticleWidth / 2 - 30, 0))
            particlePath.line(to: NSMakePoint(particleX - 30, NSHeight(self.frame)))
            particlePath.close()
            
            indeterminateGradient?.draw(in: particlePath, angle: -90)
        }
    }
}
