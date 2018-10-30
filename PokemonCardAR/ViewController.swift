//
//  ViewController.swift
//  PokemonCardAR
//
//  Created by Kyle Aquino on 10/29/18.
//  Copyright © 2018 Kyle Aquino. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation
import SpriteKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/GameScene.scn")!
        let snorlax = SCNScene(named: "art.scnassets/Snorlax/snorlax.scn")!
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        guard let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "Photos", bundle: Bundle.main) else {
            print("No images available")
            return
        }
    
        configuration.trackingImages = trackedImages
        configuration.maximumNumberOfTrackedImages = 1
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0.8)
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            
//            let snorlaxScene = SCNScene(named: "art.scnassets/Snorlax/snorlax.scn")!
//            let snorlaxNode = snorlaxScene.rootNode.childNodes.first!
            
//            snorlaxNode.position = SCNVector3Zero
//            snorlaxNode.scale = SCNVector3(x: 0.0015, y: 0.0015, z: 0.0015)
//            planeNode.addChildNode(snorlaxNode)
            
            // DO STUFF WITH VIDEO
            let videoURL = Bundle.main.url(forResource: "HakunaMatata2", withExtension: "mp4")!
            let videoPlayer = AVPlayer(url: videoURL)
            let videoScene = SKScene(size: CGSize(width: 500, height: 500))
            
            let videoNode = SKVideoNode(avPlayer: videoPlayer)
            
            videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
            
            videoNode.size = videoScene.size
            videoNode.yScale = -1
            
            videoScene.addChild(videoNode)
            
            plane.firstMaterial?.diffuse.contents = videoScene
//
            node.addChildNode(planeNode)
            videoPlayer.play()
            
            
            
            
        }
        
        return node
    }
}
