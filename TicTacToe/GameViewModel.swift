//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Keiichi Taira on 5/19/23.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9) //creating array of 9 nils
    @Published var isGameboardDisabled = false
    @Published var alertItem: AlertItem?
    
    func processPlayerMove(position: Int) {
        //Human move processing
        if isOccupied(moves: moves, index: position) { return }
        moves[position]  = Move(player: .human, boardIndex: position)
        
        if checkWinCondition(player: .human, moves: moves) {
            alertItem = AlertContent.humanWin
            return
        }
        
        if checkForDraw(moves: moves) {
            alertItem = AlertContent.draw
            return
        }
        
        isGameboardDisabled = true
        
        //computer move processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 1 ){ [self] in
            let computerPosition = determineComputerMovePosition(moves: moves)
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            isGameboardDisabled = false
            
            if checkWinCondition(player: .computer, moves: moves) {
                alertItem = AlertContent.computerWin
                return
            }
            
            if checkForDraw(moves: moves) {
                alertItem = AlertContent.draw
                return
            }
        }
    }
    
    //check if the space is occupied
    func isOccupied(moves: [Move?], index: Int) -> Bool {
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
    //computer will fill any spaces available
    func determineComputerMovePosition(moves: [Move?]) -> Int {
        
        //If AI can win, then win
        let winPattern: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8],[0,4,8],[2,4,6]]
        
        let computerMoves = moves.compactMap({ $0 }).filter( {$0.player == .computer})
        let computerPosition = Set(computerMoves.map { $0.boardIndex })
        
        for pattern in winPattern {
            let winPosition = pattern.subtracting(computerPosition)
            
            if winPosition.count == 1 {
                let isAvailable = !isOccupied(moves: moves, index: winPosition.first!)
                if isAvailable { return winPosition.first! }
            }
        }
        
        //If AI can't win, then block
        let humanMoves = moves.compactMap({ $0 }).filter( {$0.player == .human})
        let humanPosition = Set(humanMoves.map { $0.boardIndex })
        
        for pattern in winPattern {
            let winPosition = pattern.subtracting(humanPosition)
            
            if winPosition.count == 1 {
                let isAvailable = !isOccupied(moves: moves, index: winPosition.first!)
                if isAvailable { return winPosition.first! }
            }
        }
        //If AI can't block, then take the middle square
        let centerSquare = 4
        if !isOccupied(moves: moves, index: centerSquare){
            return centerSquare
        }
        //If AI can't take the middle square, take a random available square
        var movePosition = Int.random(in: 0 ..< 9)
        
        while isOccupied(moves: moves, index: movePosition){
            movePosition = Int.random(in: 0 ..< 9)
        }
        return movePosition
    }
    
    func checkWinCondition(player: Player, moves: [Move?]) -> Bool {
        let winPattern: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8],[0,4,8],[2,4,6]]
        
        let playerMoves = moves.compactMap({ $0 }).filter( {$0.player == player}) // filters only player Moves
        let playerPosition = Set(playerMoves.map { $0.boardIndex }) // create a Set with Player Position
        
        //check if there exists a subset of winPattern to determine if human/computer won
        for pattern in winPattern where pattern.isSubset(of: playerPosition){
            return true
        }
        return false
    }
    
    //check if all spaces are filled without a subset of winpattern
    func checkForDraw(moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9 // check if all spaces are filled
    }
    
    //resets the game by setting the arrays empty
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }
}
