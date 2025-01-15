import UIKit

typealias Constraint = (_ child: UIView, _ parent: UIView) -> NSLayoutConstraint

@resultBuilder enum ConstraintBuilder {

    static func buildBlock(_ components: Constraint...) -> [Constraint] {
        components
    }
}

@MainActor
func equal<L, Axis>(_ to: KeyPath<UIView, L>) -> Constraint where L: NSLayoutAnchor<Axis> {
    { view, parent in
        view[keyPath: to].constraint(equalTo: parent[keyPath: to])
    }
}

@MainActor
func equal<L>(_ keyPath: KeyPath<UIView, L>, to constant: CGFloat) -> Constraint where L: NSLayoutDimension {
    { view, _ in
        view[keyPath: keyPath].constraint(equalToConstant: constant)
    }
}

@MainActor
func equal<L, Axis>(_ from: KeyPath<UIView, L>, _ to: KeyPath<UIView, L>) -> Constraint where L: NSLayoutAnchor<Axis> {
    { view, parent in
        view[keyPath: from].constraint(equalTo: parent[keyPath: to])
    }
}

extension UIView {
    func addSubview(
        _ other: UIView,
        @ConstraintBuilder constraints: () -> [Constraint]
    ) {
        addSubview(other)
        other.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints().map { constraint in
            constraint(other, self)
        })
    }
}


let view = UIView()

let child = UIView()

view.addSubview(child) {
    equal(\.leftAnchor)
    equal(\.rightAnchor)
    equal(\.topAnchor)
    equal(\.bottomAnchor)
}
