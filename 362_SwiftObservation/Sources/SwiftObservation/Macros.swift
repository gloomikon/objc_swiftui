@attached(member, names: named(_registrar), arbitrary)
@attached(memberAttribute)
macro SwiftObservable() = #externalMacro(module: "SwiftObservationMacros", type: "ObservableMacro")

@attached(accessor)
macro SwiftObservedProperty() = #externalMacro(module: "SwiftObservationMacros", type: "SwiftObservedPropertyMacro")
