//
//  HistoryStore.swift
//  HITFit
//
//  Created by Mikkela Wilson on 1/23/25.
//

import Foundation

struct ExerciseDay: Identifiable {
    let id = UUID()
    let date: Date
    var exercises: [String] = []
}
struct HistoryStore {
    var exerciseDays: [ExerciseDay] = []
    
    init() {
    #if DEBUG
    createDevData()
    #endif
    }
}
