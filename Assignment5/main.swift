let fleetData: [(kind: String, id: String, charge: Int)] = [
    (kind: "welder",  id: "W-1", charge: 80),
    (kind: "scanner", id: "S-1", charge: 45),
    (kind: "cargo",   id: "C-1", charge: 100),
    (kind: "welder",  id: "W-2", charge: 15),
    (kind: "scanner", id: "S-2", charge: 60),
    (kind: "tug",     id: "T-1", charge: 50)
]

let sensorData: [(id: String, charge: Int)] = [
    (id: "hull-cam", charge: 12),
    (id: "thermal",  charge: 77)
]

struct LegacyBeacon {
    let name: String
    let signalStrength: Int
}

let beacon = LegacyBeacon(name: "ALMA-BEACON", signalStrength: 8)

print("Fleet registry online: \(fleetData.count) drone records, \(sensorData.count) sensors, beacon \(beacon.name).")

extension Int {
    func clamped(to range: ClosedRange<Int>) -> Int {
        Swift.min(Swift.max(self, range.lowerBound), range.upperBound)
    }

    func recharged(by amount: Int) -> Int {
        guard amount > 0 else { return self }
        return (self + amount).clamped(to: 0...100)
    }
}

final class PowerCell {
    private var charge: Int

    init(charge: Int) {
        self.charge = charge.clamped(to: 0...100)
    }

    func level() -> Int {
        charge
    }

    func canSpend(_ amount: Int) -> Bool {
        amount > 0 && amount <= charge
    }

    func spend(_ amount: Int) -> Bool {
        guard canSpend(amount) else { return false }
        charge -= amount
        return true
    }

    func recharge(by amount: Int) {
        charge = charge.recharged(by: amount)
    }
}

print("\n--- Level 1 · PowerCell ---")
let cell = PowerCell(charge: 150)
print("init(charge: 150) → \(cell.level())")
print("spend(30): \(cell.spend(30)) → \(cell.level())")
print("spend(0): \(cell.spend(0)), spend(-5): \(cell.spend(-5)), spend(500): \(cell.spend(500)) → \(cell.level())")
cell.recharge(by: 50)
print("recharge(by: 50) → \(cell.level())")
cell.recharge(by: -20)
print("recharge(by: -20) → \(cell.level())")
print("PowerCell(charge: -40) → \(PowerCell(charge: -40).level())")

class Drone {
    let id: String
    let cell: PowerCell

    init(id: String, cell: PowerCell) {
        self.id = id
        self.cell = cell
    }

    var powerCost: Int { 10 }

    var statusLine: String {
        "\(id): \(cell.level())% \(cell.level().powerBar)"
    }

    var canRunTask: Bool {
        cell.canSpend(powerCost)
    }

    func performTask() -> Int { 0 }

    final func runOnce() -> Int {
        guard cell.spend(powerCost) else { return 0 }
        return performTask()
    }
}

final class WelderDrone: Drone {
    override var powerCost: Int { 25 }
    override func performTask() -> Int { 40 }

    func weldSeam() -> String {
        "\(id) welded a seam"
    }
}

class ScannerDrone: Drone {
    override var powerCost: Int { 10 }
    override func performTask() -> Int { 15 }

    override var statusLine: String {
        super.statusLine + " [scanner]"
    }
}

final class CargoDrone: Drone {
    override var powerCost: Int { 20 }
    override func performTask() -> Int { 25 }
}

func makeDrone(kind: String, id: String, charge: Int) -> Drone? {
    let cell = PowerCell(charge: charge)
    switch kind {
    case "welder":  return WelderDrone(id: id, cell: cell)
    case "scanner": return ScannerDrone(id: id, cell: cell)
    case "cargo":   return CargoDrone(id: id, cell: cell)
    default:        return nil
    }
}

