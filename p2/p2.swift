import Foundation

let inputFile = "p2.in"
let input = try! String(contentsOfFile: inputFile, encoding: .utf8)
let lines = input.split(separator: "\n")
let data = lines.map { $0.split(separator: " ").map { Int($0)! } }

let numLevels = data.map { $0.count }

func getDeltaDir(_ next: Int, _ curr: Int) -> Int {
    if next > curr && next - curr < 4 {
        return 1
    } else if curr > next && curr - next < 4 {
        return -1
    } else {
        return 0
    }
}

let deltaDir = data.map { row in zip(row.dropFirst(), row.dropLast()).map { getDeltaDir($0, $1) } }
// print(deltaDir)
let deltaSum = deltaDir.map { $0.reduce(0, +) }
// print(deltaSum)
let numSafe = zip(deltaSum, numLevels).reduce(0) { $0 + (abs($1.0) == $1.1 - 1 ? 1 : 0) }
print(numSafe)

func checkDeltaDirCore(_ arr: [Int]) -> Bool {
    let deltaDir = zip(arr.dropFirst(), arr.dropLast()).map { getDeltaDir($0, $1) }
    return abs(deltaDir.reduce(0, +)) == arr.count - 1
}

func checkDeltaDirQuad(_ arr: [Int]) -> Bool {
    return arr.indices.map { i in
        let newArr = arr.enumerated().filter { $0.offset != i }.map { $0.element }
        return checkDeltaDirCore(newArr)
    }.reduce(checkDeltaDirCore(arr)) { $0 || $1 }
}

let numSafeSkip = data.reduce(0) { $0 + (checkDeltaDirQuad($1) ? 1 : 0) }
print(numSafeSkip)

// TODO: Implement a linear solution
// sketch:
// run checkDeltaDirCore on each row - O(n)
// if true done else:
// compute cumulative deltaDir count for prefix sub-array (exclusive) at each index - O(n)
// compute cumulative deltaDir count for suffix sub-array (exclusive) at each index - O(n)
// check first location where abs(prefix + suffix) == n - 3  - O(n)
// if none found, return false
// else, compute deltaDir with skip at that index - O(1)
// check if abs(prefix + suffix + deltaDirSkip) == n - 2 - O(1)
// Claim: No need to check any other index
// Proof: If other index exists, then checkDeltaDirCore would have returned true
// Reason if we have monotone sequence ignoring two indices, then whole sequence is monotone
