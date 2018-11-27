
import UIKit
import WebKit
class DetailViewController: UIViewController {

    var linkUrl : String?
    
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
   
    
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        //linkUrl의 데이터가 있으면 - 예외가 발생하지 않도록 하기 위해서
        //이런 형태로 코드를 작성
        //java 코드라면 변수 != null
        if let addr = linkUrl{
            //URL 객체로 만들어 졌다면
            if let url = URL(string:addr){
                let request = URLRequest(url: url)
                //웹 뷰가 로딩
                webView.load(request)
                webView.uiDelegate = self
                webView.navigationDelegate = self
            }
                //URL 객체로 만드는데 실패했다면
            else{
                let alert = UIAlertController(title: "잘못된 URL입니다.", message: "", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .cancel)
                alert.addAction(ok)
                self.present(alert, animated: true)
        }
    }
        //linkUrl에 데이터가 없다면
        else{
            let alert = UIAlertController(title: "URL이 없습니다.", message: "", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .cancel)
            alert.addAction(ok)
            self.present(alert, animated: true)
        }
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

//DetailViewController의 기능확장 : extension
// 뒤에 있는 프로토콜은 Protocol : 인터페이스(메소드의 모양만 소유하는데 이클래스에는 이 메소드가 반드시 구현되어 있다라는 것을 확인하기 위한 용도)
extension DetailViewController : WKNavigationDelegate, WKUIDelegate{
    //웹 뷰가 로딩을 시작할 때 호출되는 메소드
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.indicatorView.startAnimating()
    }
    //웹 뷰가 로딩이 종료될 때 호출되는 메소드
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.indicatorView.startAnimating()
    }
    
    //웹 뷰가 로딩이 실패했을 때 호출되는 메소드 // 인터넷이 안될때라고 생각하면 됨
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.indicatorView.startAnimating()
    }
}
