# ALMA-7: written answers

## Level 5 · Saboteur's Logbook

Problems found:

reportOxygen
 1. `member.module!` — Nurlan has module == nil (open space) → runtime crash
    "Unexpectedly found nil while unwrapping an Optional value".
 2. `.oxygenTank!` — Dana is in Dock, which has no tank → the same crash.
    So the report crashes for 2 of 4 crew members, i.e. exactly when it's needed.

firstCritical
 3. `oxygenLevel(of: member)!` — crashes on the first member without data.
    Crew order is Timur, Dana, … → crashes on Dana before even reaching Aigerim.
 4. LOGIC BUG: the loop never stops, so every later match overwrites `result`.
    The function returns the LAST critical member, not the first. With the starter
    data only Aigerim is critical, so the bug is invisible.
 5. `return result!` — if nobody is critical, `result` stays nil → crash.
    E.g. an empty crew, or a crew where everyone is at 20% or more.
 6. The return type `String` cannot express "nobody is critical" at all —
    that's what forced the author to use `!`. It must be `String?`.

## Defense Questions

```
 1. guard let vs if let beyond syntax:
    - The value bound by `guard let` lives in the rest of the enclosing scope;
      the value bound by `if let` lives only inside the braces.
    - The `else` of `guard` MUST leave the scope (return / continue / break / throw).
      The compiler checks it, so after the guard the value is guaranteed to exist.
    - Guard = "early exit": failures handled at the top, the happy path stays flat.
    Example — parseReading with if let turns into a pyramid, and the return
    of the result is buried 4 levels deep:
        if let parts = splitOnce(raw, by: ":") {
            if parts.0.isEmpty == false {
                if let value = Int(parts.1) {
                    if value >= 0 || parts.0 == "TEMP" {
                        return (parts.0, value)
                    }
                }
            }
        }
        return nil

 2. Why can't you pass [Int] to stats(_ values: Int...)?
    `Int...` is a parameter that accepts separate Int arguments: stats(3, 8, 1).
    It becomes [Int] only INSIDE the function. At the call site the compiler
    expects Int values, not an array, and Swift has no "spread" operator to unpack
    an array into variadic arguments. That's exactly why stats(_:) calls
    stats(of:) with the array rather than the other way round.

 3. Why doesn't transferOxygen(from: &x, to: &x, amount: 5) compile?
    Law of Exclusivity: two inout parameters would get simultaneous write access
    to the same variable ("overlapping accesses to 'x'").
    Bug it prevents: the function assumes source and target are DIFFERENT tanks.
    With x = 98: free space = 100 - 98 = 2, it "moves" 2, then source -= 2 and
    target += 2 hit the same memory. inout works as copy-in / copy-out, so the result
    depends on which copy is written back last — 96 or 100. Oxygen would be
    created or destroyed out of nothing.

 4. Why doesn't oxygenLevel(of: dana) ?? "no data" compile?
    `??` requires the default value to be of the same type as the value inside the
    Optional: Int? ?? Int -> Int. Here it's Int? ?? String — the expression would have
    no single type. Fix: make both sides the same type, e.g. in status(of:)
    we unwrap with guard let and build a String in each branch.

 5. Full type of chooseProtocol and how to read it:
        (Int) -> (Int) -> Int
    The arrow is right-associative, so it means (Int) -> ((Int) -> Int):
    "a function that takes an Int (the current temperature) and returns
    a function that takes an Int and returns an Int (the protocol to apply)".
    The `for` label is not part of the type. That's why the call is
    chooseProtocol(for: 30)(30): the first call returns a function, the second applies it.

 Bonus. Where does the alarm counter live after makeAlarm returns?
    `firedCount` is a local variable, but the returned closure captures it
    (by reference). Because the closure outlives the function, Swift moves the variable
    out of the stack into a heap-allocated box. The closure holds a strong
    reference to that box, so the counter lives as long as the closure (`alarm`)
    lives. Every makeAlarm call creates a new box — hence `otherAlarm` has its own
    counter that starts from 1.
```
