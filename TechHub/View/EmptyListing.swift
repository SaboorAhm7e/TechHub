//
//  EmptyListing.swift
//  TechHub
//
//  Created by saboor on 23/11/2025.
//

import SwiftUI

struct EmptyListing: View {
    @Binding var rows: Int
    var body: some View {
        List {
            ForEach(0..<rows,id: \.self) { _ in
                Text("hello world apps!")
                    .redacted(reason: .placeholder )
            }
        }
        .listStyle(.inset)
    }
}

#Preview {
    EmptyListing(rows: .constant(5))
}
