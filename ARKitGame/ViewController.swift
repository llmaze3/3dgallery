//
//  ViewController.swift
//  ARKitGame
//
//  Created by Lloyd Maze Powell III on 12/7/17.
//  Copyright © 2017 L.M.PowellEnterprise. All rights reserved.
//

import UIKit
import ARKit
import Photos
import ARVideoKit
import AVFoundation

class ViewController: UIViewController, ARSKViewDelegate, RenderARDelegate, RecordARDelegate{
 
    var recorder: RecordAR?
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    let caprturingQueue = DispatchQueue(label: "capturingThread", attributes: .concurrent)
    var player: AVAudioPlayer = AVAudioPlayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = SCNScene()
        sceneView.scene = scene
        // Do any additional setup after loading the view, typically from a nib.
        
        //shade
        sceneView.automaticallyUpdatesLighting = true

        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        // Initialize ARVideoKit recorder
        recorder = RecordAR(ARSceneKit: sceneView)
        
        /*ARVideoKit Configuration */
        
        // Set the recorder's delegate
        recorder?.delegate = self
        
        // Set the renderer's delegate
        recorder?.renderAR = self
        
        // Configure the renderer to perform additional image & video processing 👁
        recorder?.onlyRenderWhileRecording = false
        
        // Set the UIViewController orientations
        recorder?.inputViewOrientations = [.landscapeLeft, .landscapeRight, .portrait]
        
        // Configure RecordAR to store media files in local app directory
        recorder?.deleteCacheWhenExported = false
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        // Pause the view's session
        sceneView.session.pause()
        
        if recorder?.status == .recording {
            recorder?.stopAndExport()
        }
        recorder?.onlyRenderWhileRecording = true
        recorder?.prepare(ARWorldTrackingConfiguration())
        
