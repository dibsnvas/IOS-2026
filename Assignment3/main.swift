typealias Reading = (sensor: String, value: Int)

func splitOnce(_ line: String, by separator: Character) -> (String, String)? {
    guard let index = line.firstIndex(of: separator) else { return nil }
    let left = String(line[..<index])
    let right = String(line[line.index(after: index)...])
    return (left, right)
}

let rawLog = [
    "O2:87", "TEMP:-12", "O2:9x", "PRESS:101", "TEMP:abc", "O2:",
    "RAD:3", "O2:64", ":55", "TEMP:31", "PRESS:98", "O2:71",
    "RAD:-1", "TEMP:4", "PRESS:1o2", "O2:90"
]

class Tank {
    var level: Int
    init(level: Int) { self.level = level }
}

class Module {
    let name: String
    var oxygenTank: Tank?
    init(name: String, oxygenTank: Tank?) {
        self.name = name
        self.oxygenTank = oxygenTank
    }
}

class CrewMember {
    let name: String
    let role: String
    let priority: Int
    var module: Module?
    init(name: String, role: String, priority: Int, module: Module?) {
        self.name = name
        self.role = role
        self.priority = priority
        self.module = module
    }
}

let lab  = Module(name: "Lab",  oxygenTank: Tank(level: 40))
let hab  = Module(name: "Hab",  oxygenTank: Tank(level: 12))
let dock = Module(name: "Dock", oxygenTank: nil)

let crew = [
    CrewMember(name: "Timur",   role: "Engineer",  priority: 3, module: lab),
    CrewMember(name: "Dana",    role: "Scientist", priority: 4, module: dock),
    CrewMember(name: "Aigerim", role: "Commander", priority: 1, module: hab),
    CrewMember(name: "Nurlan",  role: "Pilot",     priority: 2, module: nil)
]

var roster: [String: CrewMember] = [:]
for member in crew { roster[member.name] = member }

print("ALMA-7 systems online: \(rawLog.count) log lines, \(crew.count) crew members.")

func parseReading(_ raw: String) -> Reading? {
    guard let parts = splitOnce(raw, by: ":"),
          parts.0.isEmpty == false,
          let value = Int(parts.1),
          value >= 0 || parts.0 == "TEMP"
    else { return nil }
    return (sensor: parts.0, value: value)
}

print("\n--- 1.1 parseReading ---")
print(parseReading("O2:87") as Any)
print(parseReading("TEMP:-12") as Any)
print(parseReading("RAD:-1") as Any)
print(parseReading(":55") as Any)
print(parseReading("PRESS:1o2") as Any)

func parseLog(_ lines: [String]) -> (valid: [Reading], invalidCount: Int) {
    var valid: [Reading] = []
    var invalidCount = 0
    for line in lines {
        if let reading = parseReading(line) {
            valid.append(reading)
        } else {
            invalidCount += 1
        }
    }
    return (valid, invalidCount)
}

print("\n--- 1.2 parseLog ---")
let telemetry = parseLog(rawLog)
print("Valid: \(telemetry.valid.count), corrupted: \(telemetry.invalidCount)")
print(parseLog(["O2:1", "bad", "TEMP:-5", ""]))

let A = telemetry.invalidCount
print("Fragment A = \(A)")

func select(_ readings: [Reading], where isIncluded: (Reading) -> Bool) -> [Reading] {
    var result: [Reading] = []
    for reading in readings {
        if isIncluded(reading) {
            result.append(reading)
        }
    }
    return result
}

func values(of readings: [Reading]) -> [Int] {
    var result: [Int] = []
    for reading in readings {
        result.append(reading.value)
    }
    return result
}

print("\n--- 2.1 select / values ---")
let o2Readings = select(telemetry.valid) { $0.sensor == "O2" }
print("O2 readings:", o2Readings)
print("O2 values:", values(of: o2Readings))
let tempReadings = select(telemetry.valid) { $0.sensor == "TEMP" }
print("TEMP values:", values(of: tempReadings))
print("Values >= 90:", values(of: select(telemetry.valid) { $0.value >= 90 }))

func stats(of values: [Int]) -> (min: Int, max: Int, average: Double)? {
    guard let first = values.first else { return nil }
    var minValue = first
    var maxValue = first
    var sum = 0
    for value in values {
        if value < minValue { minValue = value }
        if value > maxValue { maxValue = value }
        sum += value
    }
    return (minValue, maxValue, Double(sum) / Double(values.count))
}

