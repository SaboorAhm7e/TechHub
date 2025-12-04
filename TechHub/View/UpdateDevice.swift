//
//  UpdateDevice.swift
//  TechHub
//
//  Created by saboor on 04/12/2025.
//

import SwiftUI

struct UpdateDevice: View {
    @EnvironmentObject var viewModel : DeviceViewModel
    @State var deviceName : String = "Apple"
    @State var specName : String = ""
    @State var specValue : String = ""
    @State var deviceSpecs : [SpecModel] = []
    @State var dataDict : [String:String] = [:]
    @State var device : DeviceModel
    var body: some View {
        Form {
            TextField("Enter Device Name", text: $deviceName)
                .textFieldStyle(.roundedBorder)
                //.focused($focusField, equals: .deviceName)
            Section {
                List {
                    
                    
                    ForEach($deviceSpecs) { $spec in
                        HStack {
                            TextField("", text: $spec.name)
                                .textFieldStyle(.roundedBorder)
                            TextField("", text: $spec.value)
                                .textFieldStyle(.roundedBorder)
                            
                            Button("", systemImage: "trash") {
                                deleteSpec(id: spec.id.uuidString)
                            }
                            .foregroundStyle(Color.red)
                        }
                    }
                    
                    HStack {
                        TextField("Spec Name", text: $specName)
                            .textFieldStyle(.roundedBorder)
                        TextField("Spec Value", text: $specValue)
                            .textFieldStyle(.roundedBorder)
                        
                        Button("", systemImage: "plus") {
                            addSpec()
                        }
                    }
                   
                }
                
                Button("Update Device") {
                    Task {
                        do {
                            try await update()
                            
                        } catch let error as NetworkError {
                            print(error)
                        } catch {
                            print("unknown erro")
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .buttonSizing(.flexible)
            }
            
            
        }
        .onAppear {
            deviceName = device.name
        }
        .task {
            await fetch()
        }
    }
    func deleteSpec(id:String) {
        deviceSpecs.removeAll(where: {$0.id.uuidString == id})
    }
    func addSpec() {
        let spec = SpecModel(name: specName, value: specValue)
        deviceSpecs.append(spec)
    }
    func fetch() async {
        
        do {
            viewModel.state = .start
            dataDict = try await viewModel.fetchDetail(id: device.id)
            for (key,value) in dataDict {
                deviceSpecs.append(SpecModel(name: key, value: value))
            }
        } catch let error as NetworkError {
            print(error)
        } catch {
            print("unknown error")
        }
    }
    func update() async throws {
        var model = AddDeviceModel(name: deviceName, data: [:])
        for v in deviceSpecs {
            model.data[v.name] = v.value
        }
        guard let url = URL(string: "https://api.restful-api.dev/objects/\(device.id)") else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoded = try? JSONEncoder().encode(model)
        request.httpBody = encoded
        do {
            let (_,response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse,(200...299).contains(response.statusCode) else {
                throw NetworkError.serverError
            }
            print(response)
            
        } catch {
            throw NetworkError.networkError(error: error.localizedDescription)
        }
        
        
        
    }
}

//#Preview {
//    UpdateDevice()
//}
