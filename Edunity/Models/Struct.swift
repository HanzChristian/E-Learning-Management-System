//
//  Struct.swift
//  skripsi
//
//  Created by Hanz Christian on 05/03/23.
//

import Foundation
import UIKit

// MARK: - Structures
struct User{
    var id: String = UUID().uuidString
    var name: String
    var role: String
    
    init(name: String, role: String,id: String) {
        self.id = id
        self.name = name
        self.role = role
    }

}

struct Class{
    let className: String
    let classDesc: String
    let classModule: Int
    let classEnrollment: String
    let classImg: UIImage
    let classImgString: String
    let classid: String
}

struct SelectedIdx{
    var indexPath: IndexPath
    static var selectedIdx = SelectedIdx(indexPath: IndexPath(row: 0, section: 0))
}

struct SelectedClass{
    var classPath: String
    static var selectedClass = SelectedClass(classPath: "")
}

struct SelectedModul{
    var modulPath: String
    static var selectedModul = SelectedModul(modulPath: "")
}

struct SelectedTes{
    var tesPath: String
    static var selectedTes = SelectedTes(tesPath: "")
}

struct Tugas{
    let tugasName: String
    let tugasDesc: String
    let tugasid: String
    let count: Int
}

struct Modul{
    let modulName: String
    let modulDesc: String
    let modulFile: String
    let modulid: String
    let classid: String
    let count: Int
}

struct Tes{
    let tesName: String
    let tesDesc: String
    let modulName: String
    let modulid: String
    let tesid: String
    let classid: String
    let timer: Double
    let displayedTime: String
    let count: Int
    
}

struct JumlahModul{
    var modulNum: Int
}

struct JumlahTugas{
    var tugasNum: Int
}

struct JumlahSoal{
    var soalNum: Int
}

struct TugasMurid{
    let muridName: String
    let tugasName: String
    let tugasDate: String
    let tugasFile: String
}

struct TesMurid{
    let muridName: String
    let tesScore: String
}

struct Soal{
    var soalQuestion: String
    var soalAnswerA: String
    var soalAnswerB: String
    var soalAnswerC: String
    var soalAnswerD: String
    var soalCorrectAns: String
    //function to change custom objects into dictionary so it can be read by Firestore
    func toDictionary() -> [String: Any] {
           return [
               "soalQuestion": soalQuestion,
               "soalAnswerA": soalAnswerA,
               "soalAnswerB": soalAnswerB,
               "soalAnswerC": soalAnswerC,
               "soalAnswerD": soalAnswerD,
               "soalCorrectAns": soalCorrectAns
           ] as [String: Any]
       }
}

