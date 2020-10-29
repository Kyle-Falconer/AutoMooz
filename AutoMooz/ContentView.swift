//
//  ContentView.swift
//  AutoMooz
//
//  Created by Kyle Falconer on 10/24/20.
//

import SwiftUI

struct ContentView: View {
    var zoomEvent: ZoomEvent
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                Text("Your meeting is ready")
                    .font(.system(size: geometry.size.width/20))
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 30)
                    .padding(.top, 30)
                Text("\(zoomEvent.title)")
                    .font(.system(size: geometry.size.width/10))
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 30)
                Text("\(zoomEvent.getHumanTime())")
                    .font(.system(size: geometry.size.width/20))
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 30)
                
                HStack {
                    Button(action: {
                        print("join button clicked")
                        ZoomAppHelper.launchZoom(meetingUrl: zoomEvent.zoomLink!)
                        NSApplication.shared.keyWindow?.close()
                    }) {
                        Text("Join")
                            .font(.system(size: geometry.size.width/6))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color.green))
                    }.buttonStyle(PlainButtonStyle())
                    Button(action: {
                         NSApplication.shared.keyWindow?.close()
//                        NSApp.hide(self)
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
        ContentView(zoomEvent: createPreviewZoomEvent())
    }
    static func createPreviewZoomEvent() -> ZoomEvent {
        let endDate: Date = Date().addingTimeInterval(300)
        return ZoomEvent.init(title: "Movie Night", startDate: Date(), endDate: endDate, originatingCalendarName: "College Events", zoomLink: "https://zoom.us/j/91858408639")
    }
}
