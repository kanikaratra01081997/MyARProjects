//
//  ViewController.swift
//  wallHanging
//
//  Created by Kanika Ratra on 18/09/20.
//  Copyright © 2020 Kanika Ratra. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!

    fileprivate var c = SCNNode()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.autoenablesDefaultLighting = true
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
       // sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor{
            let planeAnchor = anchor as! ARPlaneAnchor
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            let planeNode = SCNNode()
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            let material = SCNMaterial()
            material.diffuse.contents = UIImage(named: "art.scnassets/woodenTexture.jpg")
            plane.materials = [material]
            planeNode.geometry = plane
            node.addChildNode(planeNode)
            print("plane detected")
            }
            else
            {
                return
            }
            
            
   
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let touchLocation = touch.location(in: sceneView)
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            if !results.isEmpty{
                print("touched the plane")
            }else
            {
                print("touched other plane")
            }
            if let hitResult = results.first{
                let cupScene = SCNScene(named: "art.scnassets/coffeeCup.scn")!
                if let  CupNode = cupScene.rootNode.childNode(withName: "cup", recursively: true){
                CupNode.position = SCNVector3(
                  x:hitResult.worldTransform.columns.3.x,
                  y: hitResult.worldTransform.columns.3.y,
                  z: hitResult.worldTransform.columns.3.z)
                   
                  c = CupNode
                    sceneView.scene.rootNode.addChildNode(CupNode)
                    
                    let panRec = UIPanGestureRecognizer(target: self, action: #selector(PanGesture(gesture:)))
                    
                    sceneView.addGestureRecognizer(panRec)
                
            }
        }
        }
    }
    
    
    
    
    @objc func PanGesture( gesture : UIPanGestureRecognizer)
    {
        gesture.minimumNumberOfTouches = 1
        let results = self.sceneView.hitTest(gesture.location(in: gesture.view), types: ARHitTestResult.ResultType.existingPlaneUsingExtent)
        guard let result : ARHitTestResult = results.first else{
            return
        }

        
        let position = SCNVector3Make(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z)
        c.position = position
        
        
    }
    
    
}
