import SwiftUI

protocol Coordinator: AnyObject {
    associatedtype Body: View
    
    @ViewBuilder
    func start() -> Body
}
