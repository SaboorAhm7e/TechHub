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
            throw NetworkError.networkError(error: error.localizedDescription)
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
            throw NetworkError.networkError(error: error.localizedDescription)
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
    
    func addDevice(model:AddDeviceModel) async throws -> Bool {
        let endpoint = "https://api.restful-api.dev/objects"
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let encoded = try? JSONEncoder().encode(model) else {
            throw NetworkError.decodingError
        }
        request.httpBody = encoded
        
        do {
            let (_,response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                throw NetworkError.serverError
            }
            return true
            
        } catch {
            throw NetworkError.networkError(error: error.localizedDescription)
        }
    }
    // MARK: - Delete
    
    func delete(id:String) async throws {
        let endpoint = "https://api.restful-api.dev/objects/\(id)"
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        do {
            let(_,response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse,(200...299).contains(response.statusCode) else {
                throw NetworkError.serverError
            }
        } catch  {
            throw NetworkError.networkError(error: error.localizedDescription)
        }
    }
    
}
