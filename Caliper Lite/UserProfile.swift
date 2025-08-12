//
//  UserProfile.swift
//  Caliper Lite Redesign
//
//  Created by Азар Аскаров on 05.08.2025.
//

import Foundation


class UserProfile: ObservableObject {
    @Published var userGender: String
    @Published var userBirthDate: Date
    
    init() {
        self.userGender = UserDefaults.standard.string(forKey: "UserGender") ?? "Не выбран"
        self.userBirthDate = UserDefaults.standard.object(forKey: "UserBirthDate") as? Date ?? Date()
    }
    
    func saveGender(_ gender: String) {
        UserDefaults.standard.set(gender, forKey: "UserGender")
        self.userGender = gender
    }
    
    func saveDate(_ date: Date) {
        UserDefaults.standard.set(date, forKey: "UserBirthDate")
        self.userBirthDate = date
    }
}

extension Date {
    func calculateAge() -> Int {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: self, to: now)
        return ageComponents.year ?? 0
    }
}


