@attached(member, names: named(Structure), named(to), named(from))
@attached(extension, conformances: Structural)
public macro Structural() = #externalMacro(
    module: "StructuralProgrammingMacros",
    type: "StructuralMacro"
)
