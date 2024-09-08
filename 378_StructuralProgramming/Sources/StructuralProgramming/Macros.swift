@attached(member, names: named(Structure), named(to), named(from))
public macro Structural() = #externalMacro(
    module: "StructuralProgrammingMacros",
    type: "StructuralMacro"
)
