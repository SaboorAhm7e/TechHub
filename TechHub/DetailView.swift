//
//  DetailView.swift
//  TechHub
//
//  Created by saboor on 22/11/2025.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var viewModel : DeviceViewModel
    var device : DeviceModel
    @State var dataDict : [String:String] = [:]
    // MARK: - body
    var body: some View {
        VStack {
            Image(systemName: device.icon)
                .font(.title)
            Text(device.name)
                .font(.title2)
            switch viewModel.state {
            case .start:
                EmptyListing(rows: .constant(3))
            case .end:
                if dataDict.isEmpty {
                    ContentUnavailableView("Opps! no data found", systemImage: "questionmark.text.page")
                } else {
                    List {
                        ForEach(Array(dataDict.keys),id:\.self) { key in
                            if let value = dataDict[key] {
                                LabeledContent(key , value: value)
                            }
                        }
                    }
                    .listStyle(.inset)
                }
            }
           
            Spacer()
        }
        .task {
          await fetch()
        }
    }
    // MARK: - Method
    func fetch() async {
        do {
            viewModel.state = .start
            dataDict = try await viewModel.fetchDetail(id: device.id)
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
    DetailView(device: .init(id: "1", name: "hello"))
}
