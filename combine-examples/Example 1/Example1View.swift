//
//  Example1View.swift
//  combine-examples
//
//  Created by Suman Nandi on 04/07/23.
//

import SwiftUI

struct Example1View: View {
    
    @StateObject private var vm = ExampleViewModel()
    
    var body: some View {
        List {
            ForEach(vm.posts) { post in
                Text(post.title)
            }
        }
        .task {
            await vm.getItemsFromService()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Example1View()
    }
}
