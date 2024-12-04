import Foundation
import RegexBuilder

let inputFile = "p3.in"
let input = try! String(contentsOfFile: inputFile, encoding: .utf8)

// match regex pattern mul(\d+,\d+) to input
let pattern = /mul\((\d+),(\d+)\)/
let matches = input.matches(of: pattern)
let tuples = matches.map { match in (Int(match.1)!, Int(match.2)!) }
let result = tuples.reduce(0) { $0 + $1.0 * $1.1 }
print(result)

let optionalPattern = Regex {
    ChoiceOf {
        "do()"
        "don't()"
        Regex {
            "mul("
            Capture { OneOrMore(.digit) }
            ","
            Capture { OneOrMore(.digit) }
            ")"
        }
    }
}

let optionalMatches = input.matches(of: optionalPattern)
let optionalSum = optionalMatches.reduce((sum: 0, valid: true)) { acc, match in
    if match.0 == "do()" {
        return (acc.sum, true)
    } else if match.0 == "don't()" {
        return (acc.sum, false)
    } else {
        let tuple = (Int(match.1!)!, Int(match.2!)!)
        return (acc.sum + (acc.valid ? tuple.0 * tuple.1 : 0), acc.valid)
    }
}
print(optionalSum.sum)
