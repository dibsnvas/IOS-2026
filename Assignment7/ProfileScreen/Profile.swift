import Foundation

struct Profile {
    let name: String
    let handle: String
    let avatarImageName: String
    let posts: Int
    let followers: Int
    let following: Int
    let about: String
}

extension Profile {
    // Long text test from the assignment: put "Maximilian Alexander von Habsburg" into `name`.
    static let sample = Profile(
        name: "Бейсенбаева Диана",
        handle: "@dibsnva · Almaty",
        avatarImageName: "avatar",
        posts: 10,
        followers: 50,
        following: 10_000_000,
        about: "AI Tech Lead, B2B at nFactorial School. "
            + "I want to get into Big Tech (Apple) in the next 5 years. "
            + "Speaker at Gitex.ai on the AI batch."
    )
}
