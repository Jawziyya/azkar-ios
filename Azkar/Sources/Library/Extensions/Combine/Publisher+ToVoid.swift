// Copyright © 2021 Al Jawziyya. All rights reserved. 

import Combine
import Foundation

extension AnyPublisher {
    
    func toVoid() -> AnyPublisher<Void, Failure> {
        self
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
}
