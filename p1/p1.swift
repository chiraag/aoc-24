import Foundation

let inputFile = "p1.in"

let input = try! String(contentsOfFile: inputFile, encoding: .utf8)
let lines = input.split(separator: "\n")
let data = lines.map { $0.split(separator: " ").map { Int($0)! } }
let transposedData = data[0].indices.map { i in data.map { $0[i] } }

let sortedData = transposedData.map { $0.sorted() }
let diff = zip(sortedData[0], sortedData[1]).map { abs($0.1 - $0.0) }
let sum = diff.reduce(0, +)
print(sum)

let dict = sortedData.map { $0.reduce(into: [:]) { $0[$1, default: 0] += 1 } }
let product = dict[0].map { $0.key * $0.value * dict[1][$0.key, default: 0] }
let productSum = product.reduce(0, +)
print(productSum)
