//
//  DetailView.swift
//  TechHub
//
//  Created by saboor on 22/11/2025.
//

import SwiftUI

struct DetailView: View {
    var device : DeviceModel
    @State var dataDict : [String:String] = [:]
    @State var state : DataLoadingState = .start
    var body: some View {
        VStack {
            Text(device.name)
                .font(.title2)
            switch state {
            case .start:
                List {
                    ForEach(0..<4,id: \.self) { _ in
                      Text("Device detail goes here")
                            .redacted(reason: .placeholder)
                    }
                }
                .listStyle(.inset)
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
           dataDict = await fetchDetail()
        }
    }
    func fetchDetail() async -> [String:String]{
        let endpoint = "https://api.restful-api.dev/objects/\(device.id)"
        guard let url = URL(string: endpoint) else {
            print("invalid url")
            state = .end
            return [:]
        }
        do {
            let (data,response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse,(200...299).contains(response.statusCode) else {
                print("server error")
                state = .end
                return [:]
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
            print(dict)
            state = .end
            return dict
            
            
        } catch {
            print("network error")
        }
        state = .end
        return [:]
    }
}

//struct Device2Model : Codable {
//    let id : String
//    let name : String
//    var data : DeviceDetailModel?
//}
//struct DeviceDetailModel : Codable {
//    var CPUModel : String?
//    var diskSize : String?
//    var price : Double?
//    var year : Int?
//    
//    enum CodingKeys : String, CodingKey {
//        case CPUModel = "CPU model"
//        case diskSize = "Hard disk size"
//        case price = "price"
//        case year = "year"
//    }
//}
#Preview {
    DetailView(device: .init(id: "1", name: "hello"))
}
