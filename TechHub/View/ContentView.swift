//
//  ContentView.swift
//  TechHub
//
//  Created by saboor on 21/11/2025.
//

import SwiftUI

struct ContentView: View {
   
    @StateObject var viewModel = DeviceViewModel()
    @State var searchText : String = ""
    @State var path = NavigationPath()
    // MARK: - body
    var body: some View {
        
        NavigationStack(path: $path) {
            VStack {
                switch viewModel.state {
                case .start:
                    EmptyListing(rows: .constant(10))
                case .end:
                    if viewModel.devices.isEmpty {
                        ContentUnavailableView {
                            Label("Opps! No Data", systemImage: "questionmark.text.page")
                        } description: {
                            Text("Turn on the internet access in settings.")
                        } actions: {
                            Button("Go to Settings") {
                                //
                            }
                        }
                    } else {
                        List {
                            ForEach(viewModel.filteredDevices) { device in
                                NavigationLink(value: NavigationRute.showDetail(device)) {
                                    Label(device.name, systemImage: device.icon)
                                        .swipeActions {
                                            Button("", systemImage: "trash") {
                                                Task {
                                                    
                                                    await delete(id: device.id)
                                                }
                                            }
                                            .tint(.red)
                                        }
                                }
                                
                            }
                        }
                        .listStyle(.inset)
                        .animation(.easeInOut, value: viewModel.filteredDevices)
                        .searchable(text: $searchText, prompt: "search here")
                        .onChange(of: searchText) { _, _ in
                            
                            viewModel.filter(searchText)
                        }
                    }
                }
            }
            .navigationTitle("Devices")
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("", systemImage: "plus") {
                        path.append(NavigationRute.addDevice(UUID()))
                    }
                }
            })
            .navigationDestination(for: NavigationRute.self, destination: { route in
                let _ = print(route)
                switch route {
                case .showDetail(let device):
                    DetailView(device: device,navigationPath: $path)
                        .environmentObject(viewModel)
                case .addDevice:
                    AddDeviceView()
                        .environmentObject(viewModel)
                case .updateDevice(let device):
                    UpdateDevice(device:device)
                        .environmentObject(viewModel)
                }
            })
            .task {
                await fetch()
            }
            
        }
        
        
    }
    // MARK: - method
    func fetch() async {
        
        do {
            try await viewModel.fetchData()
        } catch let error as NetworkError {
            print(error)
        } catch {
            print("Unknown error")
        }
    }
    func delete(id:String) async {
        do {
            try await viewModel.delete(id: id)
        } catch let error as NetworkError {
            print(error)
        } catch {
            print("unknown erro")
        }
    }
    

}



#Preview {
    ContentView()
}
