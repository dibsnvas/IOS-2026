func fields(_ line: String, separatedBy separator: Character = ":") -> [String] {
    var result: [String] = []
    var current = ""
    for character in line {
        if character == separator {
            result.append(current)
            current = ""
        } else {
            current.append(character)
        }
    }
    result.append(current)
    return result
}

let rawManifest = [
    "crate:101:120",
    "container:KZ-ALM-7:340",
    "livestock:lab mice:12:2",
    "???-corrupted-line",
    "crate:102:75",
    "container:KZ-ALM-9:410",
    "livestock:ficus:3:5",
    "crate:103:260",
    "crate:104:abc",
    ""
]

let deckReadings: [(deck: String, oxygen: Int)] = [
    (deck: "bridge",     oxygen: 78),
    (deck: "lab",        oxygen: 64),
    (deck: "greenhouse", oxygen: 55),
    (deck: "cargo",      oxygen: 12),
    (deck: "medbay",     oxygen: 90),
    (deck: "engine",     oxygen: 41)
]

let crewData: [(name: String, deck: String, oxygen: Int)] = [
    (name: "Timur",   deck: "engine", oxygen: 62),
    (name: "Dana",    deck: "lab",    oxygen: 48),
    (name: "Aigerim", deck: "bridge", oxygen: 91),
    (name: "Nurlan",  deck: "cargo",  oxygen: 17)
]

print("ALMA-7 recorder online: \(rawManifest.count) manifest lines, \(deckReadings.count) readings, \(crewData.count) crew records.")

enum Deck: String, CaseIterable {
    case bridge, lab, cargo, medbay, engine

    var evacuationPriority: Int {
        switch self {
        case .bridge: return 1
        case .medbay: return 2
        case .lab:    return 3
        case .engine: return 4
        case .cargo:  return 5
        }
    }
}

print("\n--- 1.1 Deck ---")
for deck in Deck.allCases {
    print("\(deck.rawValue): evacuation priority \(deck.evacuationPriority)")
}
print("Deck(rawValue: \"greenhouse\") = \(Deck(rawValue: "greenhouse") as Any)")

enum AlarmLevel: Int {
    case green = 0
    case yellow, orange, red

    static func level(forTotalMass mass: Int) -> AlarmLevel {
        let steps = min(max(mass, 0) / 500, AlarmLevel.red.rawValue)
        return AlarmLevel(rawValue: steps) ?? .red
    }
}

print("\n--- 1.2 AlarmLevel ---")
print("raw values: \(AlarmLevel.green.rawValue) \(AlarmLevel.yellow.rawValue) \(AlarmLevel.orange.rawValue) \(AlarmLevel.red.rawValue)")
print("0 kg    → \(AlarmLevel.level(forTotalMass: 0))")
print("940 kg  → \(AlarmLevel.level(forTotalMass: 940))")
print("1499 kg → \(AlarmLevel.level(forTotalMass: 1499))")
print("4000 kg → \(AlarmLevel.level(forTotalMass: 4000))")

enum ManifestEntry {
    case crate(id: Int, massKg: Int)
    case container(code: String, massKg: Int)
    case livestock(species: String, count: Int, massPerUnitKg: Int)
    case unknown(raw: String)
}

func parseEntry(_ line: String) -> ManifestEntry {
    let parts = fields(line)
    switch (parts[0], parts.count) {
    case ("crate", 3):
        guard let id = Int(parts[1]), let massKg = Int(parts[2]) else { return .unknown(raw: line) }
        return .crate(id: id, massKg: massKg)
    case ("container", 3):
        guard parts[1].isEmpty == false, let massKg = Int(parts[2]) else { return .unknown(raw: line) }
        return .container(code: parts[1], massKg: massKg)
    case ("livestock", 4):
        guard parts[1].isEmpty == false,
              let count = Int(parts[2]),
              let massPerUnitKg = Int(parts[3])
        else { return .unknown(raw: line) }
        return .livestock(species: parts[1], count: count, massPerUnitKg: massPerUnitKg)
    default:
        return .unknown(raw: line)
    }
}

print("\n--- 2.2 parseEntry ---")
print(parseEntry("crate:101:120"))
print(parseEntry("container:KZ-ALM-7:340"))
print(parseEntry("livestock:lab mice:12:2"))
print(parseEntry("crate:104:abc"))
print(parseEntry("crate:1:2:3"))

