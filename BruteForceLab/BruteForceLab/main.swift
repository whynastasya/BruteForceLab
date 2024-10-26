//
//  main.swift
//  BruteForceLab
//
//  Created by nastasya on 25.10.2024.
//

import Foundation
import CryptoKit

// Функция для генерации всех пятибуквенных комбинаций из английских строчных букв
func generatePasswords() -> [String] {
    let chars = Array("abcdefghijklmnopqrstuvwxyz")
    var passwords = [String]()
    for c1 in chars {
        for c2 in chars {
            for c3 in chars {
                for c4 in chars {
                    for c5 in chars {
                        passwords.append("\(c1)\(c2)\(c3)\(c4)\(c5)")
                    }
                }
            }
        }
    }
    return passwords
}

// Функция для вычисления MD5 хеша
func md5Hash(for password: String) -> String {
    let data = Data(password.utf8)
    let hash = Insecure.MD5.hash(data: data)
    return hash.map { String(format: "%02hhx", $0) }.joined()
}

// Функция для вычисления SHA-256 хеша
func sha256Hash(for password: String) -> String {
    let data = Data(password.utf8)
    let hash = SHA256.hash(data: data)
    return hash.map { String(format: "%02hhx", $0) }.joined()
}

// Однопоточная функция перебора
func bruteForceSingleThread(targetMD5: String, targetSHA256: String) -> String? {
    let passwords = generatePasswords()
    for password in passwords {
        if md5Hash(for: password) == targetMD5 || sha256Hash(for: password) == targetSHA256 {
            return password
        }
    }
    return nil
}

// Многопоточная функция перебора
func bruteForceMultiThread(targetMD5: String, targetSHA256: String, numThreads: Int) -> String? {
    let passwords = generatePasswords()
    let chunkSize = passwords.count / numThreads
    let group = DispatchGroup()
    var foundPassword: String?

    for i in 0..<numThreads {
        let start = i * chunkSize
        let end = i == numThreads - 1 ? passwords.count : start + chunkSize
        let chunk = Array(passwords[start..<end])

        DispatchQueue.global().async(group: group) {
            for password in chunk {
                if md5Hash(for: password) == targetMD5 || sha256Hash(for: password) == targetSHA256 {
                    foundPassword = password
                    return
                }
            }
        }
    }

    group.wait()
    return foundPassword
}

func main() {
    print("Введите MD5 хеш: ", terminator: "")
    let targetMD5 = readLine()!.trimmingCharacters(in: .whitespacesAndNewlines)

    print("Введите SHA-256 хеш: ", terminator: "")
    let targetSHA256 = readLine()!.trimmingCharacters(in: .whitespacesAndNewlines)

    print("Однопоточный режим:")
    let startTimeSingle = Date()
    if let password = bruteForceSingleThread(targetMD5: targetMD5, targetSHA256: targetSHA256) {
        print("Найден пароль: \(password)")
    } else {
        print("Пароль не найден")
    }
    let endTimeSingle = Date()
    print("Время выполнения: \(endTimeSingle.timeIntervalSince(startTimeSingle)) секунд")

    print("\nВведите количество потоков для многопоточного режима: ", terminator: "")
    let numThreads = Int(readLine()!) ?? 4
    print("\nМногопоточный режим с \(numThreads) потоками:")
    let startTimeMulti = Date()
    if let password = bruteForceMultiThread(targetMD5: targetMD5, targetSHA256: targetSHA256, numThreads: numThreads) {
        print("Найден пароль: \(password)")
    } else {
        print("Пароль не найден")
    }
    let endTimeMulti = Date()
    print("Время выполнения: \(endTimeMulti.timeIntervalSince(startTimeMulti)) секунд")
}

main()
