//
//  PopoverView.swift
//  AutoMooz
//
//  Created by Kyle Falconer on 10/24/20.
//

import SwiftUI

struct PopoverView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Auto\nZoom")
                .font(Font.system(size: 34.0))
                .fontWeight(.semibold)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 12.0)
                .frame(width: 300.0, alignment: .topLeading)
            Text("Next Event:")
                .font(.body)
                .multilineTextAlignment(.leading)
            Spacer()
            
            HStack {
                
                Button(action: {
                    NSApp.sendAction(#selector(AppDelegate.openPreferencesWindow), to: nil, from:nil)
                })
                {
                    Text("Settings")
                        .font(.caption)
                }
                .padding(.leading, 16.0)
                Spacer()
                Button(action: {
                   NSApplication.shared.terminate(self)
                })
                {
                    Text("Quit App")
                        .font(.caption)
                }
                .padding(.trailing, 16.0)
            }
           
           }
        .padding(16.0)
    }
}

struct PopoverView_Previews: PreviewProvider {
    static var previews: some View {
        PopoverView()
    }
}