func mass(of entry: ManifestEntry) -> Int {
    switch entry {
    case .crate(_, let massKg):
        return massKg
    case .container(_, let massKg):
        return massKg
    case .livestock(_, let count, let massPerUnitKg):
        return count * massPerUnitKg
    case .unknown:
        return 0
    }
}

print("\n--- 2.3 mass ---")
var manifest: [ManifestEntry] = []
var totalMass = 0
var unknownCount = 0
for line in rawManifest {
    let entry = parseEntry(line)
    manifest.append(entry)
    totalMass += mass(of: entry)
    if case .unknown = entry {
        unknownCount += 1
    }
}
print("mass(of: livestock ficus) = \(mass(of: parseEntry("livestock:ficus:3:5")))")
print("Parsed \(manifest.count) lines: total mass \(totalMass) kg, unknown lines: \(unknownCount)")

let A = totalMass
print("Fragment A = \(A)")

struct CrewSnapshot {
    let name: String
    var deck: Deck
    var oxygen: Int

    mutating func breathe(_ amount: Int) {
        oxygen = max(0, oxygen - amount)
    }

    mutating func move(to deck: Deck) {
        self.deck = deck
    }

    mutating func reviveInMedbay() {
        self = CrewSnapshot(name: name, deck: .medbay, oxygen: 100)
    }

    static func rookie(named name: String) -> CrewSnapshot {
        CrewSnapshot(name: name, deck: .bridge, oxygen: 100)
    }
}

print("\n--- 3.1 CrewSnapshot ---")
var rookie = CrewSnapshot.rookie(named: "Aru")
print("Rookie:        \(rookie)")
rookie.breathe(130)
print("breathe(130):  \(rookie)")
rookie.move(to: .cargo)
print("move(to:):     \(rookie)")
rookie.reviveInMedbay()
print("revive:        \(rookie)")

func buildRoster(from records: [(name: String, deck: String, oxygen: Int)]) -> [CrewSnapshot] {
    var result: [CrewSnapshot] = []
    for record in records {
        guard let deck = Deck(rawValue: record.deck) else {
            print("Warning: \(record.name) is on unknown deck \"\(record.deck)\", skipped")
            continue
        }
        result.append(CrewSnapshot(name: record.name, deck: deck, oxygen: record.oxygen))
    }
    return result
}

print("\n--- 3.2 Roster ---")
let crewRoster: [CrewSnapshot] = buildRoster(from: crewData)
for member in crewRoster {
    print(member)
}
print("Test with a bad deck: \(buildRoster(from: [(name: "Ghost", deck: "greenhouse", oxygen: 50)]).count) members")

func drainedCopy(of snapshot: CrewSnapshot) -> CrewSnapshot {
    var local = snapshot
    local.breathe(30)
    print("   inside plain function: \(local.oxygen)")
    return local
}

func drain(_ snapshot: inout CrewSnapshot) {
    snapshot.breathe(30)
    print("   inside inout function: \(snapshot.oxygen)")
}

print("\n--- 3.3 Value semantics ---")
var original = CrewSnapshot.rookie(named: "Dana")

print("1) Copy")
var copy = original
print("   before: original \(original.oxygen), copy \(copy.oxygen)")
copy.breathe(50)
print("   after:  original \(original.oxygen), copy \(copy.oxygen)")

print("2) Plain parameter")
print("   before: original \(original.oxygen)")
_ = drainedCopy(of: original)
print("   after:  original \(original.oxygen)")

print("3) inout parameter")
print("   before: original \(original.oxygen)")
drain(&original)
print("   after:  original \(original.oxygen)")

final class TeleportPod {
    let id: String
    var chargeLevel: Int
    var occupant: CrewSnapshot?

    init(id: String, chargeLevel: Int) {
        self.id = id
        self.chargeLevel = chargeLevel
        self.occupant = nil
    }

    deinit {
        print("   [deinit] pod \(id) destroyed")
    }

    func load(_ crew: CrewSnapshot) -> Bool {
        guard occupant == nil, chargeLevel >= 20 else { return false }
        occupant = crew
        return true
    }

