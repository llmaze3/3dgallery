//
//  Ufo.swift
//  ARKitGame
//
//  Created by Lloyd Maze Powell III on 12/15/17.
//  Copyright © 2017 L.M.PowellEnterprise. All rights reserved.
//

import ARKit

class Ufo: SCNNode {
    func loadUfo() {
        guard let virtualObjectScene = SCNScene(named: "art.scnassets/ufoswanga2.scn") else  {return}
        let wrapperNode = SCNNode()
        
        for child in virtualObjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
            
        }
        self.addChildNode(wrapperNode)
        
    }
}
