import UIKit

private func generateMockDates(for days: Int) -> [Date] {
    let yesterdaySlice: Double = 60 * 60 * 24
    var dates: [Date] = []
    var currentDate = Date.now - yesterdaySlice

    for _ in 0..<days {
        dates.append(currentDate)
        currentDate.addTimeInterval(-yesterdaySlice)
    }
    return dates
}

private func getStrictDateFromToday(_ dates: [Date]) -> Int {
    var strictCount = 0
    let yesterdaySlice: Double = 60 * 60 * 24

    let calendar = Calendar(identifier: .gregorian)
    var strictCompareDate = Date.now

    for targetDate in dates.sorted().reversed() {
        let prevDateComponent = calendar.dateComponents([.year, .month, .day], from: strictCompareDate)
        let targetDateComponent = calendar.dateComponents([.year, .month, .day], from: targetDate)

        // Check if the current and target date components are the same
        if prevDateComponent != targetDateComponent {
            break
        }

        // Increment strict count and move to the previous day
        strictCount += 1
        strictCompareDate = strictCompareDate.addingTimeInterval(-yesterdaySlice)
    }

    return strictCount
}

let mockDates = generateMockDates(for: 2)
let strictCount = getStrictDateFromToday(mockDates)
print("Strict count: \(strictCount)")
