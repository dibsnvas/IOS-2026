// Assignment #2: Working with Collections in Swift
// Без циклов и условных операторов

// MARK: - Easy Tasks

// 1. Array Creation and Access
let fruits = ["Apple", "Banana", "Cherry", "Mango", "Orange"]
print("Easy 1 — Third fruit:", fruits[2])

// 2. Set Creation and Manipulation
var favoriteNumbers: Set<Int> = [3, 7, 13, 21]
favoriteNumbers.insert(42)
print("Easy 2 — Updated set:", favoriteNumbers)

// 3. Dictionary Creation and Access
let languages = ["Swift": 2014, "Python": 1991, "Java": 1995]
print("Easy 3 — Swift release year:", languages["Swift"] ?? 0)

// 4. Array Element Update
var colors = ["Red", "Green", "Blue", "Yellow"]
colors[1] = "Purple"
print("Easy 4 — Updated colors:", colors)

// MARK: - Medium Tasks

// 1. Set Intersection
let setA: Set = [1, 2, 3, 4]
let setB: Set = [3, 4, 5, 6]
print("Medium 1 — Intersection:", setA.intersection(setB))

// 2. Dictionary Update
var studentScores = ["Aliya": 85, "Timur": 90, "Dana": 78]
studentScores.updateValue(95, forKey: "Dana")
print("Medium 2 — Updated scores:", studentScores)

// 3. Array Merge
let firstArray = ["apple", "banana"]
let secondArray = ["cherry", "date"]
let mergedArray = firstArray + secondArray
print("Medium 3 — Merged array:", mergedArray)

// MARK: - Hard Tasks

// 1. Dictionary Key Addition
var countryPopulations = ["Kazakhstan": 20_000_000, "Japan": 124_000_000, "Germany": 84_000_000]
countryPopulations["Canada"] = 40_000_000
print("Hard 1 — Updated countries:", countryPopulations)

// 2. Set Union and Subtract
let animals1: Set = ["cat", "dog"]
let animals2: Set = ["dog", "mouse"]
let unionSet = animals1.union(animals2)
let finalSet = unionSet.subtracting(animals2)
print("Hard 2 — Union:", unionSet, "→ after subtracting:", finalSet)

// 3. Nested Collection
let studentGrades = [
    "Aliya": [90, 85, 92],
    "Timur": [78, 88, 95],
    "Dana": [82, 91, 87]
]
print("Hard 3 — Timur's second grade:", studentGrades["Timur"]?[1] ?? 0)
