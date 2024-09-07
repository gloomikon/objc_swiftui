import SwiftSyntax
import SwiftSyntaxMacros

struct SwiftObservedPropertyMacro: AccessorMacro {

    static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        guard let (name, _) = declaration.storedProperty else { return [] }
        return [
            """
            get {
                _registrar.access(self, \\.\(name))
                return _\(name)
            }
            set {
                _registrar.willSet(self, \\.\(name))
                _\(name) = newValue
            }
            """
        ]
    }
}
