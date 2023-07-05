//
//  Example2View.swift
//  combine-examples
//
//  Created by Suman Nandi on 04/07/23.
//

import SwiftUI
import Combine

struct Example2View: View {
    
    @State private var textEntered = ""
    @State private var title = ""
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter:", text: $textEntered)
                    .frame(height: 50)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.horizontal], 4)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
                
                Button {
                    // Publish the data entered
                    postNotification(text: textEntered)
                } label: {
                    Text("Publish")
                        .padding()
                }
                .background(.gray)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
            
            Spacer()
            
            HStack {
                Text("Data received: \(title)")
            }
        }
        .onAppear {
            // Create a publisher
            let publisher = NotificationCenter.Publisher(center: .default, name: .newPost, object: nil)
                .map { notification -> String in
                    return (notification.object as? NewPost)?.title ?? ""
                }
            
            // Create a subscriber
            let subscriber = Subscribers.Assign(object: self, keyPath: \.title)
            publisher.subscribe(subscriber)
        }
    }
}

struct Example2View_Previews: PreviewProvider {
    static var previews: some View {
        Example2View()
    }
}
