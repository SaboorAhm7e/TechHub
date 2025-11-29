//
//  AddDeviceView.swift
//  TechHub
//
//  Created by saboor on 24/11/2025.
//

import SwiftUI

struct AddDeviceView: View {
    // MARK: - properties
    enum FocusedField {
        case deviceName
        case specname
        case specvalue
    }
    @FocusState private var focusField : FocusedField?
    @State var deviceName : String = ""
    @State var specName : String = ""
    @State var specValue : String = ""
    @State var deviceSpecs : [SpecModel] = []
    @Environment(\.dismiss) var dismiss
    @State var showProgress : Bool = false
    @EnvironmentObject var viewModel: DeviceViewModel
    // MARK: - body
    var body: some View {
                
                Form {
                    TextField("Enter Device Name", text: $deviceName)
                        .textFieldStyle(.roundedBorder)
                        .focused($focusField, equals: .deviceName)
                    if !deviceSpecs.isEmpty {
                        Section("Specs"){
                            ForEach(deviceSpecs) { spec in
                                LabeledContent(spec.name, value: spec.value)
                            }
                        }
                    }
                        
                   
                        Section("Add Specs"){
                            HStack {
                                TextField("Name", text: $specName)
                                    .textFieldStyle(.roundedBorder)
                                    .focused($focusField, equals: .specname)
                                    
                                TextField("Value",text: $specValue)
                                    .textFieldStyle(.roundedBorder)
                                    .focused($focusField, equals: .specvalue)
                                Button {
                                    addSpecs()
                                } label: {
                                    Image(systemName: "plus")
                                }
                                .buttonStyle(.borderedProminent)
                                .buttonBorderShape(.roundedRectangle)

                            }
                            Button("Add Device") {
                               addDevice()
                            }
                            .buttonStyle(.bordered)
                            .buttonSizing(.flexible)
                            .disabled(deviceName.isEmpty ? true : false)
                        }
                       
                }
                .formStyle(.grouped)
                .overlay {
                    if showProgress {
                        ProgressView()
                    }
                    
                }
                .onDisappear {
                    showProgress = false
                }
               // .padding(.horizontal)
                .navigationTitle("Device")
    }
    // MARK: - method
    func addSpecs() {
        guard  specName.isEmpty == false,specValue.isEmpty == false else {
            return
        }
        let spec = SpecModel(name: specName, value: specValue)
        deviceSpecs.append(spec)
        specName = ""
        specValue = ""
        focusField = nil
    }
    func addDevice() {
        var deviceData = AddDeviceModel(name: deviceName, data: [:])
        for v in deviceSpecs {
            deviceData.data[v.name] = v.value
        }
        Task {
            do {
               let status = try await viewModel.addDevice(model: deviceData)
                if status {
                    dismiss()
                }
            } catch NetworkError.invalidURL{
                print("invalid url")
            } catch NetworkError.decodingError {
                print("decoding error")
            } catch NetworkError.networkError {
                print("network error")
            } catch NetworkError.serverError {
                print("server error")
            } catch {
                print("unknown error")
            }
            
        }
    }
}

#Preview {
    AddDeviceView()
}
