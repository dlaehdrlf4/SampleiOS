//
//  ViewController.swift
//  OpenApiprec
//
//  Created by 503-25 on 2018. 11. 26..
//  Copyright © 2018년 jh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func moveMemo(_ sender: Any) {
        let memoListVC = self.storyboard?.instantiateViewController(withIdentifier: "MemoListVC") as? MemoListVC
        memoListVC?.navigationItem.title = "메모목록"
        self.navigationController?.pushViewController(memoListVC!, animated: true)
    }
    @IBAction func moveMovie(_ sender: Any) {
        //하위 뷰 컨트롤러 객체 만들기
        let movieListController = self.storyboard?.instantiateViewController(withIdentifier: "MovieListController") as! MovieListController
        
        //하위 뷰 컨트롤러 객체 만들기
       
        let theaterListController =
            self.storyboard?.instantiateViewController(withIdentifier: "TheaterListController") as! TheaterListController
        
        
        
        //네비게이션 컨트롤러가 있을 때는 바로 푸시를 하면 됩니다.
        //없을 때는 네비게이션 컨트롤러를 만들고 네비게이션 컨트롤러를 present로 출력
        //뒤로 버튼을 새로 만들기
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "메인화면", style: .done, target: nil, action: nil)
        
        //탭 바 컨트롤러 생성
        let tabbarController = UITabBarController()
        tabbarController.viewControllers = [movieListController, theaterListController]
        
        
        
        // 네비게이션으로 이동
        self.navigationController?.pushViewController(tabbarController, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }


}

