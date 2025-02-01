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
    
    class HistoryStore: ObservableObject {
      @Published var exerciseDays: [ExerciseDay] = []
      @Published var loadingError = false

      enum FileError: Error {
        case loadFailure
        case saveFailure
      }
        
    init() {
      #if DEBUG
      // createDevData()
      #endif
      do {
        try load()
      } catch {
        loadingError = true
      }
    }
    
    var dataURL: URL {
      URL.documentsDirectory
        .appendingPathComponent("history.plist")
    }
    func load() throws {
      guard let data = try? Data(contentsOf: dataURL) else {
        return
      }
      do {
        let plistData = try PropertyListSerialization.propertyList(
          from: data,
          options: [],
          format: nil)
        let convertedPlistData = plistData as? [[Any]] ?? []
        exerciseDays = convertedPlistData.map {
          ExerciseDay(
            date: $0[1] as? Date ?? Date(),
            exercises: $0[2] as? [String] ?? [])
    
        }
    } catch {
        throw FileError.loadFailure
    }
}
func save() throws {
   let plistData = exerciseDays.map {
     [$0.id.uuidString, $0.date, $0.exercises]
   }
   do {
     let data = try PropertyListSerialization.data(
       fromPropertyList: plistData,
       format: .binary,
       options: .zero)
     try data.write(to: dataURL, options: .atomic)
   } catch {
     throw FileError.saveFailure
    }
}
    func addDoneExercise(_ exerciseName: String) {
        let today = Date()
        if let firstDate = exerciseDays.first?.date,
           today.isSameDay(as: firstDate) { // 1
            exerciseDays[0].exercises.append(exerciseName)
        } else {
            exerciseDays.insert(
                ExerciseDay(date: today, exercises: [exerciseName]),
                at: 0)
        }
        do {
            try save()
        }   catch {
            fatalError(error.localizedDescription)
        }
    }
}
