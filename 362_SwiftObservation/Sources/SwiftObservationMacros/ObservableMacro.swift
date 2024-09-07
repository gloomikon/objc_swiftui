import SwiftSyntax
import SwiftSyntaxMacros

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

extension ObservableMacro: MemberAttributeMacro {
    static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingAttributesFor member: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AttributeSyntax] {
        guard let _ = member.storedProperty else { return [] }
        return ["@SwiftObservedProperty"]
    }
}
