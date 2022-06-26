//
//  ARMeasureVC.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/19.
//

import Foundation
import ARKit
import SceneKit

class MeasureVC: UIViewController, ARSCNViewDelegate {
    var sceneView = ARSCNView()
    
    var dotNodes = [SCNNode]()
    var textNode = SCNNode()
    var meterValue: Double?
    var saveBtn = UIButton()
    var plant: PlantsModel?
    
    var distance: Float?
    
    override func viewDidLoad() {
        view.addSubview(sceneView)
        sceneView.addSubview(saveBtn)
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if dotNodes.count >= 2 {
            for dot in dotNodes {
                dot.removeFromParentNode()
            }
            dotNodes = [SCNNode]()
        }
        if let touchLocation = touches.first?.location(in: sceneView) {
            let hitTestReault = sceneView.hitTest(touchLocation, types: .featurePoint)
            if let hitResult = hitTestReault.first {
                addDot(at: hitResult)
            }
        }
    }
    
    func setup() {
        sceneView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                         paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        saveBtn.anchor(bottom: sceneView.bottomAnchor, right: sceneView.rightAnchor,
                       paddingBottom: 16, paddingRight: 16)
        saveBtn.setTitle(" SAVE ", for: .normal)
        saveBtn.backgroundColor = .dPeach
        saveBtn.layer.cornerRadius = 10
        saveBtn.addTarget(self, action: #selector(tapToSave), for: .touchUpInside)
        
    }
    
    @objc func tapToSave() {
        let deleteAlert = UIAlertController(title: "Save data", message: "Save \((distance ?? 0) * 100) as your data?",
                                            preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        deleteAlert.addAction(cancelAction)
        let deleteAction = UIAlertAction(title: "Yes", style: .destructive) { (_) in
            self.addEvent()
        }
        deleteAlert.addAction(deleteAction)

        present(deleteAlert, animated: true, completion: nil)
    }
    
    func addEvent() {
        FirebaseManager.shared.addEvent(content: "\(plant?.name ?? "noID") 身高 \((distance ?? 0 ) * 100)",
                                        plantID: plant?.id ?? "noID")
    }
    
    func addDot(at hitResult: ARHitTestResult) {
        let dotGeometry = SCNSphere(radius: 0.005)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        
        dotGeometry.materials = [material]
        
        let dotNode = SCNNode(geometry: dotGeometry)
        
        dotNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(dotNode)
        
        dotNodes.append(dotNode)
        
        if dotNodes.count >= 2 {
            calculate()
        }
    }
    
    func calculate () {
        let start = dotNodes[0]
        let end = dotNodes[1]
        
        print(start.position)
        print(end.position)
        
        distance = sqrt(
            pow(end.position.x - start.position.x, 2) +
            pow(end.position.y - start.position.y, 2) +
            pow(end.position.z - start.position.z, 2)
        )
        
        updateText(text: "\(abs(distance ?? 0))", atPosition: end.position)
                
        meterValue = Double(abs(distance ?? 0))
        
        var heightMeter = Measurement(value: meterValue ?? 0, unit: UnitLength.meters)
        let heightInches = heightMeter.convert(to: UnitLength.inches)
        let heightCentimeter = heightMeter.converted(to: UnitLength.centimeters)
        
        let value = "\(heightCentimeter)"
        let finalMeasurement = String(value.prefix(6))
        updateText(text: finalMeasurement, atPosition: end.position)
                
    }
    
    func updateText(text: String, atPosition position: SCNVector3) {
        
        textNode.removeFromParentNode()
        
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        
        textGeometry.firstMaterial?.diffuse.contents = UIColor.red
        
        textNode = SCNNode(geometry: textGeometry)
        
        textNode.position = SCNVector3(position.x, position.y + 0.01, position.z)
        
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        sceneView.scene.rootNode.addChildNode(textNode)
        
    }

}
