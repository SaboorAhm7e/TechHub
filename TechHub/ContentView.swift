//
//  ContentView.swift
//  TechHub
//
//  Created by saboor on 21/11/2025.
//

import SwiftUI
enum DataLoadingState {
    case start,end
}

struct ContentView: View {
    @State var devices : [DeviceModel] = []
    @State var state : DataLoadingState = .start
    var body: some View {
        NavigationStack {
            VStack {
                // MARK: - 3
                switch state {
                case .start:
                    List {
                        ForEach(0..<10,id: \.self) { _ in
                            Text("hello world!")
                                .redacted(reason: .placeholder )
                        }
                    }
                case .end:
                    if devices.isEmpty {
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
                            ForEach(devices) { device in
                                NavigationLink(value: device) {
                                    Text(device.name)
                                }
                                
                            }
                        }
                    }
                }
            }
            .navigationTitle("Devices")
            .navigationDestination(for: DeviceModel.self, destination: { device in
                DetailView(device: device)
            })
            .task {
               devices = await fetchData()
            }
        }
        
    }
    func fetchData() async -> [DeviceModel] {
        let endpoint = "https://api.restful-api.dev/objects"
        guard let url = URL(string: endpoint) else {
            state = .end
            return []
        }
        do {
            let (data,response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse,(200...299).contains(response.statusCode) else {
                state = .end
                print("server error")
                return []
            }
            guard let decodedJSON = try? JSONDecoder().decode([DeviceModel].self, from: data) else {
                print("parsing error")
                state = .end
                return []
            }
            state = .end
            return decodedJSON
        } catch {
            state = .end
            print("network error")
        }
        state = .end
        return []
     
    }
}

struct DeviceModel : Identifiable,Hashable, Codable, Equatable {
    let id : String
    let name : String
}

#Preview {
    ContentView()
}
