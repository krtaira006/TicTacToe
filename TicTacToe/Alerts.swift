//
//  Alerts.swift
//  TicTacToe
//
//  Created by Keiichi Taira on 5/19/23.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContent {
    static let humanWin = AlertItem(title: Text("You Win!"),
                                    message: Text("You beat the Computer!"),
                                    buttonTitle: Text("Done"))
    static let computerWin = AlertItem(title: Text("You Lost!"),
                                       message: Text("You need to try harder"),
                                       buttonTitle: Text("Rematch"))
    static let draw = AlertItem(title: Text("Draw"),
                                message: Text("what a battle!"),
                                buttonTitle: Text("Try Again"))
}
