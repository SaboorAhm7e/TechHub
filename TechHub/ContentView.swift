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
    @StateObject var viewModel = DeviceViewModel()
    // MARK: - body
    var body: some View {
        NavigationStack {
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
                            ForEach(viewModel.devices) { device in
                                NavigationLink(value: device) {
                                    Text(device.name)
                                }
                                
                            }
                        }
                        .listStyle(.inset)
                    }
                }
            }
            .navigationTitle("Devices")
            .navigationDestination(for: DeviceModel.self, destination: { device in
                DetailView(device: device)
                    .environmentObject(viewModel)
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
        } catch NetworkError.networkError {
            print("network error")
        } catch NetworkError.invalidURL {
            print("invalid url")
        } catch NetworkError.serverError {
            print("server error")
        } catch NetworkError.decodingError {
            print("decoding error")
        } catch {
            print("unknown error")
        }
    }
}



#Preview {
    ContentView()
}
