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

struct Tugas{
    let tugasDate: String
    let tugasName: String
    let tugasFile: String
}

struct Modul{
    let modulName: String
    let modulDesc: String
    let modulFile: String
}

struct JumlahModul{
    var modulNum: Int
}

