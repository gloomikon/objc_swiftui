import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

struct Error: Swift.Error {

    let message: String
}

private typealias EnumCase = (identifier: TokenSyntax, parameters: [(identifier: TokenSyntax?, type: TypeSyntax)])

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


    var asEnumCase: EnumCase? {
        get throws {
            guard let variable = self.as(EnumCaseDeclSyntax.self) else { return nil }

            guard variable.elements.count == 1,
                  let `case` = variable.elements.first else {
                throw Error(message: "Multiple bindings not supported")
            }

            let params = `case`.parameterClause?.parameters.map { param in
                (param.firstName, param.type)
            }

            return (`case`.name, params ?? [])
        }
    }
}

public struct StructuralMacro: MemberMacro {

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        if let structDecl = declaration.as(StructDeclSyntax.self) {
            try structExpansion(of: node, providingMembersOf: structDecl, in: context)
        } else if let enumDecl = declaration.as(EnumDeclSyntax.self) {
            try enumExpansion(of: node, providingMembersOf: enumDecl, in: context)
        } else {
            throw Error(message: "Only works on structs or enums")
        }
    }

    private static func enumExpansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: EnumDeclSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let cases = try declaration.memberBlock.members.compactMap { item in
            try item.decl.asEnumCase
        }

        let typeDecl: DeclSyntax = cases.reversed().reduce("Nothing") { result, `case` in
            let paramList: DeclSyntax = `case`.parameters.reversed().reduce("Empty") { result, param in
                let paramType: DeclSyntax = if param.identifier == nil {
                    "\(param.type)"
                } else {
                    "Property<\(param.type)>"
                }
                return "List<\(paramType), \(result)>"
            }
            return "Choice<\(paramList), \(result)>"
        }

        let casesDecl: [DeclSyntax] = cases.enumerated().map { idx, case_ in
            let bindings = (0..<case_.parameters.count).map { "x\($0)" }
            let list: DeclSyntax = zip(bindings, case_.parameters).reversed().reduce("Empty()") { result, bindingAndParam in
                let binding = bindingAndParam.0
                let param = bindingAndParam.1
                let paramType: DeclSyntax = param.identifier.map { "Property(name: \(literal: $0.text), value: \(raw: binding))"} ?? "\(raw: binding)"
                return "List(head: \(paramType), tail: \(result))"
            }
            let choice: DeclSyntax = Array(repeating: (), count: idx).reduce("Choice.first(\(list))") { result, _ in
                "Choice.second(\(result))"
            }
            let commaSeparatedBindings: DeclSyntax = bindings.isEmpty ? "" : "(\(raw: bindings.joined(separator: ", ")))"
            return """
                            case let .\(case_.identifier)\(commaSeparatedBindings):
                                \(choice)
                            """
        }
        let joinedCasesDecl: DeclSyntax = casesDecl.reduce("") { result, cd in
            "\(result)\n\(cd)"
        }

        func fromDecl(id: String, remainder: [EnumCase]) -> DeclSyntax {
            guard let f = remainder.first else {
                return """
                                switch \(raw: id) {
                                }
                                """
            }
            let paramList = f.parameters.enumerated().map { idx, param in
                let prefix = "f" + Array(repeating: ".tail", count: idx).joined() + ".head"
                return param.identifier.map { "\($0): \(prefix).value" } ?? prefix
            }.joined(separator: ", ")
            return """
                            switch \(raw: id) {
                            case .first(let f):
                                return .\(raw: f.identifier)\(raw: paramList.isEmpty ? "" : "(\(paramList))")
                            case .second(let s):
                                \(fromDecl(id: "s", remainder: Array(remainder.dropFirst())))
                            }
                            """
        }

        return [
            "typealias Structure = Enum<\(typeDecl)>",
            """
            var to: Structure {
                let cases: \(typeDecl) = switch self {
                \(joinedCasesDecl)
                }
                return Enum(name: \(literal: declaration.name.text), cases: cases)
            }
            """,
            """
            static func from(_ s: Structure) -> Self {
                let a0 = s.cases
                \(fromDecl(id: "a0", remainder: cases))
            }
            """
        ]
    }

    private static func structExpansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: StructDeclSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
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
                    name: \(literal: declaration.name.text),
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
