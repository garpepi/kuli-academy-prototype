//
//  ViewController.swift
//  prototype-kuli-academy
//
//  Created by Garpepi Aotearoa on 17/07/21.
//

import UIKit

class ViewController: UIViewController {

  // MARK: VARIABLE

  var brezierPath: UIBezierPath!

  var pointStart = CGPoint(x: 0,y: 0)
  var pointBegining = CGPoint(x: 0,y: 0)
  var flagPoint: Bool = false

  @IBOutlet weak var mode: UISegmentedControl!
  @IBOutlet weak var canvasView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    mode.addTarget(self, action: #selector(modeOnChange), for: UIControl.Event.valueChanged)

  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    print("touch begin")
    if mode.selectedSegmentIndex == 0 {
      //drawModeExec(touches: touches)
    }else{
      let point = touches.first?.location(in: self.view) // Where you pressed
          print("point: \(point)")
          print("canvasView.layer.hitTest(point!): \(canvasView.layer.hitTest(point!))")
          print()
          if let layer = canvasView.layer.hitTest(point!) as? CAShapeLayer { // If you hit a layer and if its a Shapelayer
            print("layer: \(layer)")
              if (layer.path?.contains(point!))! { // Optional, if you are inside its content path
                print("layer.path \(layer.path)")
                print("layer.position \(layer.position)")
                  print("Hit shapeLayer") // Do something
              }
          }
      //print(canvasView.layer.sublayers)
    }

  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    print("touch moved")
    if mode.selectedSegmentIndex == 0 {
      //drawModeExec(touches: touches)
    }else{
      let point = touches.first?.location(in: self.view) // Where you pressed

          print("canvasView.layer.hitTest(point!): \(canvasView.layer.hitTest(point!))")
          print()
          if let layer = canvasView.layer.hitTest(point!) as? CAShapeLayer { // If you hit a layer and if its a Shapelayer
            print("layer: \(layer)")
            print("point: \(point)")
            print("layer.path \(layer.path)")
              if (layer.path?.contains(point!))! { // Optional, if you are inside its content path

                print("layer.position \(layer.position)")
                  print("Hit shapeLayer") // Do something
              }
          }
      //print(canvasView.layer.sublayers)
    }

  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    print("touch ended")
    if mode.selectedSegmentIndex == 0 {
      drawModeExec(touches: touches)
    }else{

    }

  }

  // MARK: EXTEND METHOD

  @objc func modeOnChange(){
    clearDot()
  }

  // MARK: CUSTOM METHOD

  func drawModeExec(touches: Set<UITouch>){
    if !flagPoint{
      // get the fort tap location
      guard let newTouchPoint = touches.first?.location(in: canvasView) else {
          return
      }

      pointStart = newTouchPoint

      // generate dot point for starting poitn
      createDot(x: newTouchPoint.x, y: newTouchPoint.y)
      flagPoint = true
    }else{
      guard let newEndTouchPoint = touches.first?.location(in: canvasView) else {
          return
      }

      print("will draw \(pointStart)")
      drawLine(startPoint: pointStart, endPoint: newEndTouchPoint)
      pointStart = (touches.first?.location(in: canvasView))!

      createDot(x: newEndTouchPoint.x, y: newEndTouchPoint.y)
    }


  }

  func createDot(x: CGFloat, y:CGFloat){

    // Setting for painpoint UIView
    let dot = UIView(frame: CGRect(x: x-12, y: y-12, width: 24, height: 24))
    dot.layer.borderWidth = 2
    dot.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    dot.layer.cornerRadius = dot.frame.size.width/2
    dot.tag = 999

    // Put it in view
    canvasView.addSubview(dot)
    canvasView.bringSubviewToFront(dot)
  }

  func clearDot(){

    for subView in canvasView.subviews{
      if (subView.viewWithTag(999) != nil){
        subView.removeFromSuperview()
      }
    }

    pointStart = CGPoint(x: 0,y: 0)
    pointBegining = CGPoint(x: 0,y: 0)
    flagPoint = false
  }

  func drawLine (startPoint: CGPoint, endPoint: CGPoint)
  {
      print("\(startPoint) \(endPoint)")
//    brezierPath = UIBezierPath(rect: CGRect(x: startPoint.x, y: startPoint.y, width: startPoint.x - endPoint.x, height: startPoint.y - endPoint.y))
      brezierPath = UIBezierPath()
      brezierPath.move(to: startPoint)
      brezierPath.addLine(to: endPoint)
      brezierPath.close()

      let shapeLayer = CAShapeLayer()

    //shapeLayer.backgroundColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
    shapeLayer.path = brezierPath.cgPath
    //shapeLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 100, height: 100)).cgPath
    //shapeLayer.path = UIBezierPath(rect: CGRect(x: startPoint.x, y: startPoint.y, width: startPoint.x - endPoint.x, height: startPoint.y - endPoint.y)).cgPath
      shapeLayer.strokeColor = UIColor.black.cgColor
      shapeLayer.lineWidth = 10.0
      //shapeLayer.position = startPoint
      //shapeLayer.bounds = shapeLayer.path!.boundingBox


      // Put it in view
      //self.view.layer.insertSublayer(shapeLayer, above: self.view.layer)
      canvasView.layer.addSublayer(shapeLayer)

    // distance
    print("distance \(CGPointDistance(from: startPoint, to: endPoint))")
  }

  func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
      return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
  }

  func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
      return sqrt(CGPointDistanceSquared(from: from, to: to))
  }

}