    func fire() -> CrewSnapshot? {
        guard let passenger = occupant else { return nil }
        chargeLevel -= 20
        occupant = nil
        return passenger
    }
}

func member(named name: String, in roster: [CrewSnapshot]) -> CrewSnapshot? {
    for member in roster {
        if member.name == name {
            return member
        }
    }
    return nil
}

print("\n--- 4.2 Charge ledger ---")
let pod1 = TeleportPod(id: "P-1", chargeLevel: 100)
print("Start: charge \(pod1.chargeLevel)")
for name in ["Timur", "Dana", "Nurlan"] {
    guard let passenger = member(named: name, in: crewRoster) else {
        print("\(name) not in roster")
        continue
    }
    let loaded = pod1.load(passenger)
    let arrived = pod1.fire()
    print("Load \(name): \(loaded), fired: \(arrived?.name ?? "nobody") → charge \(pod1.chargeLevel)")
}
let emptyShot = pod1.fire()
print("Empty fire: \(emptyShot?.name ?? "nobody") → charge \(pod1.chargeLevel)")

let C = pod1.chargeLevel
print("Fragment C = \(C)")

print("\n--- 4.3 Reference vs value ---")
let podAlias = pod1
print("before: pod1 \(pod1.chargeLevel), podAlias \(podAlias.chargeLevel)")
podAlias.chargeLevel = 5
print("after podAlias.chargeLevel = 5: pod1 \(pod1.chargeLevel), podAlias \(podAlias.chargeLevel)")

var snapA = CrewSnapshot.rookie(named: "Timur")
var snapB = snapA
print("before: snapA \(snapA.oxygen), snapB \(snapB.oxygen)")
snapB.oxygen = 5
print("after snapB.oxygen = 5: snapA \(snapA.oxygen), snapB \(snapB.oxygen)")

final class Station {
    let callSign: String
    var oxygenByDeck: [Deck: Int]

    var hullIntegrity: Int {
        willSet {
            print("   hull: \(hullIntegrity) → \(newValue)")
        }
        didSet {
            hullIntegrity = min(max(hullIntegrity, 0), 100)
        }
    }

    lazy var fullDiagnostics: String = {
        print("   Running full scan...")
        var report = "\(callSign) diagnostics: hull \(hullIntegrity)%"
        for deck in Deck.allCases {
            report += ", \(deck.rawValue) \(oxygenByDeck[deck] ?? 0)%"
        }
        return report
    }()

    var totalOxygen: Int {
        var sum = 0
        for oxygen in oxygenByDeck.values {
            sum += oxygen
        }
        return sum
    }

    var averageOxygen: Int {
        get {
            guard oxygenByDeck.isEmpty == false else { return 0 }
            return totalOxygen / oxygenByDeck.count
        }
        set {
            for deck in oxygenByDeck.keys {
                oxygenByDeck[deck] = newValue
            }
        }
    }

    init(callSign: String, readings: [(deck: String, oxygen: Int)], hullIntegrity: Int = 100) {
        self.callSign = callSign
        self.hullIntegrity = hullIntegrity
        var byDeck: [Deck: Int] = [:]
        for reading in readings {
            guard let deck = Deck(rawValue: reading.deck) else {
                print("   skipping reading for unknown deck \"\(reading.deck)\"")
                continue
            }
            byDeck[deck] = reading.oxygen
        }
        self.oxygenByDeck = byDeck
    }
}

print("\n--- 5.1 Station ---")
let station = Station(callSign: "ALMA-7", readings: deckReadings)
print("Decks registered: \(station.oxygenByDeck.count), total oxygen: \(station.totalOxygen)")

let B = station.averageOxygen
print("Fragment B = \(B)")

let backupStation = Station(callSign: "ALMA-7-B", readings: deckReadings)
print("backupStation created, fullDiagnostics never touched → no scan above or below")

print("Before first access to fullDiagnostics")
print(station.fullDiagnostics)
print("Second access:")
print(station.fullDiagnostics)

backupStation.averageOxygen = 70
print("backupStation.averageOxygen = 70 → \(backupStation.oxygenByDeck[.cargo] ?? 0)% on cargo, total \(backupStation.totalOxygen)")
print("station untouched: average \(station.averageOxygen)")

