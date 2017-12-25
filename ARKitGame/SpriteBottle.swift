//
//  SpriteBottle.swift
//  ARKitGame
//
//  Created by Lloyd Maze Powell III on 12/17/17.
//  Copyright © 2017 L.M.PowellEnterprise. All rights reserved.
//

import ARKit

class SpriteBottle: SCNNode {
    func loadSprite() {
        guard let virtualObjectScene = SCNScene(named: "art.scnassets/dirtysprite.dae") else  {return}
        let wrapperNode = SCNNode()
        
        for child in virtualObjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
            
        }
        self.addChildNode(wrapperNode)
        
    }
}
