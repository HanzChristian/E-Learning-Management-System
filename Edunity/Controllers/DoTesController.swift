//
//  DoTesController.swift
//  skripsi
//
//  Created by Hanz Christian on 09/04/23.
//

import Foundation
import UIKit

class DoTesController:UIViewController{
    // MARK: - Variables & Outlet
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var answerALbl: UIButton!
    @IBOutlet weak var answerBLbl: UIButton!
    @IBOutlet weak var answerCLbl: UIButton!
    @IBOutlet weak var answerDLbl: UIButton!
    @IBOutlet weak var errorLbl: UILabel!
    
    var soalCount = 1
    var timer: Timer?
    var elapsedTime: TimeInterval = 0
    var ansArray = [String]()
    var ans: String?
    var listofSoal = [Soal]()
    
    var soalModel = SoalModel()
}
// MARK: - View Life Cycle
extension DoTesController{
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        errorLbl.isHidden = true
        startTimer()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){ [self] in
            soalModel.fetchAllFixedSoal { [self] soal, error in
                if let error = error{
                    return
                }
                listofSoal.append(contentsOf: soal!)
                print("listofsoal = \(listofSoal)")
                setNavItem()
                defineEachSoal()
            }
        }
    }
}
// MARK: - IBActions
extension DoTesController{
    @IBAction func answerAPressed(_ sender: UIButton) {
        ans = "A"
        answerALbl.backgroundColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
        answerBLbl.backgroundColor = UIColor(red: 242/255, green: 146/255, blue: 29/255, alpha: 1.0)
        answerCLbl.backgroundColor = UIColor(red: 242/255, green: 146/255, blue: 29/255, alpha: 1.0)
        answerDLbl.backgroundColor = UIColor(red: 242/255, green: 146/255, blue: 29/255, alpha: 1.0)
        
    }
    @IBAction func answerBPressed(_ sender: UIButton) {
        ans = "B"
        answerBLbl.backgroundColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
        answerALbl.backgroundColor = UIColor(red: 242/255, green: 146/255, blue: 29/255, alpha: 1.0)
        answerCLbl.backgroundColor = UIColor(red: 242/255, green: 146/255, blue: 29/255, alpha: 1.0)
        answerDLbl.backgroundColor = UIColor(red: 242/255, green: 146/255, blue: 29/255, alpha: 1.0)
    }
    @IBAction func answerCPressed(_ sender: UIButton) {
        ans = "C"
        answerCLbl.backgroundColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
        answerALbl.backgroundColor = UIColor(red: 242/255, green: 146/255, blue: 29/255, alpha: 1.0)
        answerBLbl.backgroundColor = UIColor(red: 242/255, green: 146/255, blue: 29/255, alpha: 1.0)
        answerDLbl.backgroundColor = UIColor(red: 242/255, green: 146/255, blue: 29/255, alpha: 1.0)
    }
    @IBAction func answerDPressed(_ sender: UIButton) {
        ans = "D"
        answerDLbl.backgroundColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
        answerALbl.backgroundColor = UIColor(red: 242/255, green: 146/255, blue: 29/255, alpha: 1.0)
        answerBLbl.backgroundColor = UIColor(red: 242/255, green: 146/255, blue: 29/255, alpha: 1.0)
        answerCLbl.backgroundColor = UIColor(red: 242/255, green: 146/255, blue: 29/255, alpha: 1.0)
    }
}