func stats(_ values: Int...) -> (min: Int, max: Int, average: Double)? {
    stats(of: values)
}

print("\n--- 2.2 stats ---")
print(stats(3, 8, 1) as Any)
print(stats() as Any)
print(stats(of: []) as Any)
print(stats(of: values(of: o2Readings)) as Any)

var B: Int?
if let o2Stats = stats(of: values(of: o2Readings)) {
    B = Int(o2Stats.average)
}
print("Fragment B = \(B as Any)")

let valid = telemetry.valid

let ladder1 = valid.sorted(by: { (a: Reading, b: Reading) -> Bool in
    return a.value > b.value
})
let ladder2 = valid.sorted(by: { a, b in return a.value > b.value })
let ladder3 = valid.sorted(by: { a, b in a.value > b.value })
let ladder4 = valid.sorted(by: { $0.value > $1.value })
let ladder5 = valid.sorted { $0.value > $1.value }

func sameReadings(_ lhs: [Reading], _ rhs: [Reading]) -> Bool {
    guard lhs.count == rhs.count else { return false }
    for index in 0..<lhs.count {
        if lhs[index].sensor != rhs[index].sensor || lhs[index].value != rhs[index].value {
            return false
        }
    }
    return true
}

print("\n--- 2.3 Closure Ladder ---")
print("Sorted:", values(of: ladder1))
var ladderMatches = true
for other in [ladder2, ladder3, ladder4, ladder5] {
    if sameReadings(ladder1, other) == false {
        ladderMatches = false
    }
}
print("All five sorts match: \(ladderMatches)")
print("Control check (ascending != descending): \(sameReadings(ladder1, valid.sorted { $0.value < $1.value }))")

let safeRange = 18...24

func heatUp(_ t: Int) -> Int { t + 5 }
func coolDown(_ t: Int) -> Int { t - 3 }
func hold(_ t: Int) -> Int { t }

func chooseProtocol(for temp: Int) -> (Int) -> Int {
    if temp < safeRange.lowerBound {
        return heatUp
    } else if temp > safeRange.upperBound {
        return coolDown
    } else {
        return hold
    }
}

print("\n--- 3.1 Protocols ---")
print("heatUp(10) = \(heatUp(10)), coolDown(30) = \(coolDown(30)), hold(20) = \(hold(20))")
print("chooseProtocol(for: 5)(5) = \(chooseProtocol(for: 5)(5))")
print("chooseProtocol(for: 30)(30) = \(chooseProtocol(for: 30)(30))")
print("chooseProtocol(for: 20)(20) = \(chooseProtocol(for: 20)(20))")

func runUntilStable(from start: Int, maxSteps: Int = 10) -> (finalTemp: Int, steps: Int, isStable: Bool) {
    var temp = start
    var steps = 0
    while safeRange.contains(temp) == false && steps < maxSteps {
        let stabilize = chooseProtocol(for: temp)
        temp = stabilize(temp)
        steps += 1
    }
    return (temp, steps, safeRange.contains(temp))
}

print("\n--- 3.2 runUntilStable ---")
print(runUntilStable(from: 31))
print(runUntilStable(from: -100, maxSteps: 5))
print(runUntilStable(from: 20))

var C: Int?
if let tempStats = stats(of: values(of: tempReadings)) {
    print("Lowest valid temperature: \(tempStats.min)")
    C = runUntilStable(from: tempStats.min).steps
}
print("Fragment C = \(C as Any)")

func oxygenLevel(of member: CrewMember) -> Int? {
    member.module?.oxygenTank?.level
}

print("\n--- 4.1 oxygenLevel ---")
for member in crew {
    print("\(member.name): \(oxygenLevel(of: member) as Any)")
}

func status(of member: CrewMember) -> String {
    guard let level = oxygenLevel(of: member) else {
        return "\(member.name): no data (\(member.module?.name ?? "open space"))"
    }
    return "\(member.name): \(level)% \(level < 20 ? "CRITICAL" : "OK")"
}

print("\n--- 4.2 status ---")
for member in crew {
    print(status(of: member))
}

let tankCapacity = 100

