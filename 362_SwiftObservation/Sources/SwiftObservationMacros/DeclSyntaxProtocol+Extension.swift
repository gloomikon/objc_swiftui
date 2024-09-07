import SwiftSyntax
import SwiftSyntaxMacros

extension DeclSyntaxProtocol {
    var storedProperty: (TokenSyntax, ExprSyntax)? {
        guard let variable = self.as(VariableDeclSyntax.self) else { return nil }
        guard let binding = variable.bindings.first else { return nil }
        guard let id = binding.pattern.as(IdentifierPatternSyntax.self) else { return nil }
        if id.identifier.text.hasPrefix("_") { return nil }

        guard let value = binding.initializer?.value else { return nil }

        return (id.identifier, value)
    }
}
