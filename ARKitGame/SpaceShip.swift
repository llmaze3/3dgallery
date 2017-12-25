//
//  SpaceShip.swift
//  ARKitGame
//
//  Created by Lloyd Maze Powell III on 12/9/17.
//  Copyright © 2017 L.M.PowellEnterprise. All rights reserved.
//

import ARKit

class SpaceShip: SCNNode {
    func loadModel() {
        guard let virtualObjectScene = SCNScene(named: "art.scnassets/ship.scn") else  {return}

        
        let wrapperNode = SCNNode()
        
        for child in virtualObjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
            
        }
        self.addChildNode(wrapperNode)

    }
}
