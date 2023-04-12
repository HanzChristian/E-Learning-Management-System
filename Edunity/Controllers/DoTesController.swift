//
//  DoTesController.swift
//  skripsi
//
//  Created by Hanz Christian on 09/04/23.
//

import Foundation
import UIKit
import FirebaseFirestore

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
    var ansArray = [String]()
    var ans: String?
    var listofSoal = [Soal]()
    var back: Bool?
    var correctAns = 0
    
    var timer: Timer?
    var timeFirebase: Double?
    var timeFirebaseConvert: String?
    var remainingTime: TimeInterval?
    var remainingTimeUpdated: String?
    
    var soalModel = SoalModel()
    var userModel = UserModel()
    var tesModel = TesModel()
    let db = Firestore.firestore()

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
        print("defineselecdtedAns = \(soalCount)")
        if(soalCount == ansArray.count && back == false){
            defineNetralAns()
        }else{
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
    }
    
    private func defineNetralAns(){
        answerALbl.backgroundColor = UIColor(red: 242/255, green: 146/255, blue: 29/255, alpha: 1.0)
        answerBLbl.backgroundColor = UIColor(red: 242/255, green: 146/255, blue: 29/255, alpha: 1.0)
        answerCLbl.backgroundColor = UIColor(red: 242/255, green: 146/255, blue: 29/255, alpha: 1.0)
        answerDLbl.backgroundColor = UIColor(red: 242/255, green: 146/255, blue: 29/255, alpha: 1.0)
    }
    
    
    @objc private func prevQuestion(){
        //condition if user in the last question they approach
        if(soalCount == ansArray.count){
            back = false
        }else{
            back = true
        }
        
        soalCount -= 1
        ans = ansArray[soalCount-1]
        //        ansArray.removeLast()
        defineEachSoal()
        defineSelectedAns()
        setNavItem()
        
    }
    
    @objc private func nextQuestion(){
        if(ans != nil){
            //if back never pressed
            if(back == nil){
                ansArray.append(ans!)
                print("ansArray = \(ansArray), soalCount = \(soalCount),ansArrayke = \(ansArray[soalCount-1])")
                soalCount += 1
                defineEachSoal()
                defineNetralAns()
                setNavItem()
                errorLbl.isHidden = true
            }else{
                if(back == true && soalCount == ansArray.count){
                    //if back is pressed atleast once and at the -1 array
                    print("1 back = \(back!) dan soalcount = \(soalCount) dan ansArray = \(ansArray.count)")
                    back = true
                }else if(soalCount > ansArray.count){
                    //if back is pressed atleast once
                    print("2 back = \(back!) dan soalcount = \(soalCount) dan ansArray = \(ansArray.count)")
                    back = false
                }else{
                    print("3 back = \(back!) dan soalcount = \(soalCount) dan ansArray = \(ansArray.count)")
                    back = true
                }
                
                if(back == true && soalCount == ansArray.count){
                    print("tes 1 \(ans!)")
                    ans = ansArray[soalCount-1]
                    ansArray[soalCount-1] = ans!
                    
                    print("ansArray = \(ansArray), soalCount = \(soalCount),ansArrayke = \(ansArray[soalCount-1])")
                    soalCount += 1
                    defineNetralAns()
                    defineEachSoal()
                    setNavItem()
                    errorLbl.isHidden = true
                }
                else if(back == true){
                    print("tes 2 \(ans!)")
                    //update the previous answer in array based on soalCount
                    
                    ans = ansArray[soalCount-1]
                    ansArray[soalCount-1] = ans!
                    
                    
                    print("ansArray = \(ansArray), soalCount = \(soalCount),ansArrayke = \(ansArray[soalCount-1])")
                    soalCount += 1
                    defineSelectedAns()
                    defineEachSoal()
                    setNavItem()
                    errorLbl.isHidden = true
                }else if(back == false){
                    print("tes 3 \(ans!)")
                    //if the next question is the question that the user haven't access yet
                    ansArray.append(ans!)
                    print("ansArray = \(ansArray), soalCount = \(soalCount),ansArrayke = \(ansArray[soalCount-1])")
                    soalCount += 1
                    defineEachSoal()
                    defineNetralAns()
                    setNavItem()
                    errorLbl.isHidden = true
                }
            }
            
            
        }else{
            errorLbl.isHidden = false
        }
    }
    
    @objc private func saveAnswer(){
        ansArray.append(ans!)
        
        let alert = UIAlertController(title: "Kamu yakin ingin menyelesaikan tes?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Belum", style: .cancel,handler:{_ in
            print("keluar")
        }))
        
        alert.addAction(UIAlertAction(title: "Selesai", style: .default,handler:{ [self]_ in
            //save here
            let answerList = listofSoal.map { $0.soalCorrectAns }
         
            print("ansArray = \(ansArray), answerList = \(answerList)")
            timer?.invalidate()
            
            //loop to see how many correct ans
            for i in 0..<answerList.count{
                if(ansArray[i] == answerList[i]){
                    correctAns += 1
                }else{
                    
                }
            }
            
            //score
            var finalScore = Double(correctAns) / Double(listofSoal.count)
            finalScore *= 100
            
            userModel.fetchUser { [self] user in
                let id = user.id
                let userName = user.name
                
                db.collection("muridTes").addDocument(data: [
                    "name": userName,
                    "score": finalScore,
                    "userid": id,
                    "tesid": SelectedTes.selectedTes.tesPath,
                    "classid": SelectedClass.selectedClass.classPath,
                    "modulid": SelectedModul.selectedModul.modulPath
                ]){ (error) in
                    
                    if error != nil{
                    }
                    else{
                        let storyboard = UIStoryboard(name: "HomePage", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "HomePageController") as! HomePageController
                        let nav =  UINavigationController(rootViewController: vc)
                        nav.modalPresentationStyle = .fullScreen
                        self.present(nav, animated: true)
                    }
                }
            }
        }))
        
        present(alert,animated:true)
    }
    
    private func forceSave(){
        let alert = UIAlertController(title: "Waktu tes telah habis!", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Lanjut", style: .default,handler:{ [self]_ in
            //save here
            let answerList = listofSoal.map { $0.soalCorrectAns }
            
            if(ansArray.count < answerList.count){
                for _ in ansArray.count..<answerList.count{
                    ansArray.append("-")
                }
            }
            
            print("total answer: \(answerList), jawaban yang masuk : \(ansArray)")
            //loop to see how many correct ans
            for i in 0..<answerList.count{
                if(ansArray[i] == answerList[i]){
                    correctAns += 1
                }else{
                    
                }
            }
            
            //score
            var finalScore = Double(correctAns) / Double(listofSoal.count)
            finalScore *= 100
            
            userModel.fetchUser { [self] user in
                let id = user.id
                let userName = user.name
                
                db.collection("muridTes").addDocument(data: [
                    "name": userName,
                    "score": finalScore,
                    "userid": id,
                    "tesid": SelectedTes.selectedTes.tesPath,
                    "classid": SelectedClass.selectedClass.classPath,
                    "modulid": SelectedModul.selectedModul.modulPath
                ]){ (error) in
                    
                    if error != nil{
                    }
                    else{
                        let storyboard = UIStoryboard(name: "HomePage", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "HomePageController") as! HomePageController
                        let nav =  UINavigationController(rootViewController: vc)
                        nav.modalPresentationStyle = .fullScreen
                        self.present(nav, animated: true)
                    }
                }
            }
        }))
        present(alert,animated: true)
        
    }
    
    private func startTimer(){
        tesModel.fetchSpesificTes { [self] tes, error in
            timeFirebase = tes?.timer
            timeFirebaseConvert = convertTime(TimeInterval(timeFirebase!))
            
            remainingTime = TimeInterval(timeFirebase!)
            
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
                guard let self = self else { return }
                
                remainingTime! -= 1
                
                // Update timer label
                remainingTimeUpdated = self.convertTime(remainingTime!)
                self.timerLbl.text = "Sisa Waktu : \(remainingTimeUpdated!)"
                
                // End time when 00:00:00
                if remainingTime! <= 0 {
                    timer.invalidate()
                    self.timerLbl.text = "Sisa Waktu : 00:00:00"
                    forceSave()
                    
                }
            }
            
            //start Countdown
            RunLoop.current.add(timer!, forMode: .common)
        }
    }

    //convert Double into time format
    private func convertTime(_ timeInterval: TimeInterval) -> String{
        let hours = Int(timeInterval/3600)
        let minutes = Int((timeInterval.truncatingRemainder(dividingBy: 3600))/60)
        let seconds = Int(timeInterval.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
}
