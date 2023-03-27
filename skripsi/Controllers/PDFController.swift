//
//  PDFController.swift
//  skripsi
//
//  Created by Hanz Christian on 27/03/23.
//

import Foundation
import UIKit
import PDFKit

class PDFController: UIViewController{
    
    @IBOutlet weak var pdfView: PDFView!
    
    let url: URL
    
    //initialize the URL from MuridClassController
    init(url: URL){
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    //error
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("masuk harusnya")
        let pdfView = PDFView(frame: view.bounds)
        pdfView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        pdfView.backgroundColor = .white
        pdfView.document = PDFDocument(url: url)
        view.addSubview(pdfView)
        
    }
}
