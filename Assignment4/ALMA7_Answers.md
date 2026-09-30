# ALMA-7 Part II: written answers

## Level 4 · The Teleport Pod

A class, because a pod is one physical object with identity: everyone who holds it must see the same charge.
The struct in Level 3 gets a memberwise init for free; a class gets none, because classes support
inheritance and Swift won't guess how a subclass should initialize its superclass's stored properties.

Rule: assigning a class copies the reference (both names share one object), assigning a struct copies the value.

## Level 5 · Station Systems

A class, because there is exactly one live station that every system reads and writes;
copies of its state would drift apart (exactly the day-ten incident).

The clamp doesn't loop: assigning a property inside its own didSet writes the storage
directly, without calling willSet/didSet again.

## Level 6 · Incident Reports

Note: in fact TWO reports fail to compile (3 and 4), not one.

Report 1
Expected: every crew member loses 10 oxygen.
Actual: compiles, roster is unchanged (Timur stays 62) — only the loop's copies change.
Rule: `for var member in roster` gives a COPY of each struct element (value semantics).

Report 2
Expected: podA keeps 100, podB is an independent pod at 0.
Actual: compiles, prints 0 — podA and podB are two names for ONE pod.
Rule: assigning a class instance copies the reference, not the object.
Fix: create a second object explicitly.

Report 3
Expected: add(_:) appends to entries.
Actual: does not compile — "cannot use mutating member on immutable value: 'self' is immutable".
Rule: in a struct method `self` is immutable unless the method is marked `mutating`.

Report 4
Expected: both assignments work.
Actual: `snapshot.oxygen = 40` does not compile — "cannot assign to property: 'snapshot' is a 'let' constant";
`pod.chargeLevel = 10` compiles fine.
Rule: `let` on a struct freezes the whole value, every property included.
`let` on a class freezes only the reference (pod always points to the same object), not the object's var properties.

## Level 7 · Sealing the Black Box

The leaky original:

```swift
class FlightRecorder {
    var entries: [String] = []
    var isSealed = false
}
```

A class, because the black box is one shared device: every system must write to the same log.

private: blocks replacing, clearing or appending to the list from outside the type

private(set): blocks writing isSealed from outside (it can never be reset to false); reading is allowed

internal: blocks nothing inside this module — the read-only count is part of the public face

internal: blocks nothing inside this module — read-only formatted view of the log

internal: blocks nothing inside this module — the only way in, refuses writes after sealing

internal: blocks nothing inside this module — sealing is one-way, there is no unseal

fileprivate: blocks access from other files; the audit function in this file may read the raw entries

Attempts to break it from outside (they don't compile):
```swift
recorder.entries = []
// error: 'entries' is inaccessible due to 'private' protection level
recorder.isSealed = false
// error: cannot assign to property: 'isSealed' setter is inaccessible
```

## Defense Questions

```
 1. Why did CrewSnapshot get an initializer for free and TeleportPod did not?
    Structs get a memberwise init automatically: CrewSnapshot(name:deck:oxygen:).
    Classes get only init() and only when every stored property has a default.
    TeleportPod's id and chargeLevel have no defaults, and classes can be subclassed,
    so Swift makes you write the init and decide how every property is set.

 2. What does `mutating` do to self, and why do classes never need it?
    It passes self into the method as inout: the method may change properties or
    replace self entirely (self = CrewSnapshot(...)), and the result is written back.
    That's why a mutating method can't be called on a `let` struct.
    A class method gets a reference; it changes the shared object, never the
    reference itself, so there is nothing to mark.

 3. In Report 4 both values are `let`. What exactly does `let` freeze?
    Struct: the whole value — every property, even `var` ones.
        let s = CrewSnapshot.rookie(named: "Dana"); s.oxygen = 40   // error
    Class: only the reference — `pod` always points to the same object,
    but the object's `var` properties can change.
        let pod = TeleportPod(id: "B", chargeLevel: 50); pod.chargeLevel = 10   // ok
        pod = TeleportPod(id: "C", chargeLevel: 0)                              // error

 4. Why must a lazy property be var? When does lazy change behaviour?
    A lazy property has no value after init; it's written on first access.
    `let` must be set during init and never changes — lazy contradicts that.
    Behaviour change: fullDiagnostics runs its closure (and prints "Running full scan...")
    only on first access, and captures the state at THAT moment. If hullIntegrity
    changes before the first access, the report shows the new value; after that
    it stays frozen even if the hull changes again. A non-lazy version would
    always print the scan in init and always show the init-time state.

 5. private vs fileprivate: where would private be too strict?
    auditTranscript(of:) is a free function outside FlightRecorder that needs the raw
    entries. With `private`, rawEntries() would be visible only inside the class,
    and the audit wouldn't compile. `fileprivate` opens it to this file only;
    code in other files still can't reach the raw list.

 Bonus. On which line does deinit fire, and why can't === be used on CrewSnapshot?
    Not at the end of the do block: `temporary` disappears there, but `survivor`
    still holds a strong reference (ref count 1). deinit fires on `survivor = nil`,
    when the reference count drops to 0 — between lines 3 and 4 of the output.
    === compares references (is it the same object in memory?). CrewSnapshot is a
    value type: it has no identity, every assignment makes an independent copy,
    so there is nothing to compare by identity — only by value with ==.
```
