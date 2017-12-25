//
//  Diamond.swift
//  ARKitGame
//
//  Created by Lloyd Maze Powell III on 12/13/17.
//  Copyright © 2017 L.M.PowellEnterprise. All rights reserved.
//

import ARKit

class Diamond: SCNNode {
    func loadDiamond() {
        guard let virtualObjectScene = SCNScene(named: "art.scnassets/diamonds/rdiamonds.dae") else  {return}
        
        
        let wrapperNode = SCNNode()
        
        for child in virtualObjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
            
        }
        self.addChildNode(wrapperNode)
        
    }
}
