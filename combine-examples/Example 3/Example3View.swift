//
//  Example3View.swift
//  combine-examples
//
//  Created by Suman Nandi on 04/07/23.
//

import SwiftUI
import Combine

struct Example3View: View {

    @StateObject private var vm = Example3ViewModel()
    @State var submitButtonDisabled = true
    @State var subscriber: AnyCancellable?
    
    var body: some View {
        VStack {
            Toggle("I accept terms and conditions", isOn: $vm.termsAndConditions)
            Toggle("I accept privacy", isOn: $vm.privacy)
            TextField("Enter name here", text: $vm.nameTextField)
            Button {
                // Submit Form
            } label: {
                Text("Submit")
            }
            .disabled(submitButtonDisabled)
            .padding()
            .background(.gray)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .padding(10)
        .onAppear {
            subscriber = vm.notValidToSubmit
                .receive(on: DispatchQueue.main)
                .assign(to: \.submitButtonDisabled, on: self)
        }
        
    }
}

struct Example3View_Previews: PreviewProvider {
    static var previews: some View {
        Example3View()
    }
}