        // Switch off the orientation lock for UIViewControllers with AR Scenes
        recorder?.rest()
    }
    // MARK: - Exported UIAlert present method
    func exportMessage(success: Bool, status:PHAuthorizationStatus) {
        if success {
            let alert = UIAlertController(title: "Exported", message: "Media exported to camera roll successfully!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Awesome", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if status == .denied || status == .restricted || status == .notDetermined {
            let errorView = UIAlertController(title: "😅", message: "Please allow access to the photo library in order to save this media file.", preferredStyle: .alert)
            let settingsBtn = UIAlertAction(title: "Open Settings", style: .cancel) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        })
                    } else {
                        UIApplication.shared.openURL(URL(string:UIApplicationOpenSettingsURLString)!)
                    }
                }
            }
            errorView.addAction(UIAlertAction(title: "Later", style: UIAlertActionStyle.default, handler: {
                (UIAlertAction)in
            }))
            errorView.addAction(settingsBtn)
            self.present(errorView, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Exporting Failed", message: "There was an error while exporting your media file.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func capture(_ sender: Any) {
        //Photo
        if recorder?.status == .readyToRecord {
            let image = self.recorder?.photo()
            self.recorder?.export(UIImage: image) { saved, status in
                if saved {
                    // Inform user photo has exported successfully
                    self.exportMessage(success: saved, status: status)
                }
            }
        }
    }
    
    
    //MARK: AR CONFIG
    //Configurations for AR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Tracks the orientation and configureation
        let configuration = ARWorldTrackingConfiguration()
        recorder?.prepare(configuration)
        //scene view manage motion tracking
        sceneView.session.run(configuration)
        //add objects to the scene
        addShip()
        addAstronaut()
        addUfo()
        //add cup after the file size is reduced
        //addCup()
        addSpace()
        addBeSomeone()
        addDiamond()
        addSprite()
    }
    func addShip(){
        let ship = SpaceShip()
        ship.loadModel()
        //Can change these positions
        let xPos = randomPosition(lowerBound: -7.5, upperBound: 5.0)
        let yPos = randomPosition(lowerBound: -3.5, upperBound: 5.0)
        // -1 meters away from the camera
        ship.position = SCNVector3(xPos, yPos, -2)
        sceneView.scene.rootNode.addChildNode(ship)
    }
    func addAstronaut(){
        let astronaut = Astronaut()
        astronaut.loadAstronaut()
        let xPos = randomPosition(lowerBound: -5.5, upperBound: 5.5)
        let yPos = randomPosition(lowerBound: -9.5, upperBound: 9.5)
        astronaut.position = SCNVector3(xPos, yPos, 2)
        astronaut.scale = SCNVector3(x: 2, y: 2, z: 2)
        astronaut.runAction(SCNAction.move(by: SCNVector3(xPos, yPos, -3), duration: 40))
        astronaut.runAction(SCNAction.rotateBy(x: 2, y: 3, z: 0, duration: 60))
        sceneView.scene.rootNode.addChildNode(astronaut)
    }
 
    
    func addUfo(){
        let ufo = Ufo()
        ufo.loadUfo()
        let xPos = randomPosition(lowerBound: -7.5, upperBound: 7.5)
        let yPos = randomPosition(lowerBound: -9.5, upperBound: 5.5)
        ufo.position = SCNVector3(xPos, yPos, 2)
        ufo.scale = SCNVector3(x: 0.6, y: 0.6, z: 0.6)
        ufo.runAction(SCNAction.rotateBy(x: 0, y: 10, z: 10, duration: 180))
        sceneView.scene.rootNode.addChildNode(ufo)
    }
    /*
    func addCup(){
        let cup = Cup()
        cup.loadCup()
        let xPos = randomPosition(lowerBound: -6.5, upperBound: 1.5)
        let yPos = randomPosition(lowerBound: -9.5, upperBound: 7.5)
        cup.position = SCNVector3(xPos, yPos, 10)
        cup.scale = SCNVector3(x: 0.5, y: 0.5, z: 0.5)
        cup.runAction(SCNAction.rotateBy(x: 0, y: 10, z: 0, duration: 180))
        sceneView.scene.rootNode.addChildNode(cup)
    }
 */
    func addSpace(){
        let space = SpaceText()
        space.loadSpace()
        let xPos = randomPosition(lowerBound: -5.5, upperBound: 1.5)
        let yPos = randomPosition(lowerBound: -7.5, upperBound: 1.5)
        space.position = SCNVector3(xPos, yPos, -12)
        sceneView.scene.rootNode.addChildNode(space)
    }
    func addBeSomeone(){
        let be = BeSomeone()
        be.loadBeSomeone()
        let xPos = randomPosition(lowerBound: -3.5, upperBound: 7.5)
        let yPos = randomPosition(lowerBound: -7.5, upperBound: 7.5)
        be.position = SCNVector3(xPos, yPos, -12)
        be.scale = SCNVector3(x: 0.03, y: 0.03, z: 0.03)
        sceneView.scene.rootNode.addChildNode(be)
    }
    func addDiamond(){
        let diamonds = Diamond()
        diamonds.loadDiamond()
        let xPos = randomPosition(lowerBound: -7.5, upperBound: 7.5)
        let yPos = randomPosition(lowerBound: -9.5, upperBound: 7.5)
        diamonds.position = SCNVector3(xPos, yPos, -10)
        sceneView.scene.rootNode.addChildNode(diamonds)
    }
    func addSprite(){
        let sprite = SpriteBottle()
        sprite.loadSprite()
        let xPos = randomPosition(lowerBound: -7.5, upperBound: 7.5)
        let yPos = randomPosition(lowerBound: -9.5, upperBound: 7.5)
        sprite.position = SCNVector3(xPos, yPos, -1)
        sceneView.scene.rootNode.addChildNode(sprite)
    }
    
    func randomPosition (lowerBound lower:Float, upperBound upper: Float) -> Float {
        return Float(arc4random()) / Float(UInt32.max) * (lower - upper) + upper
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            //Get the location od the touch
            let location = touch.location(in: sceneView)
            
            let hitlist = sceneView.hitTest(location, options: nil)
            //if we actually have an object
            
            if let hitObject = hitlist.first {
                let node = hitObject.node
                
                if node.name == "ARship" {
                node.runAction(SCNAction.rotateBy(x: 1, y: 0, z: 0, duration: 1))
                
                }
            
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

//MARK: - ARVideoKit Delegate Methods
extension ViewController {
    func frame(didRender buffer: CVPixelBuffer, with time: CMTime, using rawBuffer: CVPixelBuffer) {
        // Do some image/video processing.
    }
    
    func recorder(didEndRecording path: URL, with noError: Bool) {
        if noError {
            // Do something with the video path.
        }
    }
    
    func recorder(didFailRecording error: Error?, and status: String) {
        // Inform user an error occurred while recording.
    }
    
    func recorder(willEnterBackground status: RecordARStatus) {
        // Use this method to pause or stop video recording. Check [applicationWillResignActive(_:)](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1622950-applicationwillresignactive) for more information.
        if status == .recording {
            recorder?.stopAndExport()
        }
    }
}