@discardableResult
func transferOxygen(from source: inout Int, to target: inout Int, amount: Int) -> Int {
    guard amount > 0 else { return 0 }
    let freeSpace = max(0, tankCapacity - target)
    let moved = min(amount, max(0, source), freeSpace)
    source -= moved
    target += moved
    return moved
}

print("\n--- 4.3 transferOxygen ---")
var testSource = 50, testTarget = 90
print("Asked 30, moved \(transferOxygen(from: &testSource, to: &testTarget, amount: 30)) → source \(testSource), target \(testTarget)")
testSource = 5; testTarget = 0
print("Asked 30, moved \(transferOxygen(from: &testSource, to: &testTarget, amount: 30)) → source \(testSource), target \(testTarget)")
print("Asked -10, moved \(transferOxygen(from: &testSource, to: &testTarget, amount: -10)) → source \(testSource), target \(testTarget)")

if let labTank = lab.oxygenTank, let habTank = hab.oxygenTank {
    let moved = transferOxygen(from: &labTank.level, to: &habTank.level, amount: 30)
    print("Lab → Hab: moved \(moved). Lab \(labTank.level)%, Hab \(habTank.level)%")
} else {
    print("Transfer aborted: Lab or Hab has no tank")
}

let D = hab.oxygenTank?.level
print("Fragment D = \(D as Any)")

print("Crew after transfer:")
for member in crew {
    print(status(of: member))
}

func evacuationOrder(_ names: String..., roster: [String: CrewMember]) -> [String] {
    var found: [CrewMember] = []
    for name in names {
        guard let member = roster[name] else {
            print("Unknown crew member: \(name)")
            continue
        }
        found.append(member)
    }
    let sorted = found.sorted { $0.priority < $1.priority }
    var result: [String] = []
    for member in sorted {
        result.append(member.name)
    }
    return result
}

print("\n--- 4.4 evacuationOrder ---")
print(evacuationOrder("Dana", "Ghost", "Aigerim", "Timur", roster: roster))
print(evacuationOrder("Nurlan", "Timur", "Nobody", roster: roster))
print(evacuationOrder(roster: roster))

func reportOxygen(for member: CrewMember) -> String {
    guard let level = oxygenLevel(of: member) else {
        return "\(member.name): no data"
    }
    return "\(member.name): \(level)%"
}

func firstCritical(in crew: [CrewMember]) -> String? {
    for member in crew {
        if let level = oxygenLevel(of: member), level < 20 {
            return member.name
        }
    }
    return nil
}

print("\n--- Level 5 · Saboteur ---")
for member in crew {
    print(reportOxygen(for: member))
}
print("First critical (real crew, after transfer): \(firstCritical(in: crew) as Any)")

let testCrew = [
    CrewMember(name: "NoModule", role: "Test", priority: 9, module: nil),
    CrewMember(name: "NoTank",   role: "Test", priority: 9, module: Module(name: "T0", oxygenTank: nil)),
    CrewMember(name: "Alpha",    role: "Test", priority: 9, module: Module(name: "T1", oxygenTank: Tank(level: 5))),
    CrewMember(name: "Healthy",  role: "Test", priority: 9, module: Module(name: "T2", oxygenTank: Tank(level: 80))),
    CrewMember(name: "Bravo",    role: "Test", priority: 9, module: Module(name: "T3", oxygenTank: Tank(level: 15)))
]
let firstFound = firstCritical(in: testCrew)
print("Test: first critical = \(firstFound as Any) → \(firstFound == "Alpha" ? "PASS" : "FAIL (saboteur's code would return Bravo)")")
print("Test: empty crew = \(firstCritical(in: []) as Any) → \(firstCritical(in: []) == nil ? "PASS" : "FAIL")")

print("\n--- Finale ---")
if let B, let C, let D {
    let launchCode = "\(A)-\(B)-\(C)-\(D)"
    print("LAUNCH CODE: \(launchCode)")
} else {
    print("LAUNCH ABORTED: a code fragment could not be computed")
}

func makeAlarm(threshold: Int) -> (Int) -> Bool {
    var firedCount = 0
    return { level in
        guard level < threshold else { return false }
        firedCount += 1
        print("Alarm #\(firedCount)")
        return true
    }
}

print("\n--- Bonus · makeAlarm ---")
let alarm = makeAlarm(threshold: 20)
print(alarm(12))
print(alarm(40))
print(alarm(5))
let otherAlarm = makeAlarm(threshold: 50)
print(otherAlarm(40))