print("\n--- Level 2 · Fleet ---")
var fleetBuilder: [Drone] = []
for record in fleetData {
    guard let drone = makeDrone(kind: record.kind, id: record.id, charge: record.charge) else {
        print("Warning: unknown drone kind \"\(record.kind)\" for \(record.id), skipped")
        continue
    }
    fleetBuilder.append(drone)
}
let fleet: [Drone] = fleetBuilder
for drone in fleet {
    print("\(drone.statusLine) — cost \(drone.powerCost), work \(drone.performTask())")
}
print("makeDrone(kind: \"tug\") = \(makeDrone(kind: "tug", id: "X", charge: 1) as Any)")

func runShift(_ fleet: [Drone], rounds: Int) -> Int {
    var total = 0
    for _ in 0..<max(rounds, 0) {
        for drone in fleet {
            total += drone.runOnce()
        }
    }
    return total
}

print("\n--- Level 3 · Shift ---")
let A = runShift(fleet, rounds: 3)
var remainingCharge = 0
var readyDrones = 0
for drone in fleet {
    print(drone.statusLine)
    remainingCharge += drone.cell.level()
    if drone.canRunTask {
        readyDrones += 1
    }
}
let B = remainingCharge
let C = readyDrones
print("Work units: \(A), remaining charge: \(B), drones ready for one more task: \(C)")

protocol Diagnosable {
    var componentID: String { get }
    var statusCode: Int { get }
    func diagnose() -> String
}

protocol Rechargeable {
    mutating func recharge(by amount: Int)
}

extension Drone: Diagnosable, Rechargeable {
    var componentID: String { id }
    var statusCode: Int { healthCode(for: cell.level()) }

    func recharge(by amount: Int) {
        cell.recharge(by: amount)
    }
}

struct SensorModule: Diagnosable, Rechargeable {
    let id: String
    var chargeLevel: Int

    var componentID: String { id }
    var statusCode: Int { healthCode(for: chargeLevel) }

    mutating func recharge(by amount: Int) {
        chargeLevel = chargeLevel.recharged(by: amount)
    }
}

var sensors: [SensorModule] = []
for record in sensorData {
    sensors.append(SensorModule(id: record.id, chargeLevel: record.charge))
}

print("\n--- Level 4 · Rechargeable ---")
var testSensor = SensorModule(id: "test", chargeLevel: 90)
testSensor.recharge(by: 30)
print("SensorModule 90 + 30 → \(testSensor.chargeLevel)")
let testDrone = CargoDrone(id: "C-9", cell: PowerCell(charge: 10))
testDrone.recharge(by: 25)
print("CargoDrone 10 + 25 → \(testDrone.cell.level())")

func diagnosticsReport(_ components: [Diagnosable]) -> String {
    var report = "=== DIAGNOSTICS: \(components.count) components ===\n"
    var critical = 0
    for component in components {
        report += component.diagnose() + "\n"
        if component.statusCode == 2 {
            critical += 1
        }
    }
    return report + "critical: \(critical)"
}

print("\n--- Level 4 · Diagnostics ---")
var components: [Diagnosable] = []
for drone in fleet {
    components.append(drone)
}
for sensor in sensors {
    components.append(sensor)
}
print(diagnosticsReport(components))

extension Diagnosable {
    func diagnose() -> String {
        "\(componentID): code \(statusCode)"
    }

    func healthCode(for level: Int) -> Int {
        switch level {
        case ..<20: return 2
        case 20..<50: return 1
        default: return 0
        }
    }
}

extension LegacyBeacon: Diagnosable {
    var componentID: String { name }
    var statusCode: Int { healthCode(for: signalStrength) }

    func diagnose() -> String {
        "*** LEGACY HARDWARE *** \(name): signal \(signalStrength), code \(statusCode) — manual inspection required"
    }
}

print("\n--- Level 5 · Diagnostics with beacon ---")
components.append(beacon)
print(diagnosticsReport(components))

var statusSum = 0
for component in components {
    statusSum += component.statusCode
}
let D = statusSum
print("Sum of status codes: \(D)")

