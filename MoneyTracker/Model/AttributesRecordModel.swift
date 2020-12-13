//
//  TypeModel.swift
//  MoneyTracker
//
//  Created by Angelo Di Gianfilippo on 29/11/20.
//

import Foundation

//Type
enum TypeRecord: String {
    case expenses = "Expenses"
    case income = "Income"
}

//Expenses Category
enum ExpensesCategoryRecord: String {
    case necessity = "Necessity"
    case play = "Play"
    case investments = "Investments"
    case education = "Education"
    case longTermSaving = "Long term saving"
}

extension ExpensesCategoryRecord {
    static let allCategories: [ExpensesCategoryRecord] = [.necessity, .play, .investments, .education, .longTermSaving]
}

///TODO: Income Category
//enum IncomeCategoryRecord: String {
//    case all = "All Category"
//    case investments = "Investments"
//    case longTermSaving = "Long term saving"
//}
//
//extension IncomeCategoryRecord {
//    static let allCategory: [IncomeCategoryRecord] = [.all, .investments, .longTermSaving]
//}
