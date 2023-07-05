//
//  Example3.swift
//  combine-examples
//
//  Created by Suman Nandi on 04/07/23.
//

import Foundation
import Combine

class Example3ViewModel: ObservableObject {
    
    @Published var termsAndConditions = false
    @Published var privacy = false
    @Published var nameTextField = ""
    
    var notValidToSubmit: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest3($termsAndConditions, $privacy, $nameTextField)
            .map { terms, privacy, name in
                return !terms && !privacy && name.isEmpty
            }
            .eraseToAnyPublisher()
    }
}

