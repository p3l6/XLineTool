//
//  ContentView.swift
//  XLineTool
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("First: Enable this extension in system preferences. Then, relaunch xcode, and search for 'xline' in the Key Bindings filter to assign shortcuts.")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
