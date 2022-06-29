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
    var commandList = [PublishModel]()
    var eventList = [CalendarModel]()
    var dayEvent: CalendarModel?

    //    func addplant(plant: PlantsModel) {
    //        plant.name
    //        plant.date
    //    }
    
    func addPlant(uid: String, name: String, date: String, sun: Int, water: Int, image: String, note: [String], completion: @escaping (Result<Void, Error>) -> Void)
    {
        let plants = dataBase.collection("plants")
        let document = plants.document()
        let timeInterval = Date()
        let plantid = document.documentID
        let data: [String: Any] = [
            "author": [
                "email": "ws123123@gmail.com",
                "name": Auth.auth().currentUser?.displayName,
                "id": "123123"],
            "userID": uid,
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
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func addEvent(content: String, plantID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let events = dataBase.collection("events")
        let document = events.document()
        
        let timeInterval = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
        let date = formatter.string(from: timeInterval)
        
        let data: [String: Any] = [
            "authorID": "123" ,
            "date": date,
            "content": content,
            "plantID": plantID
        ]
        document.setData(data) { error in
            if let error = error {
                print("Error\(error)")
            } else {
                print("Event update!!")
                completion(.success(()))
            }
        }
    }
    
    func addCommand(name: String, id: String, newcommand: String) {
        let command = dataBase.collection("commands")
        let document = command.document()
        let timeInterval = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddhhmmss"
//        formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
        let dates = formatter.string(from: timeInterval)
        
        let data: [String: Any] = [
            "author": [
                "id": "123",
                "name": Auth.auth().currentUser?.displayName],
            "title": "New Plant \(name)!!",
            "plantID": id,
            "commands": [
                "commandID": document.documentID,
                "command": "command:\(newcommand)"],
            "time": dates
        ]
        document.setData(data) { error in
            if let error = error {
                print("Error\(error)")
            } else {
                print("Command update!!")
            }
        }
    }
    
    //.order(by: "createdTime", descending: true)
    func fetchData(uid: String, completion: @escaping ([PlantsModel]?) -> Void) {
        dataBase.collection("plants").whereField("userID", isEqualTo: uid).getDocuments { (querySnapshot, _) in
            guard let querySnapshot = querySnapshot else {
                return }
            self.plantsList.removeAll()
            for plant in querySnapshot.documents {
                let plantObject = plant.data(with: ServerTimestampBehavior.none)
                let plantName = plantObject["name"] as? String ?? ""
                let plantDate = plantObject["date"] as? String ?? ""
                let plantSun = plantObject["sun"] as? Int ?? 0
                let plantWater = plantObject["water"] as? Int ?? 0
                let plantNote = plantObject["note"] as? [String] ?? [""]
                let plantImage = plantObject["image"] as? String ?? ""
                let plantID = plantObject["plantID"] as? String ?? ""
                let createdTime = plantObject["createdTime"] as? Int ?? 0
                guard let author = plantObject["author"] as? [String: Any] else { return }
                let authorr = Author(name: author["name"] as? String ?? "", id: author["id"] as? String ?? "")
                
                let plant = PlantsModel(author: authorr,
                                        name: plantName ,
                                        date: plantDate,
                                        sun: plantSun,
                                        water: plantWater,
                                        note: plantNote,
                                        image: plantImage,
                                        id: plantID,
                                        createdTime: createdTime
                )
                self.plantsList.append(plant)
            }
            completion(self.plantsList)
        }
    }
    
    
    func fetchAllData(completion: @escaping ([PlantsModel]?) -> Void) {
        dataBase.collection("plants").getDocuments { (querySnapshot, _) in
            guard let querySnapshot = querySnapshot else {
                return }
            self.plantsList.removeAll()
            for plant in querySnapshot.documents {
                let plantObject = plant.data(with: ServerTimestampBehavior.none)
                let plantName = plantObject["name"] as? String ?? ""
                let plantDate = plantObject["date"] as? String ?? ""
                let plantSun = plantObject["sun"] as? Int ?? 0
                let plantWater = plantObject["water"] as? Int ?? 0
                let plantNote = plantObject["note"] as? [String] ?? [""]
                let plantImage = plantObject["image"] as? String ?? ""
                let plantID = plantObject["plantID"] as? String ?? ""
                let createdTime = plantObject["createdTime"] as? Int ?? 0
                guard let author = plantObject["author"] as? [String: Any] else { return }
                let authorr = Author(name: author["name"] as? String ?? "", id: author["id"] as? String ?? "")
                
                let plant = PlantsModel(author: authorr,
                                        name: plantName ,
                                        date: plantDate,
                                        sun: plantSun,
                                        water: plantWater,
                                        note: plantNote,
                                        image: plantImage,
                                        id: plantID,
                                        createdTime: createdTime
                )
                self.plantsList.append(plant)
            }
            completion(self.plantsList)
        }
    }
    
    func fetchCommandData(plantID: String, completion: @escaping ([PublishModel]?) -> Void) {
        dataBase.collection("commands").whereField("plantID", isEqualTo: plantID).getDocuments { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                return
            }
            self.commandList.removeAll()
            for commands in querySnapshot.documents {
                let commandObject = commands.data()
                guard let author = commandObject["author"] as? [String: Any] else { return }
                guard let commands = commandObject["commands"] as? [String: Any] else { return }
                let plantID = commandObject["plantID"] as? String ?? ""
                let commandTitle = commandObject["title"] as? String ?? ""
                let commandTime = commandObject["time"] as? String ?? "notime"

                let authorr = Author(name: author["name"] as? String ?? "", id: author["id"] as? String ?? "")
                let commandss = Command(command: commands["command"] as? String ?? "",
                                        commandID: commands["commandID"] as? String ?? "")
                let command = PublishModel(author: authorr, title: commandTitle,
                                           commands: commandss, plantID: plantID,
                                           time: String(commandTime))
                self.commandList.append(command)
            }
            self.commandList.sort { data, data1 in
                return Int(data.time) ?? 0 > Int(data1.time) ?? 1
            }
            completion(self.commandList)
            
        }
    }
    
//    func fetchCommandData(plantID: String, completion: @escaping (Result<[PublishModel], Error>) -> Void) {
//        dataBase.collection("commands").whereField("plantID", isEqualTo: plantID).getDocuments { (querySnapshot, error) in
//            if let error = error {
//                print("Error\(error)")
//                completion(.failure(error))
//            } else if let querySnapshot = querySnapshot {
//                let events = querySnapshot.documents.compactMap({ querySnapshot in
//                    try? querySnapshot.data(as: PublishModel.self)
//
//                })
//                let eventOnData = events.compactMap { event -> PublishModel? in
//                    if event.eventDate.hasSame
//                }
//            }
//        }
//    }
    
    // wherefield auth ID（狀況：時間fetch不下來，所以都改 String 
    func fetchEvent(plantID: String, completion: @escaping ([CalendarModel]?) -> Void) {
        dataBase.collection("events").whereField("plantID", isEqualTo: plantID).getDocuments { (querySnapshot, _) in
                guard let querySnapshot = querySnapshot else {
                    return
                }
                self.eventList.removeAll()
                for event in querySnapshot.documents {
                    let eventObject = event.data(with: ServerTimestampBehavior.none)
//                    guard let eventObject = event else { return }
//                    let eventContent = eventObject["content"]
                    
                    let eventContent = eventObject["content"] as? String ?? ""
                    let eventDate = eventObject["date"] as? String ?? "nono"
                    let eventID = eventObject["plantID"] as? String ?? ""
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
//                    formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
//                    let dateString = formatter.string(from: eventDate)
                    
                    let plant = CalendarModel(eventDate: eventDate,
                                              content: eventContent,
                                              plantID: eventID,
                                              dateString: eventDate
                    )
                    self.eventList.append(plant)
                }
                completion(self.eventList)
                print("get events data")
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
    
    func deleteDate(plantID: String ) {
        let documentRef = dataBase.collection("plants").document("\(plantID)")
        documentRef.delete()
//        let commandRef = dataBase.collection("command").document.whereField("plantID", isEqualTo: plantID)
        
        print("deleted doc!!")
    }
}
