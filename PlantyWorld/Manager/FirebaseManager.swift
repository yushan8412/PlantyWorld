//
//  FirebaseManager.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/15.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Firebase

class FirebaseManager {
    static let shared = FirebaseManager()
    let dataBase = Firestore.firestore()
    var plantsList = [PlantsModel]()
    
    func addPlant(name: String, date: String, sun: String, water: String, image: String) {
        let plants = dataBase.collection("plants")
        let document = plants.document()
        let data: [String: Any] = [
            "author": [
                "email": "ws123123@gmail.com",
                "name": Auth.auth().currentUser?.displayName,
                "id": "123123"],
            "name": name,
            "date": date,
            "sun": sun,
            "water": water,
            "image": image
        ]
        document.setData(data) { error in
            if let error = error {
                print("Error\(error)")
            } else {
                print("Document update!!")
            }
        }
    }
    
    func fetchData(completion: @escaping ([PlantsModel]?) -> Void) {
        dataBase.collection("plants").getDocuments { (querySnapshot, _) in
            guard let querySnapshot = querySnapshot else {
                return }
            self.plantsList.removeAll()
            for plant in querySnapshot.documents {
                let plantObject = plant.data(with: ServerTimestampBehavior.none)
                let plantName = plantObject["name"] as? String ?? ""
//                let plantDate = plantObject["dateOfPurchase"] as? Date ?? Date(timeIntervalSince1970: 1.0)
                let plantDate = plantObject["date"] as? String ?? ""
                let plantSun = plantObject["sun"] as? Int ?? 0
                let plantWater = plantObject["water"] as? Int ?? 0
                let plantNote = plantObject["note"] as? String ?? ""
        
                let plant = PlantsModel(name: plantName ,
                                        date: plantDate,
                                        sun: plantSun,
                                        water: plantWater,
                                        note: plantNote)
                self.plantsList.append(plant)
            }
            completion(self.plantsList)
        }
    }

    func sinInUp(email: String, name: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard let user = result?.user,
                  error == nil else {
                print("Error", error?.localizedDescription as Any)
                return
            }
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = name
            changeRequest?.commitChanges(completion: { error in
                guard error == nil else {
                    print(error?.localizedDescription as Any)
                    return
                }
            })
            print("註冊成功", user.uid)
        }
    }
    
}
