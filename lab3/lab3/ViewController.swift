//
//  ViewController.swift
//  lab3
//
//  Created by David Schonfeld on 2/15/17.
//  Copyright © 2017 schon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  //Variables to Use
  var current_DrawView: DrawView?
  var current_CircleCenter = CGPoint.zero
  
  var current_BrushSize: CGFloat = 10
  var current_BrushColor = UIColor.init(red: 148/255.00, green: 17/255.00, blue: 0/255.00, alpha: 1.0) //Red
  var current_BrushOpacity: CGFloat = 1.0
  
  var current_BrushColor_Red: CGFloat = 148/255.00
  var current_BrushColor_Green: CGFloat = 17/255.00
  var current_BrushColor_Blue: CGFloat = 0/255.00
  
  var temp_initThatLine = false
  var temp_startPoint = CGPoint.zero
  
  
 
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    //Set the Background Color
    view.backgroundColor = UIColor.clear
    
    //Correct Visuals for Brush Size Slider
    BrushSizeSlider.value = Float(current_BrushSize)
    updateBrushSizeSliderColor(inRed: 148/255.0, inGreen: 17/255.0, inBlue: 0/255.0);
    
    //Correct Visuals for Opacity Slider
    OpacitySlider.value = 1.0 //Because we always start with a non-transparent color to make it less confusing for the users
    updateOpacitySliderColor(inRed: 0, inGreen: 0, inBlue: 0);
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  
  //Outlets and Actions
  
  //Outlets
  @IBOutlet weak var BrushSizeSlider: UISlider!
  @IBOutlet weak var OpacitySlider: UISlider!
  
  //Button Actions
  
  //Brush Size
  @IBAction func BrushSizeSliderChanged(_ sender: UISlider) {
    current_BrushSize = CGFloat(sender.value)
  }
  
  @IBAction func OpacitySliderChanged(_ sender: UISlider) {
    let newOpacity: CGFloat = CGFloat(sender.value)
    current_BrushOpacity = newOpacity
    setCurrentBrushColor(inRed: current_BrushColor_Red, inGreen: current_BrushColor_Green, inBlue: current_BrushColor_Blue, inAlpha: newOpacity)
    updateOpacitySliderColor(inRed: 1-newOpacity, inGreen: 1-newOpacity, inBlue: 1-newOpacity)
    
  }
  
  //Undo
  @IBAction func UndoButtonPressed(_ sender: UIButton) {
    
    var lastObjectDrawnId = 0
    for v in view.subviews {
      if (v.isMember(of: DrawView.self)){
        lastObjectDrawnId += 1
      }
    }
    
    var objectIteratingId = 1
    if (lastObjectDrawnId > 0){
      for v in view.subviews {
        if (v.isMember(of: DrawView.self)){
          if (objectIteratingId==lastObjectDrawnId){
            v.removeFromSuperview()
            break
          } else {
            objectIteratingId += 1
          }
        }
      }
    }
    
  }
  
  //Clear
  @IBAction func ClearButtonPressed(_ sender: UIButton) {
    for v in view.subviews {
      print("ClearButtonPressed: v: \(v)")
      if (v.isMember(of: DrawView.self)){
        v.removeFromSuperview()
      }
    }
  }
  
  //Colors and Erasing
  @IBAction func RedClicked(_ sender: UIButton) {
    setCurrentBrushColor(inRed: 148/255.0, inGreen: 17/255.00, inBlue: 0/255.00, inAlpha: current_BrushOpacity)
  }
  @IBAction func OrangeClicked(_ sender: UIButton) {
    setCurrentBrushColor(inRed: 255/255.0, inGreen: 128/255.00, inBlue: 0/255.00, inAlpha: current_BrushOpacity)
  }
  @IBAction func YellowClicked(_ sender: UIButton) {
    setCurrentBrushColor(inRed: 250/255.0, inGreen: 246/255.00, inBlue: 2/255.00, inAlpha: current_BrushOpacity)
  }
  @IBAction func GreenClicked(_ sender: UIButton) {
    setCurrentBrushColor(inRed: 0/255.0, inGreen: 143/255.00, inBlue: 0/255.00, inAlpha: current_BrushOpacity)
  }
  @IBAction func BlueClicked(_ sender: UIButton) {
    setCurrentBrushColor(inRed: 0/255.0, inGreen: 84/255.00, inBlue: 147/255.00, inAlpha: current_BrushOpacity)
  }
  @IBAction func PurpleClicked(_ sender: UIButton) {
    setCurrentBrushColor(inRed: 49/255.0, inGreen: 16/255.00, inBlue: 90/255.00, inAlpha: current_BrushOpacity)
  }
  @IBAction func EraseClicked(_ sender: UIButton) {
    //NOTE: Erasing is just setting the brush color to the color of the canvas
    setCurrentBrushColor(inRed: 235/255.0, inGreen: 235/255.00, inBlue: 235/255.00, inAlpha: current_BrushOpacity)
  }
  
  func updateBrushSizeSliderColor(inRed: CGFloat, inGreen: CGFloat, inBlue: CGFloat){
    let darkeningValue: CGFloat = 40/255.0
    let darkerRed = (inRed - darkeningValue < 0) ? 0 : inRed - darkeningValue
    let darkerGreen = (inGreen - darkeningValue < 0) ? 0 : inGreen - darkeningValue
    let darkerBlue = (inBlue - darkeningValue < 0) ? 0 : inBlue - darkeningValue
    
    let lighteningValue: CGFloat = 30/255.0
    let lighterRed = (inRed + lighteningValue > 255.0) ? 255 : inRed + lighteningValue
    let lighterGreen = (inGreen + lighteningValue > 255.0) ? 255 : inGreen + lighteningValue
    let lighterBlue = (inBlue + lighteningValue > 255.0) ? 255 : inBlue + lighteningValue
    
    BrushSizeSlider.maximumTrackTintColor = UIColor.init(red: darkerRed, green: darkerGreen, blue: darkerBlue, alpha: 1.0)
    BrushSizeSlider.minimumTrackTintColor = UIColor.init(red: lighterRed, green: lighterGreen, blue: lighterBlue, alpha: 1.0)
    BrushSizeSlider.thumbTintColor = UIColor.init(red: inRed, green: inGreen, blue: inBlue, alpha: 1.0)
  }

  func updateOpacitySliderColor(inRed: CGFloat, inGreen: CGFloat, inBlue: CGFloat){
    let darkeningValue: CGFloat = 40/255.0
    let darkerRed = (inRed - darkeningValue < 0) ? 0 : inRed - darkeningValue
    let darkerGreen = (inGreen - darkeningValue < 0) ? 0 : inGreen - darkeningValue
    let darkerBlue = (inBlue - darkeningValue < 0) ? 0 : inBlue - darkeningValue
    
    let lighteningValue: CGFloat = 30/255.0
    let lighterRed = (inRed + lighteningValue > 255.0) ? 255 : inRed + lighteningValue
    let lighterGreen = (inGreen + lighteningValue > 255.0) ? 255 : inGreen + lighteningValue
    let lighterBlue = (inBlue + lighteningValue > 255.0) ? 255 : inBlue + lighteningValue
    
    OpacitySlider.maximumTrackTintColor = UIColor.init(red: darkerRed, green: darkerGreen, blue: darkerBlue, alpha: 1.0)
    OpacitySlider.minimumTrackTintColor = UIColor.init(red: lighterRed, green: lighterGreen, blue: lighterBlue, alpha: 1.0)
    OpacitySlider.thumbTintColor = UIColor.init(red: inRed, green: inGreen, blue: inBlue, alpha: 1.0)
  }
  
  func setCurrentBrushColor(inRed: CGFloat, inGreen: CGFloat, inBlue: CGFloat, inAlpha: CGFloat){
    current_BrushColor_Red = inRed
    current_BrushColor_Green = inGreen
    current_BrushColor_Blue = inBlue
    current_BrushOpacity = inAlpha
    current_BrushColor = UIColor.init(red: inRed, green: inGreen, blue: inBlue, alpha: inAlpha)
    updateBrushSizeSliderColor(inRed: inRed, inGreen: inGreen, inBlue: inBlue)
  }
  //Touches
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
    guard let touchPoint = touches.first?.location(in: view) else {return }
    
    current_CircleCenter = touchPoint
    let frame = CGRect(x: 0, y: 70, width: view.frame.width, height: view.frame.height-71*2)
    current_DrawView = DrawView(frame:frame)
    
    let actualPoint = CGPoint(x: touchPoint.x, y: touchPoint.y-71)
    
    current_DrawView?.theCircle = Circle(center: actualPoint, radius: current_BrushSize, color: current_BrushColor, opacity: current_BrushOpacity)
    
    temp_startPoint = actualPoint
    temp_initThatLine = true
    
    view.addSubview(current_DrawView!)
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
    guard let touchPoint = touches.first?.location(in: view) else {return }
    let actualPoint = CGPoint(x: touchPoint.x, y: touchPoint.y-71)
    
    if (temp_initThatLine){
      current_DrawView?.theLine = LineOb(points: [], radius: current_BrushSize, color: current_BrushColor, opacity: current_BrushOpacity)
      temp_initThatLine = false
      current_DrawView?.theLine?.points.append(temp_startPoint)
    }
    current_DrawView?.theLine?.points.append(actualPoint)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    //This method is not being used
  }
  

}

