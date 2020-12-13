//
//  BalanceRecapViewModel.swift
//  MoneyTracker
//
//  Created by Angelo Di Gianfilippo on 11/12/20.
//

import Foundation
import SwiftUI

class BalanceViewModel {
    
    //Income & Expenses Total
    func totalOf(_ type: String, allRecords: FetchedResults<Record>) -> String {
        var total: Double = 0.00
        
        for r in allRecords {
            if r.type == type {
                total += r.amount
            }
        }
        
        if type == TypeRecord.expenses.rawValue {
            total *= -1
        }
        
        return convertToString(total)
    }
    
    //Net
    func net(allRecords: FetchedResults<Record>) -> String {
        var income: Double = 0
        var expenses: Double = 0
        for r in allRecords {
            if r.type == TypeRecord.income.rawValue {
                income += r.amount
            } else if r.type == TypeRecord.expenses.rawValue {
                expenses += r.amount
            }
        }
        
        let net = income - expenses
        
        return convertToString(net)
    }
    
    //Formatter
    private func convertToString(_ amount: Double) -> String {
        return amountFormatter.string(from: NSNumber(value: amount)) ?? "-"
    }
    
    private var amountFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.locale = NSLocale.current
        return f
    }()
    
    //Color Net Text
    func colorNetText(allRecords: FetchedResults<Record>) -> Color {
        var income: Double = 0
        var expenses: Double = 0
        for r in allRecords {
            if r.type == TypeRecord.income.rawValue {
                income += r.amount
            } else if r.type == TypeRecord.expenses.rawValue {
                expenses += r.amount
            }
        }
        
        let net = income - expenses
        
        if net > 0 {
            return .green
        } else if net < 0 {
            return .red
        } else {
            return .gray
        }
    }
    
}
