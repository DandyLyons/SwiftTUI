import Foundation

public struct _ConditionalView<TrueContent: View, FalseContent: View>: View, PrimitiveView {
    enum ConditionalContent {
        case a(TrueContent)
        case b(FalseContent)
    }

    let content: ConditionalContent

    static var size: Int? {
        if ViewWrapper<TrueContent>.size == ViewWrapper<FalseContent>.size { return ViewWrapper<TrueContent>.size }
        return nil
    }

    func buildNode(_ node: Node) {
        switch content {
        case .a(let value):
            node.addNode(at: 0, Node(viewWrapper: ViewWrapper(view: value)))
        case .b(let value):
            node.addNode(at: 0, Node(viewWrapper: ViewWrapper(view: value)))
        }
    }

    func updateNode(_ node: Node) {
        let last = (node.viewWrapper as! ViewWrapper<Self>).view
        node.viewWrapper = ViewWrapper(view: self)
        switch (last.content, self.content) {
        case (.a, .a(let newValue)):
            node.children[0].update(using: ViewWrapper(view: newValue))
        case (.b, .b(let newValue)):
            node.children[0].update(using: ViewWrapper(view: newValue))
        case (.b, .a(let newValue)):
            node.removeNode(at: 0)
            node.addNode(at: 0, Node(viewWrapper: ViewWrapper(view: newValue)))
        case (.a, .b(let newValue)):
            node.removeNode(at: 0)
            node.addNode(at: 0, Node(viewWrapper: ViewWrapper(view: newValue)))
        }
    }
}