//
//  ViewController.swift
//  kadai11
//
//  Created by 葛西　佳祐 on 2020/07/19.
//  Copyright © 2020 葛西　佳祐. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import SafariServices

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    let defaultConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        
        let images = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)
        configuration.detectionImages = images
            configuration.maximumNumberOfTrackedImages = 1
            return configuration
        }()
    
    let imageConfiguration: ARImageTrackingConfiguration = {
        let configuration = ARImageTrackingConfiguration()
        
        let images = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)
        configuration.trackingImages = images!
        configuration.maximumNumberOfTrackedImages = 1
        return configuration
    }()
    
    private var buttonNode: SCNNode!
    private var card2Node: SCNNode!
    private var errorNode: SCNNode!
    
    private let feedback = UIImpactFeedbackGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        buttonNode = SCNScene(named: "art.scnassets/businesscard.scn")!.rootNode.childNode(withName: "card", recursively: false)
        let thumbnailNode = buttonNode.childNode(withName: "thumbnail", recursively: true)
        thumbnailNode?.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "profile1")
        
        errorNode = SCNScene(named: "art.scnassets/error.scn")?.rootNode.childNode(withName: "text", recursively: false)
        
        feedback.prepare()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Run the view's session
        sceneView.session.run(defaultConfiguration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: sceneView),
        let result = sceneView.hitTest(location, options: nil).first else {
            return
        }
        let node = result.node
        
        if node.name == "Facebook" {
            let safariVC = SFSafariViewController(url: URL(string: "https://www.facebook.com/keisuke.kassai")!)
            self.present(safariVC,animated: true,completion:  nil)
        } else if node.name == "Twitter" {
            let safariVC = SFSafariViewController(url: URL(string: "https://twitter.com/kassai13")!)
            self.present(safariVC, animated: true, completion: nil)
        } else if node.name == "Youtube" {
            let safariVC = SFSafariViewController(url:URL(string: "https://www.youtube.com/watch?v=wXPX6m87944&feature=emb_logo")!)
            self.present(safariVC, animated: true, completion: nil)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let imageAnchor = anchor as? ARImageAnchor else {
            return nil
        }
        
        switch imageAnchor.referenceImage.name {
            case "card1" :
                print("正しい名刺です")
                DispatchQueue.main.async {
                    self.feedback.impactOccurred()
                }
                buttonNode.scale = SCNVector3(0.1,0.1,0.1)
                let scale1 = SCNAction.scale(to: 1.5, duration: 0.2)
                let scale2 = SCNAction.scale(to: 1, duration: 0.1)
                scale2.timingMode = .easeOut
                let group = SCNAction.sequence([scale1,scale2])
                buttonNode.runAction(group)
                
                return buttonNode
            case "card2":
                print("正しい名刺ではございません")
                
                return nil
            default:
                return nil
        }
    }
}
