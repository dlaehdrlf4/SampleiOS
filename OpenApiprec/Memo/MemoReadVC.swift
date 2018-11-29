//
//  MemoReadVC.swift
//  OpenApiprec
//
//  Created by 503-25 on 2018. 11. 28..
//  Copyright © 2018년 jh. All rights reserved.
//

import UIKit

class MemoReadVC: UIViewController {

    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var contents: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    //데이터를 넘겨발을 변수
    var memo : MemoVO?
    //가는거는 viewDidLoad나 어피얼이나 상관없고  리스트는 떠있었으니까 viewWillappear
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.subject.text = memo?.title
        self.contents.text = memo?.contents
        self.img.image = memo?.image
        
        //넘어오는거 확인
        //print(memo)
       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
