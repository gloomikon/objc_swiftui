import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

struct Error: Swift.Error {

    let message: String
}

private extension DeclSyntax {

    var asStoredProperty: (TokenSyntax, TypeSyntax)? {
        get throws {
            guard let variable = self.as(VariableDeclSyntax.self) else { return nil }
            guard variable.bindings.count == 1,
                  let binding = variable.bindings.first else {
                throw Error(message: "Multiple bindings not supported")
            }

            guard binding.accessorBlock == nil else { return nil }

            guard let id = binding.pattern.as(IdentifierPatternSyntax.self) else {
                throw Error(message: "Only Identifier pattern supported")
            }

            let token = id.identifier

            guard let type = binding.typeAnnotation?.type else {
                throw Error(message: "Only properties with explicit type's supported")
            }

            return (token, type)
        }
    }
}

public struct StructuralMacro: MemberMacro {

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            throw Error(message: "Only works on structs")
        }

        let storedProperties = try declaration.memberBlock.members.compactMap { item in
            try item.decl.asStoredProperty
        }

        let typeDecl: DeclSyntax = storedProperties.reversed().reduce("Empty") { result, property in
            "List<Property<\(property.1)>, \(result)>"
        }

        let propsDecl: DeclSyntax = storedProperties.reversed().reduce("Empty()") { result, property in
            "List(head: Property(name: \(literal: property.0.text), value: \(property.0)), tail: \(result))"
        }

        let fromDecl = storedProperties.enumerated().map { index, property in
            let (name, _) = property
            let tails = Array(repeating: ".tail", count: index).joined()
            return "\(name): structure.properties\(tails).head.value"
        }.joined(separator: ",\n")

        return [
            "typealias Structure = Struct<\(typeDecl)>",
            """
            var to: Structure {
                Structure(
                    name: \(literal: structDecl.name.text),
                    properties: \(propsDecl)
                )
            }
            """,
            """
            static func from(_ structure: Structure) -> Self {
                .init(
                    \(raw: fromDecl)
                )
            }
            """
        ]
    }
}

extension StructuralMacro: ExtensionMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
        providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo protocols: [SwiftSyntax.TypeSyntax],
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        let declSyntax: DeclSyntax = "extension \(type.trimmed): Structural { }"
        return [
            declSyntax.as(ExtensionDeclSyntax.self)!
        ]
    }
}
