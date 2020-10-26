//
//  ContentView.swift
//  AutoMooz
//
//  Created by Kyle Falconer on 10/24/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                Text("Your meeting is ready")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                HStack {
                    Button(action: {
                        print("join button clicked")
                    }) {
                        Text("Join")
                            .font(.system(size: geometry.size.width/6))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color.green))
                    }.buttonStyle(PlainButtonStyle())
                    Button(action: {
                        // NSApplication.shared.keyWindow?.close()
                        NSApp.hide(self)
                    }) {
                        Text("Leave")
                            .font(.system(size: geometry.size.width/6))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color.red))
                    }.buttonStyle(PlainButtonStyle())
                }
            }
        }
    }

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
