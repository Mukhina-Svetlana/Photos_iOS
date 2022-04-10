//
//  Networking.swift
//  VK_iOSPhoto
//
//  Created by Светлана Мухина on 06.04.2022.
//

import Foundation
import UIKit
protocol NetworkRequest {
    func request(completion: @escaping ([GetModel]) -> Void)
}

class Networking: NetworkRequest {
    var alert: (() -> Void)?
    
    func request(completion: @escaping ([GetModel]) -> Void) {
        let urlString = "https://api.vk.com/method/photos.get?album_id=249132349&access_token=0b955c85447b0e0616d609d42df38bd061aa0ca029bb337bf5d7180ae9c3ccf17123f15a995a9ad427bf9&owner_id=-28535403&v=5.131"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession.init(configuration: .default)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
               // guard let data = data else { return }
                if let data = data {
                if let currentModel = self.parsJson(withData: data) {
                    completion(currentModel)
                }
                }
                if error != nil {
                    self.alert!()
                }
            }
        }
        task.resume()
    }

    private func parsJson(withData data: Data) -> [GetModel]? {
        let decoder = JSONDecoder()
        do {
            let currentData = try decoder.decode(Model.self, from: data)
            var arrayInfoData = [GetModel]()
            for i in currentData.response.items {
                arrayInfoData.append(GetModel(info: i))
            }
            return arrayInfoData
        } catch let error as NSError{
            print(error.localizedDescription)
            alert!()
        }
        return nil
    }
}
