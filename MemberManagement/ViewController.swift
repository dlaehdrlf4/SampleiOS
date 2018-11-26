import UIKit

//swift에서 import는 네임스페이스를 가져오는 역할(라이브러리를 가져오는게 아니다.)
//java에서 import는 이름을 줄여쓰기 위한 역할
//c에서 include는 파일의 내용을 가져오는 역할
//c나 swift에서는 import나 include를 안하면 그 기능을 사용할 수 없음
//java는 import하지 않고 전체 이름을 이용해서 사용할 수 있음

//html에서 script src도 c언어의 include 개념입니다.

//Alamofire는 URL 통신을 쉽게 할 수 있도록 해주는 외부 라이브러리 항상 설치해서 써야한다.

import Alamofire

class ViewController: UIViewController {

    
    @IBOutlet weak var loginbtn: UIButton!
    @IBAction func login(_ sender: Any) {
        if loginbtn.title(for : .normal) == "로그인"{
            //로그인 대화상자 생성
            let alert = UIAlertController(title: "로그인", message: nil, preferredStyle: .alert)
            
            //대화상자에 입력을 받을 수 있는 텍스트 필드를 2개 추가
            alert.addTextField(){(tf) in tf.placeholder = "아이디를 입력하세요"}
            alert.addTextField{(tf) in tf.placeholder = "비밀번호를 입력하세요"
                tf.isSecureTextEntry = true}
            
            //버튼 생성
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            alert.addAction(UIAlertAction(title: "로그인", style: .default){
                (_) in
                let id = alert.textFields![0].text
                let pw = alert.textFields![1].text
                print(id)
                print(pw)
                //웹에 요청
                let request = Alamofire.request("http://192.168.0.235:8080/server/member/login?id=\(id!)&pw=\(pw!)", method:.get, parameters:nil)
                
                //결과 사용
                request.responseJSON{
                    response in
                    //결과확인
                    //print(response.result.value!)
                   if let jsonObject = response.result.value as? [String:Any]{
                        //result 키의 내용 가져오기
                        let result = jsonObject["result"] as! NSDictionary
                        let id = result["id"] as! NSString
                        if id == "NULL"{
                            self.title = "로그인 실패"
                        }else{
                            //로그인 성공했을 때 로그인 정보 저장
                            self.appDelegate.id = id as String
                            self.appDelegate.nickname =
                                (result["nickname"] as! NSString) as String
                            self.appDelegate.image =
                                (result["image"] as! NSString) as String
                            self.title = "\(self.appDelegate.nickname!)님 로그인"
                            self.loginbtn.setTitle("로그아웃", for:.normal)
                        }
                    }
                }
            })
            //안쓸꺼다 하면  (_)
            
            //로그인 대화상자를 출력
            self.present(alert, animated: true)
        }else{
            //로그인 정보를 삭제
            appDelegate.id = nil
            appDelegate.nickname = nil
            appDelegate.image = nil
            //네비게이션 바의 타이틀과 버튼의 타이틀을 변경
            self.title = "로그인이 안된 상태"
            self.loginbtn.setTitle("로그인", for: .normal)
        }
    }
    //AppDelegate 객체에 대한 참조 변수
    var appDelegate : AppDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //AppDelegate에 대한 참조를 생성
        appDelegate = UIApplication.shared.delegate as? AppDelegate
    }

    override func viewWillAppear(_ animated: Bool) {
        //상위 클래스의 메소드 호출
        super.viewWillAppear(animated)
        //로그인 여부 확인
        if appDelegate.id == nil{
            self.title = "로그인이 되어 있지 않음"
            self.loginbtn.setTitle("로그인", for: .normal)
        }else{
            self.title = "로그인 성공 상태"
            self.loginbtn.setTitle("로그아웃", for: .normal)
        }
    }

}

