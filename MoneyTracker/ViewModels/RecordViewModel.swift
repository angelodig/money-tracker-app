//
//  RecordViewModel.swift
//  MoneyTracker
//
//  Created by Angelo Di Gianfilippo on 29/11/20.
//

import Foundation
import SwiftUI

class RecordViewModel {
    var id: UUID
    var title: String
    var date: Date
    var type: TypeRecord.RawValue
    var category: ExpensesCategoryRecord.RawValue
    var tag: String
    var note: String
    var amount: Double
    
    //Date
    private var dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = NSLocale.current
        f.dateStyle = .long
        f.timeStyle = .none
        return f
    }()
    
    var dateString: String {
        return dateFormatter.string(from: date)
    }
    
    //Type
    var typeImageName: String {
        switch self.type {
        case TypeRecord.income.rawValue:
            return "plus.circle.fill"
        case TypeRecord.expenses.rawValue:
            return "minus.circle.fill"
        default:
            return "dollarsign.circle.fill"
        }
    }
    
    var colorImageType: Color {
        switch self.type {
        case TypeRecord.expenses.rawValue:
            return .red
        case TypeRecord.income.rawValue:
            return .green
        default:
            return .black
        }
    }
    
    //Category
    var colorCategoryLabel: Color {
        switch self.category {
        case ExpensesCategoryRecord.necessity.rawValue:
            return .gray
        case ExpensesCategoryRecord.play.rawValue:
            return .red
        case ExpensesCategoryRecord.investments.rawValue:
            return .green
        case ExpensesCategoryRecord.education.rawValue:
            return .blue
        case ExpensesCategoryRecord.longTermSaving.rawValue:
            return .orange
        default:
            return .black
        }
    }
    
    //Amount
    private var amountFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.locale = NSLocale.current
        return f
    }()
    
    var amountString: String {
        return amountFormatter.string(from: NSNumber(value: self.amount)) ?? "--"
    }
    
    //Amount Without currency
    private var amountFormatterNoCurrency: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencySymbol = ""
        f.locale = NSLocale.current
        return f
    }()
    
    var amountStringNoCurrency: String {
        return amountFormatterNoCurrency.string(from: NSNumber(value: self.amount)) ?? "--"
    }
    
    //Init
    init(id: UUID, title: String, date: Date, type: String, category: String, tag: String, note: String, amount: Double) {
        self.id = id
        self.title = title
        self.date = date
        self.type = type
        self.category = category
        self.tag = tag
        self.note = note
        self.amount = amount
    }
    
    init(record: Record) {
        self.id = record.id ?? UUID()
        self.title = record.title ?? ""
        self.date = record.date ?? Date()
        self.type = record.type ?? TypeRecord.expenses.rawValue
        self.category = record.category ?? ExpensesCategoryRecord.necessity.rawValue
        self.tag = record.tag ?? ""
        self.note = record.note ?? ""
        self.amount = record.amount
    }
    
}
