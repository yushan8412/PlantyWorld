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
import FirebaseFirestoreSwift

enum FirebaseError: Error {
    case documentError
}

enum MasterError: Error {
    case youKnowNothingError(String)
}

class FirebaseManager {
    static let shared = FirebaseManager()
    let dataBase = Firestore.firestore()
    var plantsList = [PlantsModel]()
    var commandList = [PublishModel]()
    
//    func addplant(plant: PlantsModel) {
//        plant.name
//        plant.date
//    }
    
    func addPlant(name: String, date: String, sun: Int, water: Int, image: String, note: [String]) {
        let plants = dataBase.collection("plants")
        let document = plants.document()
        let timeInterval = Date()
        let plantid = document.documentID
        let data: [String: Any] = [
            "author": [
                "email": "ws123123@gmail.com",
                "name": Auth.auth().currentUser?.displayName,
                "id": "123123"],
            "plantID": "\(plantid)",
            "name": name,
            "date": date,
            "sun": sun,
            "water": water,
            "note": note,
            "image": image,
            "createdTime": timeInterval
            
        ]
        document.setData(data) { error in
            if let error = error {
                print("Error\(error)")
            } else {
                print("Document update!!")
            }
        }
    }
    
    func addCommand(name: String, id: String, newcommand: String) {
        let command = dataBase.collection("commands")
        let document = command.document()
        let timeInterval = Date()
        let data: [String: Any] = [
            "author": [
                "id": "123",
                "name": Auth.auth().currentUser?.displayName],
            "title": "New Plant \(name)!!",
            "plantID": id,
            "commands": [
                "commandID": document.documentID,
                "command": "here is new command \(newcommand)"],
            "time": timeInterval
        ]
        document.setData(data) { error in
            if let error = error {
                print("Error\(error)")
            } else {
                print("Command update!!")
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
                let plantNote = plantObject["note"] as? [String] ?? [""]
                let plantImage = plantObject["image"] as? String ?? ""
                let plantID = plantObject["plantID"] as? String ?? ""

                let plant = PlantsModel(name: plantName ,
                                        date: plantDate,
                                        sun: plantSun,
                                        water: plantWater,
                                        note: plantNote,
                                        image: plantImage,
                                        id: plantID
                )
                self.plantsList.append(plant)
            }
            completion(self.plantsList)
        }
    }
    
    func fetchCommandData(plantID:String, completion: @escaping ([PublishModel]?) -> Void) {
        dataBase.collection("commands").whereField("plantID", isEqualTo: plantID).getDocuments { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                return
            }
            self.commandList.removeAll()
            for commands in querySnapshot.documents {
//                var command: PublishModel?
//                do {
//                    command = try commands.data(as: PublishModel.self, decoder: Firestore.Decoder()) {
//                        self.commandList.append(command)
//                    }
//
//                } catch {
//                    print("error")
                    
//                    completion(.failure(error))
//                let commandObject = command.data(with: ServerTimestampBehavior.none)
                let commandObject = commands.data()
//                print(commandObject)
                guard let author = commandObject["author"] as? [String: Any] else { return }
//                print(author)
                guard let commands = commandObject["commands"] as? [String: Any] else { return }
//                print(commands)
                let plantID = commandObject["plantID"] as? String ?? ""
                let commandTitle = commandObject["title"] as? String ?? ""
                let commandTime = commandObject["time"] as? Int ?? 0

                let authorr = Author(name: author["name"] as? String ?? "", id: author["id"] as? String ?? "")
                let commandss = Command(command: commands["command"] as? String ?? "", commandID: commands["commandID"] as? String ?? "")
                let command = PublishModel(author: authorr, title: commandTitle,
                                           commands: commandss, plantID: plantID,
                                           time: Int64(commandTime))
                self.commandList.append(command)
            }
            completion(self.commandList)
            }
            
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
    