print("\n--- 5.2 Clamp trap ---")
station.hullIntegrity = 130
print("hull = \(station.hullIntegrity)")
station.hullIntegrity = -40
print("hull = \(station.hullIntegrity)")
station.hullIntegrity = 55
print("hull = \(station.hullIntegrity)")

print("\n--- Level 6 · Incident Reports ---")

do {
    var roster = crewRoster
    for index in roster.indices {
        roster[index].breathe(10)
    }
    print("Report 1 fixed: \(roster[0].name) \(crewRoster[0].oxygen) → \(roster[0].oxygen)")
}

do {
    let podA = TeleportPod(id: "A", chargeLevel: 100)
    let podB = TeleportPod(id: "B", chargeLevel: podA.chargeLevel)
    podB.chargeLevel = 0
    print("Report 2 fixed: podA \(podA.chargeLevel), podB \(podB.chargeLevel)")
}

struct Logbook {
    var entries: [String] = []
    mutating func add(_ entry: String) {
        entries.append(entry)
    }
}

var logbook = Logbook()
logbook.add("Day 10: teleporter incident")
logbook.add("Day 11: manifest rebuilt")
print("Report 3 fixed: \(logbook.entries.count) entries → \(logbook.entries)")

do {
    var snapshot = CrewSnapshot.rookie(named: "Dana")
    snapshot.oxygen = 40
    let pod = TeleportPod(id: "B", chargeLevel: 50)
    pod.chargeLevel = 10
    print("Report 4 fixed: snapshot.oxygen \(snapshot.oxygen), pod.chargeLevel \(pod.chargeLevel)")
}

final class FlightRecorder {

    private var entries: [String] = []

    private(set) var isSealed = false

    internal var entryCount: Int {
        entries.count
    }

    internal var transcript: String {
        var text = ""
        for index in entries.indices {
            text += "#\(index + 1) \(entries[index])\n"
        }
        return text + (isSealed ? "[SEALED]" : "[OPEN]")
    }

    @discardableResult
    internal func add(_ entry: String) -> Bool {
        guard isSealed == false else { return false }
        entries.append(entry)
        return true
    }

    internal func seal() {
        isSealed = true
    }

    fileprivate func rawEntries() -> [String] {
        entries
    }
}

func auditTranscript(of recorder: FlightRecorder) -> String {
    var characters = 0
    for entry in recorder.rawEntries() {
        characters += entry.count
    }
    return "Audit: \(recorder.entryCount) entries, \(characters) characters, sealed: \(recorder.isSealed)"
}

print("\n--- Level 7 · Black Box ---")
let recorder = FlightRecorder()
recorder.add("03:14 teleporter fired")
recorder.add("03:15 crew count mismatch")
print("Entries: \(recorder.entryCount)")
recorder.seal()
print("add after seal accepted: \(recorder.add("03:16 nothing happened"))")
print(recorder.transcript)
print(auditTranscript(of: recorder))

print("\n--- Finale ---")
let D = AlarmLevel.level(forTotalMass: A).rawValue
let integrityCode = "\(A)-\(B)-\(C)-\(D)"
print("INTEGRITY CODE: \(integrityCode)")

extension CrewSnapshot: Equatable {}

func relation(_ first: TeleportPod, _ second: TeleportPod) -> String {
    if first === second {
        return "the same pod"
    }
    if first.id == second.id && first.chargeLevel == second.chargeLevel && first.occupant == second.occupant {
        return "two different pods with equal contents"
    }
    return "two different pods"
}

print("\n--- Bonus ---")
var survivor: TeleportPod?
print("1. before do block")
do {
    let temporary = TeleportPod(id: "TEMP", chargeLevel: 30)
    survivor = temporary
    print("2. inside do block: 2 references")
}
print("3. after do block: pod alive, survivor holds \(survivor?.id ?? "nothing")")
survivor = nil
print("4. after survivor = nil")

let record1 = TeleportPod(id: "P-9", chargeLevel: 60)
let record2 = record1
let record3 = TeleportPod(id: "P-9", chargeLevel: 60)
print("record1 vs record2: \(relation(record1, record2))")
print("record1 vs record3: \(relation(record1, record3))")
print("record1 vs pod1: \(relation(record1, pod1))")
