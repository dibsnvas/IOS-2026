// Assignment #1: My Life Story in Swift

let firstName: String = "Diana"
let lastName: String = "Beisenbayeva"
let birthYear: Int = 2005
let currentYear: Int = 2026
let age: Int = currentYear - birthYear
let isStudent: Bool = true
let height: Double = 1.72

let hobby: String = "going to the gym and watching documentary films"
let numberOfHobbies: Int = 2
let favoriteNumber: Int = 13
let isHobbyCreative: Bool = false

let futureGoals: String = "earn as much as possible amount of money before I turn 30 and then quit working"
let 😭: String = "😭"

let studentStatus: String = isStudent ? "I am currently a student" : "I am not currently a student"
let creativityDescription: String = isHobbyCreative ? "creative" : "not especially creative"

let lifeStory: String = "My name is \(firstName) \(lastName). I am \(age) years old and was born in \(birthYear). \(studentStatus). I am \(height) meters tall. I enjoy \(hobby), which I consider \(creativityDescription). I have \(numberOfHobbies) main hobbies, and my favorite number is \(favoriteNumber). In the future, I want to \(futureGoals) \(😭)"

print(lifeStory)
