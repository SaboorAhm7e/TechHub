//
//  DeviceViewModel.swift
//  TechHub
//
//  Created by saboor on 23/11/2025.
//

import SwiftUI
import Combine

final class DeviceViewModel: ObservableObject {
    
    @Published var state : DataLoadingState = .start
    @Published var devices : [DeviceModel] = []
    @Published var filteredDevices : [DeviceModel] = []
    
    // MARK: - Listing
    func fetchData() async throws {
        let endpoint = "https://api.restful-api.dev/objects"
        guard let url = URL(string: endpoint) else {
            state = .end
            throw NetworkError.invalidURL
        }
        do {
            let (data,response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse,(200...299).contains(response.statusCode) else {
                state = .end
                throw NetworkError.serverError
            }
            guard let decodedJSON = try? JSONDecoder().decode([DeviceModel].self, from: data) else {
                print("parsing error")
                state = .end
                throw NetworkError.decodingError
            }
            state = .end
            self.devices = decodedJSON
            self.filteredDevices = decodedJSON
        } catch {
            state = .end
            throw NetworkError.networkError
        }
     
    }
    // MARK: - Detail
    func fetchDetail(id:String) async throws -> [String:String]{
        let endpoint = "https://api.restful-api.dev/objects/\(id)"
        guard let url = URL(string: endpoint) else {
            print("invalid url")
            state = .end
            throw NetworkError.invalidURL
        }
        do {
            let (data,response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse,(200...299).contains(response.statusCode) else {
                print("server error")
                state = .end
                throw NetworkError.serverError
            }
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                state = .end
                return [:]
            }
            guard let innerData = jsonObject["data"] as? [String:Any] else {
                print("data is null")
                state = .end
                return [:]
            }
            var dict : [String:String] = [:]
            for (key,value) in innerData {
                dict[key] = "\(value)"
            }
            state = .end
            return dict
            
        } catch {
            throw NetworkError.networkError
        }
    }
    // MARK: - Filter
    func filter(_ searchText:String) {
        if searchText.isEmpty {
            filteredDevices = devices
        } else {
            
            filteredDevices = devices.filter{ $0.name.lowercased().contains(searchText.lowercased())}
            
        }
    }
    
}
