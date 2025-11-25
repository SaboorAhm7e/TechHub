//
//  AddDeviceView.swift
//  TechHub
//
//  Created by saboor on 24/11/2025.
//

import SwiftUI

struct AddDeviceView: View {
    @State var deviceName : String = ""
    @State var specName : String = ""
    @State var specValue : String = ""
    @State var deviceSpecs : [SpecModel] = []
    var body: some View {
        NavigationStack {
            VStack(alignment:.leading,spacing:15) {
                TextField("Enter Device Name", text: $deviceName)
                    .textFieldStyle(.roundedBorder)
                List {
                    ForEach(deviceSpecs) { spec in
                        LabeledContent(spec.name, value: spec.value)
                    }
                }
                .listStyle(.inset)
                
                
                Text("Add Specs")
              
                HStack {
                    TextField("Name", text: $specName)
                        .textFieldStyle(.roundedBorder)
                    TextField("Value",text: $specValue)
                        .textFieldStyle(.roundedBorder)
                    Button {
                        guard  specName.isEmpty == false,specValue.isEmpty == false else {
                            return
                        }
                        let spec = SpecModel(name: specName, value: specValue)
                        deviceSpecs.append(spec)
                        specName = ""
                        specValue = ""
                    } label: {
                        Image(systemName: "plus")
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle)

                }
                
                Button("Add Device") {
                    Task {
                        await addDevice()
                    }
                   
                }
                .buttonStyle(.bordered)
                .buttonSizing(.flexible)
                .disabled(deviceName.isEmpty ? true : false)
                
                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("Device")
        }
    }
    func addDevice() async {
        let endpoint = "https://api.restful-api.dev/objects"
        guard let url = URL(string: endpoint) else {
            print("invalid url")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        var deviceData = AddDeviceModel(name: deviceName, data: [:])
        for v in deviceSpecs {
            deviceData.data[v.name] = v.value
        }
        guard let jsonData = try? JSONEncoder().encode(deviceData) else {
            print("failed to parse data")
            return
        }
        request.httpBody = jsonData
        do {
            let (data,response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse,(200...299).contains(response.statusCode) else {
                print("server error")
                return
            }
            guard let decoded = try? JSONDecoder().decode(DeviceModel.self, from: data) else {
                print("decoding error")
                return
            }
            print("decode: ",decoded)
            
            
        } catch {
            print("network error")
        }
    }
}
struct SpecModel: Identifiable {
    var id = UUID()
    let name : String
    let value : String
}
struct AddDeviceModel : Codable {
    var name : String
    var data : [String:String]
}

#Preview {
    AddDeviceView()
}
