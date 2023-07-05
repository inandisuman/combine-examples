//
//  Example2.swift
//  combine-examples
//
//  Created by Suman Nandi on 04/07/23.
//

import Foundation
import Combine

extension Notification.Name {
    static let newPost = Notification.Name("newPost")
}

/*
 MODEL
 */
struct NewPost {
    let title: String
}

extension Example2View {
    func postNotification(text: String) {
        let newPostObj = NewPost(title: text)
        //Post the notification
        NotificationCenter.default.post(name: .newPost, object: newPostObj)
    }
}

