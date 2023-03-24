//
//  OnBoardingController.swift
//  skripsi
//
//  Created by Hanz Christian on 27/02/23.
//

import UIKit
import Foundation
import FirebaseAuth

class OnBoardingController: UIViewController{
    
    
// MARK: - Variables & Outlet
    
    //IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    //Variables
    var pages: [OnboardingPages] = []
    var currentPage = 0 {
        didSet{
            if currentPage == pages.count - 1{
                signupBtn.isHidden = false
                loginBtn.isHidden = false
            }else{
                signupBtn.isHidden = true
                loginBtn.isHidden = true
            }
        }
    }
    let userModel = UserModel()
    var userRole = ""
    
}

// MARK: - View Life Cycle
extension OnBoardingController{
    
    override func viewWillAppear(_ animated: Bool) {
        userModel.fetchUser(completion: { user in
            self.userRole = user.role
            
        })
        
        if Core.shared.isNewUser(){
//            Core.shared.notNewUser()
            print("masuk sini gyan")
            UserDefaults.standard.set(userRole, forKey: "role")
        }
        else{
            print("ga masuk gyan")
            
            
            var mainAppViewController = UIStoryboard(name: "HomePage", bundle: nil).instantiateViewController(withIdentifier: "tabbarHomePage")

            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate,
               let window = sceneDelegate.window{
                window.rootViewController = mainAppViewController
                UIView.transition(with: window,
                                  duration: 0.25,
                                  options: .transitionCrossDissolve,
                                  animations: nil,
                                  completion: nil)

            }
//            self.performSegue(withIdentifier: "homepageSegue", sender: .none)
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
       pages = [
        OnboardingPages(title: "Akses Kelas", description: "Akses seluruh kelas yang dibentuk untuk membaca materi, mengerjakan tugas, dan melakukan tes", image: #imageLiteral(resourceName: "1st-Onboarding")),
        OnboardingPages(title: "Pilih Peran", description: "Masuk sebagai pengajar atau pelajar sesuai dengan peranmu dalam pembelajaran!", image: #imageLiteral(resourceName: "2nd-Onboarding")),
        OnboardingPages(title: "Lihat Jadwal", description: "Lupa ada jadwal apa saja yang akan terjadi hari ini? atau hari esok? Lihat seluruh jadwal yang telah kamu buat dibantu dengan notifikasi yang mengingatkanmu!", image: #imageLiteral(resourceName: "3rd-Onboarding")),
        OnboardingPages(title: "Sudah Siap?", description: "Apakah kamu sudah siap dengan pembelajaranmu? Daftar sekarang!", image: #imageLiteral(resourceName: "4th-Onboarding"))
        ]
        signupBtn.isHidden = true
        loginBtn.isHidden = true
    }
}

// MARK: - IBActions
extension OnBoardingController{
    @IBAction func signupPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "registerSegue", sender: self)
    }
    
    @IBAction func loginPressed(_ sender: UIButton){
        performSegue(withIdentifier: "loginSegue", sender: self)
    }
    @IBAction func pageValueChanged(_ sender: UIPageControl) {

    }
}

// MARK: - Private/Functions
extension OnBoardingController{
    private func btnShow(_ bool: Bool){
        signupBtn.isHidden = bool
        loginBtn.isHidden = bool
    }
    
}

// MARK: - Collection view
extension OnBoardingController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as! OnboardingCell

        cell.setup(pages[indexPath.row])
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        pageControl.currentPage = currentPage
    }
}

class Core{
    static let shared = Core()
    func isNewUser() -> Bool{
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    func notNewUser(){
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
}
