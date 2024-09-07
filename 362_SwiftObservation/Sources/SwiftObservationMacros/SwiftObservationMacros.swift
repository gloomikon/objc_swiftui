import SwiftSyntax
import SwiftSyntaxMacros

private extension DeclSyntax {
    var storedProperty: (TokenSyntax, ExprSyntax)? {
        guard let variable = self.as(VariableDeclSyntax.self) else { return nil }
        guard let binding = variable.bindings.first else { return nil }
        guard let id = binding.pattern.as(IdentifierPatternSyntax.self) else { return nil }
        if id.identifier.text.hasPrefix("_") { return nil }

        guard let value = binding.initializer?.value else { return nil }

        return (id.identifier, value)
    }
}

struct ObservableMacro: MemberMacro {

    static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let storedProperties: [DeclSyntax] = declaration.memberBlock.members.compactMap {
            guard let (name, value) = $0.decl.storedProperty else { return nil }
            return "private var _\(name) = \(value)"
        }
        return [
            "private var _registrar = Registrar()"
        ] + storedProperties
    }
}
