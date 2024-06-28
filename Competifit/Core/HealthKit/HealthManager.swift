//
//  HealthManager.swift
//  Competifit
//
//  Created by Vamsi Putti on 6/27/24.
//

import Foundation
import HealthKit

extension Date {
    static var startOfDay: Date {
        Calendar.current.startOfDay(for: Date())
    }
}

enum HealthError: Error {
    case healthDataNotAvailable
}

class HealthManager: ObservableObject {
    
    var steps: [Step] = []
        var healthStore: HKHealthStore?
        var lastError: Error?
        
        init() {
            if HKHealthStore.isHealthDataAvailable() {
                healthStore = HKHealthStore()
            } else {
                lastError = HealthError.healthDataNotAvailable
            }
        }
        
        func calculateSteps() async throws {
            
            guard let healthStore = self.healthStore else { return }
            
            let calendar = Calendar(identifier: .gregorian)
            let startDate = calendar.date(byAdding: .day, value: -7, to: Date())
            let endDate = Date()
            
            let stepType = HKQuantityType(.stepCount)
            let everyDay = DateComponents(day:1)
            let thisWeek = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
            let stepsThisWeek = HKSamplePredicate.quantitySample(type: stepType, predicate:thisWeek)
            
            let sumOfStepsQuery = HKStatisticsCollectionQueryDescriptor(predicate: stepsThisWeek, options: .cumulativeSum, anchorDate: endDate, intervalComponents: everyDay)
            
            let stepsCount = try await sumOfStepsQuery.result(for: healthStore)
            
            guard let startDate = startDate else { return }
            
            stepsCount.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
                let count = statistics.sumQuantity()?.doubleValue(for: .count())
                let step = Step(count: Int(count ?? 0), date: statistics.startDate)
                if step.count > 0 {
                    // add the step in steps collection
                    self.steps.append(step)
                }
            }
            
        }
        
        func requestAuthorization() async {
            
            guard let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else { return }
            guard let healthStore = self.healthStore else { return }
            
            do {
                try await healthStore.requestAuthorization(toShare: [], read: [stepType])
            } catch {
                lastError = error
            }
            
        }
    
    
//    let healthStore = HKHealthStore()
//    
//    init() {
//        let steps = HKQuantityType(.stepCount)
//        let healthTypes: Set = [steps]
//        print("Are we even here??????")
//        
//        Task {
//            do {
//                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
//            } catch {
//                print("Unable to")
//            }
//        }
//        
//        print("Task finished")
//        
//    }
//    
//    func fetchTodaysSteps() {
//        let steps = HKQuantityType(.stepCount)
//        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
//        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
//            guard let result = result, let quantity = result.sumQuantity(), error != nil else {
//                print("\(error)")
//                return
//            }
//            print(quantity.doubleValue(for: .count()))
//            
//        }
//        healthStore.execute(query)
//    }
}
