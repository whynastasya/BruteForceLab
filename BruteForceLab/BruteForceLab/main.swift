//
//  main.swift
//  BruteForceLab
//
//  Created by nastasya on 25.10.2024.
//

import Foundation
import CryptoKit

let dictionary = Array("abcdefghijklmnopqrstuvwxyz")
let dictionaryLength = dictionary.count

func intToPassword(_ n: Int) -> String {
    var password = [Character](repeating: "a", count: 5)
    var n = n
    for i in stride(from: 4, through: 0, by: -1) {
        password[i] = dictionary[n % dictionaryLength]
        n /= dictionaryLength
    }
    return String(password)
}

func calculateMD5(_ s: String) -> String {
    let data = Data(s.utf8)
    let hash = Insecure.MD5.hash(data: data)
    return hash.map { String(format: "%02x", $0) }.joined()
}

func calculateSHA256(_ s: String) -> String {
    let data = Data(s.utf8)
    let hash = SHA256.hash(data: data)
    return hash.map { String(format: "%02x", $0) }.joined()
}

func bruteForce(hash: String, threadsAmount: Int, calculateHashFunc: @escaping (String) -> String) {
    let totalCombinations = Int(pow(Double(dictionaryLength), 5))
    let resultsQueue = DispatchQueue(label: "com.bruteforce.resultsQueue")
    var results: [String] = []

    let workerQueue = DispatchQueue(label: "com.bruteforce.workerQueue", attributes: .concurrent)
    let group = DispatchGroup()

    for threadId in 0..<threadsAmount {
        workerQueue.async(group: group) {
            for i in stride(from: threadId, to: totalCombinations, by: threadsAmount) {
                let password = intToPassword(i)
                if calculateHashFunc(password) == hash {
                    resultsQueue.sync {
                        results.append(password)
                        print("Поток \(threadId): Найден пароль - \(password)")
                    }
                }
            }
        }
    }

    group.wait()

    print("\nВсе найденные пароли:")
    for password in results {
        print(password)
    }
    print("Общее количество совпадений: \(results.count)")
}

func main() {
    while true {
        print("Введите тип хэширования (md5 или sha256):")
        guard let hashType = readLine()?.lowercased(), (hashType == "md5" || hashType == "sha256") else {
            print("Неверный тип хэширования. Доступны только md5 или sha256.")
            return
        }
        
        print("Введите хэш для брутфорса:")
        guard let hash = readLine(), (hashType == "md5" && hash.count == 32) || (hashType == "sha256" && hash.count == 64) else {
            print("Неверная длина хэша для \(hashType).")
            return
        }
        
        print("Введите количество потоков:")
        guard let threadsAmountStr = readLine(), let threadsAmount = Int(threadsAmountStr), threadsAmount > 0 else {
            print("Количество потоков должно быть натуральным числом больше нуля.")
            return
        }
        
        print("\nЗапуск брутфорса...")
        let start = Date()
        bruteForce(hash: hash, threadsAmount: threadsAmount, calculateHashFunc: hashType == "sha256" ? calculateSHA256 : calculateMD5)
        let elapsed = Date().timeIntervalSince(start)
        print("\nБрутфорс завершен за \(elapsed) секунд")
    }
}

main()
