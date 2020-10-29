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
            
            Image("AutoMooz")
                .resizable()
                .frame(width: 170.0, height: 104.0, alignment: .topLeading)
                .padding(.bottom, 12.0)
                
                
            Text("Next Event:")
                .font(.body)
                .multilineTextAlignment(.leading)
            Spacer()
            
            HStack {
                
                Button(action: {
                    SfxHelper.moo()
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
