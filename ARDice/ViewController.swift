//
//  ViewController.swift
//  ARDice
//
//  Created by Smil on 08/06/23.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    var diceArray:[SCNNode] = [];

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Set the view's delegate
        sceneView.delegate = self
        
        
//        let sphere = SCNSphere(radius: 0.2)
//
//        let material = SCNMaterial();
//
//        material.diffuse.contents = UIImage(named: "art.scnassets/moon.jpg");
//
//        sphere.materials = [material];
//
//        let node = SCNNode();
//
//        node.position = SCNVector3(x: 0, y: 0.1, z: -0.5);
//
//        node.geometry = sphere;
//
//        sceneView.scene.rootNode.addChildNode(node);
//
//        sceneView.autoenablesDefaultLighting = true;
        
//         Create a new scene
        sceneView.autoenablesDefaultLighting = true;
        
       

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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            
            let touchLocation = touch.location(in: sceneView)
            
            let results = sceneView.hitTest(touchLocation, types: .existingPlane)
            
            if let hitResult = results.first{
                
                let diceScene = SCNScene(named: "art.scnassets/dice.scn")!
                
                if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true){
                    
                    diceNode.position  = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius , hitResult.worldTransform.columns.3.z)
                    
                    diceArray.append(diceNode)
                    
                    sceneView.scene.rootNode.addChildNode(diceNode)
                    
                    roll(dice: diceNode);
                    
                }
            }
        }
    }
    
    @IBAction func deleteAll(_ sender: UIBarButtonItem) {
        
        if !diceArray.isEmpty{
            for dice in diceArray{
                dice.removeFromParentNode();
            }
        }
        
    }
    
    
    @IBAction func rollButtonPressed(_ sender: UIBarButtonItem) {
        
        rollAll()
        
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollAll();
    }
    
    func rollAll()
    {
        if !diceArray.isEmpty{
            for dice in diceArray{
                roll(dice:dice)
            }
        }
    }
    
    func roll(dice:SCNNode){
        
        let randomX = Float( arc4random_uniform(4)+1) * (Float.pi/2)
        
        let randomZ = Float( arc4random_uniform(4)+1) * (Float.pi/2)
        
        
        dice.runAction(SCNAction.rotateBy(x: CGFloat(randomX * 5), y: 0, z: CGFloat(randomZ * 5), duration: 0.8))
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor{
            
            let planeAnchore = anchor as! ARPlaneAnchor
            
            let plane = SCNPlane(width: CGFloat(planeAnchore.extent.x), height: CGFloat(planeAnchore.extent.z))
            
            let planeNode = SCNNode();
            
            planeNode.position = SCNVector3(x: planeAnchore.center.x, y: 0, z: planeAnchore.center.z
            );
            
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            let gridMaterial = SCNMaterial();
            
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grass.jpg")
            
            plane.materials = [gridMaterial]
            
            planeNode.geometry = plane
            
            node.addChildNode(planeNode)
            
        }
        else{
            return
        }
    }
    
   
}