extension Int {
    var powerBar: String {
        let filled = (self / 10).clamped(to: 0...10)
        var bar = ""
        for position in 0..<10 {
            bar += position < filled ? "#" : "."
        }
        return bar
    }
}

print("\n--- Level 5.3 · powerBar ---")
print("42 → \(42.powerBar)")
print("100 → \(100.powerBar)")
print("-5 → \((-5).powerBar)")
print("250 → \(250.powerBar)")

print("\n--- Level 6 · Incident Reports ---")

class PatchDrone: Drone {
    override func performTask() -> Int {
        return 30
    }
}

let patch = PatchDrone(id: "P-1", cell: PowerCell(charge: 50))
print("Report 1 fixed: \(patch.id) runOnce → \(patch.runOnce()), \(patch.statusLine)")

final class HeavyWelder: Drone {
    override var powerCost: Int { 40 }
    override func performTask() -> Int { 90 }
}

let heavy = HeavyWelder(id: "H-1", cell: PowerCell(charge: 50))
print("Report 2 fixed: \(heavy.id) runOnce → \(heavy.runOnce()), then \(heavy.runOnce()) (out of charge)")

let reportFleet: [Drone] = [WelderDrone(id: "W-9", cell: PowerCell(charge: 100))]
let first = reportFleet[0]
if let welder = first as? WelderDrone {
    print("Report 3 fixed: \(welder.weldSeam())")
}
if let notWelder = fleet[1] as? WelderDrone {
    print("unexpected: \(notWelder.id)")
} else {
    print("Report 3 check: \(fleet[1].id) as? WelderDrone → nil")
}

protocol Labelled {
    var componentID: String { get }
    func label() -> String
}

extension Labelled {
    func label() -> String { "generic component" }
}

struct Thruster: Labelled {
    let componentID: String
    func label() -> String { "thruster \(componentID)" }
}

struct Antenna: Labelled {
    let componentID: String
}

let parts: [Labelled] = [Thruster(componentID: "T-1"), Antenna(componentID: "A-1")]
for part in parts {
    print("Report 4 fixed: \(part.label())")
}

print("\n--- Finale ---")
let missionCode = "\(A)-\(B)-\(C)-\(D)"
print("MISSION CODE: \(missionCode)")

class GuardedDrone {
    init() {
        if type(of: self) == GuardedDrone.self {
            fatalError("GuardedDrone is abstract — create a subclass")
        }
    }
}

final class GuardedWelder: GuardedDrone {}

let guardedOK = GuardedWelder()
print("\n--- Bonus ---")
print("GuardedWelder created: \(type(of: guardedOK))")

enum Redesign {
    protocol RepairDrone: Diagnosable {
        var id: String { get }
        var cell: PowerCell { get }
        var powerCost: Int { get }
        func performTask() -> Int
    }

    struct WelderDrone: RepairDrone {
        let id: String
        let cell: PowerCell
        var powerCost: Int { 25 }
        func performTask() -> Int { 40 }
    }

    struct ScannerDrone: RepairDrone {
        let id: String
        let cell: PowerCell
        var powerCost: Int { 10 }
        func performTask() -> Int { 15 }
    }
}

extension Redesign.RepairDrone {
    var componentID: String { id }
    var statusCode: Int { healthCode(for: cell.level()) }

    func runOnce() -> Int {
        guard cell.spend(powerCost) else { return 0 }
        return performTask()
    }
}

let redesignFleet: [any Redesign.RepairDrone] = [
    Redesign.WelderDrone(id: "RW-1", cell: PowerCell(charge: 60)),
    Redesign.ScannerDrone(id: "RS-1", cell: PowerCell(charge: 30))
]
var redesignWork = 0
for drone in redesignFleet {
    redesignWork += drone.runOnce()
}
print("Redesign fleet work: \(redesignWork)")
for drone in redesignFleet {
    print(drone.diagnose())
}

let welderCopy = redesignFleet[0]
print("A struct copy still shares the class PowerCell: original \(redesignFleet[0].cell.level())%, copy \(welderCopy.cell.level())%")