// MARK: - Private/Functions
extension DoTesController{
    private func setNavItem(){
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "Soal \(soalCount)/\(listofSoal.count)"
        
        if(navigationItem.title == "Soal 1/\(listofSoal.count)"){
            navigationItem.leftBarButtonItem?.title = ""
            navigationItem.leftBarButtonItem?.isEnabled = false
        }else{
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Kembali", style: .plain, target: self, action: #selector(prevQuestion))
        }
        
        print("soalcount = \(soalCount) dan listofsoal = \(listofSoal.count)")
        if(soalCount == listofSoal.count){
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simpan", style: .plain, target: self, action: #selector(saveAnswer))
        }else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Selanjutnya", style: .plain, target: self, action: #selector(nextQuestion))
        }

        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
        navigationController?.navigationBar.largeTitleTextAttributes =
        [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 28)]
    }
    
    private func defineEachSoal(){
        questionLbl.text = listofSoal[soalCount - 1].soalQuestion
        answerALbl.setTitle(listofSoal[soalCount - 1].soalAnswerA, for: .normal)
        answerBLbl.setTitle(listofSoal[soalCount - 1].soalAnswerB, for: .normal)
        answerCLbl.setTitle(listofSoal[soalCount - 1].soalAnswerC, for: .normal)
        answerDLbl.setTitle(listofSoal[soalCount - 1].soalAnswerD, for: .normal)
    }
    
    private func defineSelectedAns(){
        if(ansArray[soalCount - 1] == "A"){
            answerALbl.backgroundColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
            answerBLbl.backgroundColor = UIColor(red: 242/255, green: 146/255, blue: 29/255, alpha: 1.0)
            answerCLbl.backgroundColor = UIColor(red: 242/255, green: 146/255, blue: 29/255, alpha: 1.0)
            answerDLbl.backgroundColor = UIColor(red: 242/255, green: 146/255, blue: 29/255, alpha: 1.0)
        }else if(ansArray[soalCount - 1] == "B"){
            answerBLbl.backgroundColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
            answerALbl.backgroundColor = UIColor(red: 242/255, green: 146/255, blue: 29/255, alpha: 1.0)
            answerCLbl.backgroundColor = UIColor(red: 242/255, green: 146/255, blue: 29/255, alpha: 1.0)
            answerDLbl.backgroundColor = UIColor(red: 242/255, green: 146/255, blue: 29/255, alpha: 1.0)
        }else if(ansArray[soalCount - 1] == "C"){
            answerCLbl.backgroundColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
            answerALbl.backgroundColor = UIColor(red: 242/255, green: 146/255, blue: 29/255, alpha: 1.0)
            answerBLbl.backgroundColor = UIColor(red: 242/255, green: 146/255, blue: 29/255, alpha: 1.0)
            answerDLbl.backgroundColor = UIColor(red: 242/255, green: 146/255, blue: 29/255, alpha: 1.0)
        }else if(ansArray[soalCount - 1] == "D"){
            answerDLbl.backgroundColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
            answerALbl.backgroundColor = UIColor(red: 242/255, green: 146/255, blue: 29/255, alpha: 1.0)
            answerBLbl.backgroundColor = UIColor(red: 242/255, green: 146/255, blue: 29/255, alpha: 1.0)
            answerCLbl.backgroundColor = UIColor(red: 242/255, green: 146/255, blue: 29/255, alpha: 1.0)
        }
    }
    
    private func defineNetralAns(){
        answerALbl.backgroundColor = UIColor(red: 242/255, green: 146/255, blue: 29/255, alpha: 1.0)
        answerBLbl.backgroundColor = UIColor(red: 242/255, green: 146/255, blue: 29/255, alpha: 1.0)
        answerCLbl.backgroundColor = UIColor(red: 242/255, green: 146/255, blue: 29/255, alpha: 1.0)
        answerDLbl.backgroundColor = UIColor(red: 242/255, green: 146/255, blue: 29/255, alpha: 1.0)
    }
    
    
    @objc private func prevQuestion(){
        soalCount -= 1
//        ansArray.removeLast()
        defineEachSoal()
        defineSelectedAns()
        setNavItem()
    }
    
    @objc private func nextQuestion(){
        if(ans != nil){
            
            ansArray.append(ans!)
            
//            //if we are on the last index
//            if(soalCount == ansArray.count){
//                print("soalCount = \(soalCount) dan ansArrayCount = \(ansArray.count)")
//                defineNetralAns()
//            }else{
//                print("soalCount = \(soalCount) dan ansArrayCount = \(ansArray.count)")
//                //not on the last index
//                defineSelectedAns()
//            }
            
            soalCount += 1
            defineEachSoal()
            defineNetralAns()
            setNavItem()
            errorLbl.isHidden = true
        }else{
            errorLbl.isHidden = false
        }
    }
    
    @objc private func saveAnswer(){
        ansArray.append(ans!)
        print("ansArray = \(ansArray)")
        self.dismiss(animated: true,completion: nil)
    }
    
    private func timeString(time: TimeInterval) -> String{
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func startTimer(){
        //make timer = 0/stop
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] _ in
            
            elapsedTime += 1
            
            //update label
            timerLbl.text = "Timer: \(timeString(time: elapsedTime ?? 0))"
        })
        
    }
}
