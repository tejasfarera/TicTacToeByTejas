//
//  ViewController.swift
//  ticTacToeTejas
//
//  Created by rails on 16/07/19.
//  Copyright © 2019 rails. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //MARK: - class property
    
    @IBOutlet weak var playerXLabel: UILabel!
    @IBOutlet weak var playerYLabel: UILabel!
    @IBOutlet weak var boardCollectionView: UICollectionView!
    var matrix = Dictionary<Int,String>()
    var count :Int = 0
    var evenOdd : Bool = false
    var X: Int = 0
    var O: Int = 0
    var playerX = String()
    var playerO = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        inputPlayerNames()
        return 9;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myIdentifier", for: indexPath) as? MyCollectionViewCell else{
            return MyCollectionViewCell()
        }
        cell.inputLabel.text = ""
        cell.backgroundColor = UIColor.brown
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MyCollectionViewCell
        if(!(cell.inputLabel.text == "X" || cell.inputLabel.text == "O")){
            
            var player = String()
            if(evenOdd == false){
                cell.inputLabel.text="X"
                evenOdd = true
                player = "X"
                matrix[indexPath.row] = "X"
                cell.backgroundColor = UIColor.red
            }
            else{
                cell.inputLabel.text="O"
                evenOdd = false
                player = "O"
                matrix[indexPath.row] = "O"
                cell.backgroundColor = UIColor.green
            }
            if(checkCount()){
                if checkSuccess(index: indexPath.row, player: player){
                    showAlert(game: player)
                    increasePlayer(player: player)
                    resetGame()
                    return
                }
            }
            count+=1
            if(count == 9){
                showAlert(game: "draw")
                resetGame()
            }
        }
    }
    
    func inputPlayerNames(){
        let alert = UIAlertController(title: "Enter Name", message: "Enter name of player 1", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Eg: Tejas"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            self.playerXLabel.text = textField.text! + " 0"
            self.playerX = textField.text!
            
            // player 2 name alert
            let alert2 = UIAlertController(title: "Enter Name", message: "Enter name of player 2", preferredStyle: .alert)
            alert2.addTextField { (textField) in
                textField.placeholder = "Eg: Tejas"
            }
            alert2.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert2] (_) in
                let textField = alert2!.textFields![0]
                self.playerYLabel.text = textField.text! + " 0"
                self.playerO = textField.text!
            }))
            self.present(alert2, animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
       
    }
    
    func increasePlayer(player: String){
        switch player {
        case "X":
            X+=1
            playerXLabel.text = "\(playerX) \(X)"
        case "O":
            O+=1
            playerYLabel.text = "\(playerO) \(O)"
        default:
            print("Error in player increament")
        }
    }
    
    func resetGame(){
        boardCollectionView.reloadData()
        matrix.removeAll()
        count = 0
    }
    
    func showAlert(game: String){
        switch game {
        case "X":
            let alert = UIAlertController(title: "Result", message: "\(playerX) Won", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        case "O":
            let alert = UIAlertController(title: "Result", message: "\(playerO) Won", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        case "draw":
            let alert = UIAlertController(title: "Result", message: "Game is draw", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        default:
            print("error in declaring result")
        }
    }
    
    func checkSuccess(index: Int, player: String) -> Bool{
        return ( checkVertical(index: index, player: player) || checkHorizontal(index: index, player: player) || checkDiagonal(index: index, player: player) )
    }
    
    func checkDiagonal(index: Int, player: String) -> Bool{
        if index % 2 == 0 {
            return (diagonalUp(index: index, player: player) || diagonalDown(index: index, player: player))
        }
        return false
    }
    
    func diagonalUp(index: Int, player: String) -> Bool{
        var increament = 2
        for _ in (1...3){
            if !(matrix[increament] != nil && matrix[(increament)] == player){
                return false
            }
            increament += 2
        }
        return true
    }
    
    func diagonalDown(index: Int, player: String) -> Bool{
        var diagonalIncreament = 4
        for var i in (1...2){
            if !(matrix[(index+diagonalIncreament)%12] != nil && matrix[(index+diagonalIncreament)%12] == player){
                return false
            }
            diagonalIncreament += 4
            i+=1
        }
        return true
    }
    
    func checkHorizontal(index: Int, player: String) -> Bool{
        let row = (index+3)/3
        var horizontalIncrement = 0
        for var i in (0...2)  {
            if !(matrix[(row-1)*3+horizontalIncrement] != nil && matrix[(row-1)*3+horizontalIncrement] == player) {
                return false
            }
            horizontalIncrement+=1
            i+=1
        }
        return true
    }
    
    func checkVertical(index: Int, player: String) -> Bool{
        var verticalIncrement = 3
        for var i in (1...2)  {
            if !(matrix[(index+verticalIncrement)%9] != nil && matrix[(index+verticalIncrement)%9] == player) {
                return false
            }
            verticalIncrement+=3
            i+=1
        }
        return true
    }
    
    func checkCount() -> Bool{
        if(count>3){
            return true;
        }
        return false;
    }
}
