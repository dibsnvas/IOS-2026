# ALMA-7 Part III: written answers

## Level 1 · The Power Cell

Why a class: a cell is one physical battery, so everyone holding it must drain and refill the same charge.

Encapsulation proof (leave this commented, with the compiler error):
    cell.charge = 100
    error: 'charge' is inaccessible due to 'private' protection level

## Level 2 · The Fleet

final on runOnce(): no subclass can skip paying powerCost or change the order of the ritual - they can only change cost and work.

## Level 4 · Diagnostics

Why no `mutating` in Drone: a class method changes the object behind the reference, never the reference itself, so there is nothing to mark.

[Drone] could never hold the sensors: SensorModule is a struct and cannot inherit from a class, but any type can conform to a protocol.

## Level 5 · Shared Behaviour

5.1 · default diagnose() + the single home of the Health Rule

5.2 · the beacon you cannot edit

## Level 6 · Incident Reports

Note: in fact THREE reports don't compile (1, 2, 3) and only one compiles and lies (4).

Report 1
Expected: a PatchDrone that produces 30 work units per task.
Actual: does not compile - "overriding declaration requires an 'override' keyword".
Rule: replacing a superclass method must be marked `override`, so an accidental name clash can't silently replace behaviour.

Report 2
Expected: a welder whose shift always reports 999 units.
Actual: does not compile - "inheritance from a final class 'WelderDrone'" and
"instance method overrides a 'final' instance method".
Rule: a final class can't be subclassed and a final method can't be overridden - that is exactly what protects the ritual.
Fix: a heavy welder is a new Drone that changes cost and work, not the ritual.

Report 3
Expected: call weldSeam() on the first drone of the fleet.
Actual: does not compile - "value of type 'Drone' has no member 'weldSeam'".
Rule: the compiler checks members by the STATIC type (Drone), not by the object that will be there at runtime.
as? returns an optional because the cast can fail: the Drone in the array may turn out to be a scanner.

Report 4
Expected: "thruster T-1".
Actual: compiles and prints "generic component".
Rule: a method that exists only in a protocol extension is dispatched statically by the variable's type.
parts[0] has type Labelled, so Labelled's extension version is called and Thruster's method is never seen.
A method listed in the protocol itself is a requirement and is dispatched dynamically to the real type.
Fix - one line: add the requirement to the protocol.

## Bonus

1a. Runtime guard: the base initializer refuses to build a plain base object.
    Shown on a separate class so the real fleet keeps working; fatalError stops the program, so the call stays commented out.

let guardedBad = GuardedDrone()
    runtime: Fatal error: GuardedDrone is abstract - create a subclass

1b. Compile-time guard: make the base a protocol with a requirement that has no default.
    A protocol can't be instantiated, and a conforming type that forgets performTask() doesn't compile.
    That is the redesign below.

2. Protocol-based redesign: the shared ritual lives in a protocol extension, WelderDrone is a struct.

3. Comparison:
The class design gives a real `final` ritual and one shared object per drone; the protocol design lets structs,
classes and future hardware join the fleet without a common ancestor, but a conformer can shadow runOnce() and
nothing like `final` stops it. For this station I'd keep classes: drones are physical machines with identity whose
batteries are drained by many systems at once. If the drones had to share mutable state, struct drones would copy it
apart - the protocol design only works because PowerCell stayed a class, as the copy above shows.

## Defense Questions

```
 1. Drone satisfies `mutating func recharge(by:)` without `mutating`, SensorModule can't. Why?
    `mutating` means "this method may replace the value stored in the variable".
    For a struct the value IS the data, so changing chargeLevel changes self - the
    keyword is required, and the method can't be called on a `let` sensor.
    For a class, self is a reference; recharge changes the object it points to, never
    the reference itself, so there is nothing to mark and the requirement is met as is.

 2. Inheritance vs protocols:
    Inheritance can do: share stored properties and real code with control over it -
    Drone gives every subclass id, cell, init and a `final` runOnce() nobody can change;
    `super.statusLine` reuses the parent's implementation.
    Protocols can do: unite unrelated types, including structs and types you can't edit -
    one [Diagnosable] array holds class drones, SensorModule structs and LegacyBeacon.
    A type can also conform to many protocols but inherit from only one class.

 3. What does `final` prevent, and what did it protect in runOnce()?
    `final` on a class forbids subclassing; on a method/property it forbids overriding.
    It protected the shift ritual: no drone can skip spending powerCost, ignore a failed
    spend, or report fake work (Report 2's `return 999`). Subclasses change only cost and work.
    Bonus: the compiler can call final methods directly, without dynamic dispatch.

 4. In Report 4, why did the extension's method win over the struct's own method?
    label() wasn't a protocol requirement, only an extension method. Such methods are
    dispatched statically, by the compile-time type of the expression. parts[0] is
    `Labelled`, so the compiler calls Labelled's extension version; Thruster's label()
    merely shadows it and is used only when the static type is Thruster.
    Requirements go through the protocol witness table and are dispatched to the real
    type at runtime - adding `func label() -> String` to the protocol fixes it.
```
