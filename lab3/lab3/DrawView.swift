//
//  DrawView.swift
//  lab3
//
//  Created by David Schonfeld on 2/15/17.
//  Copyright © 2017 schon. All rights reserved.
//

import Foundation

import UIKit

class DrawView: UIView {


  var theCircle:Circle? {
    didSet {
      setNeedsDisplay()
    }
  }
  
  var theLine:LineOb? {
    didSet {
      setNeedsDisplay()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.clear
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  

  override func draw(_ rect: CGRect){
    
    //Drawing the circle(s)
    let path = UIBezierPath()
    
    var currentCircleColor: UIColor = theCircle!.color
    currentCircleColor.withAlphaComponent(theCircle!.opacity)
    currentCircleColor.setFill()
    currentCircleColor.setStroke()
    
    //Note: The following 2 lines is from the drawCircles demo in class
    path.addArc(withCenter: theCircle!.center, radius: theCircle!.radius, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
    path.fill()
    
//    Drawing the line(s)
    if theLine != nil {
      var currentLineColor: UIColor = theLine!.color
      currentLineColor.withAlphaComponent(theLine!.opacity)
      currentLineColor.setFill()
      currentLineColor.setStroke()
      
      print("DRAW: theColor: \(theLine?.color)")
      
      let path2 = createQuadPath(points: (theLine?.points)!)
      path2.lineWidth = (theCircle!.radius*2)
      path2.lineCapStyle = .round
      path2.lineJoinStyle = .round
      path2.stroke()
    }
    
    
  }
  
  
  private func midpoint(first: CGPoint, second: CGPoint) -> CGPoint {
    return CGPoint(x:((first.x + second.x)/2), y:((first.y+second.y)/2))
  }
  
  //Provided by the assignment sheet
  func createQuadPath(points: [CGPoint]) -> UIBezierPath {
    let path = UIBezierPath()
    if points.count < 2 { return path }
    let firstPoint = points[0]
    let secondPoint = points[1]
    let firstMidpoint = midpoint(first: firstPoint, second: secondPoint)
    path.move(to: firstPoint)
    path.addLine(to: firstMidpoint)
    for index in 1 ..< points.count-1 {
      let currentPoint = points[index]
      let nextPoint = points[index + 1]
      let midPoint = midpoint(first: currentPoint, second: nextPoint)
      path.addQuadCurve(to: midPoint, controlPoint: currentPoint)
    }
    guard let lastLocation = points.last else { return path }
    path.addLine(to: lastLocation)
    return path
  }
  
  
}
