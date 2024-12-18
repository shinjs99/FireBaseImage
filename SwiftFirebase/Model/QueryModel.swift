import FirebaseFirestore

class QueryModel {
    var db = Firestore.firestore()
    
    func fetchUserData(completion: @escaping ([DBModel]) -> Void) {
        db.collection("memos").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                completion([]) // 에러 발생 시 빈 배열 반환
                return
            }
            
            var userList: [DBModel] = []
            
            for document in snapshot!.documents {
                let data = document.data()
                
                let name = data["name"] as? String ?? "Unknown"
                let phone = data["phone"] as? String ?? "Unknown"
                let image = data["image"] as? String ?? "Unknown"
                let relation = data["relation"] as? String ?? "Unknown"
                let address = data["address"] as? String ?? "Unknown"
                let user = DBModel(name: name, phone: phone, image: image, relation: relation, address: address)
                print(image)
                print(user)
                userList.append(user)
            }
            
            completion(userList)
        }
    }
}
