import UIKit

class MovieListController: UITableViewController {
    //현재 출력중인 마지막 페이지 번호를 저장할 변수 선언
    var page = 1
   
    //데이터를 다운로드 받는 메소드
    func download(){
        let url = "http://swiftapi.rubypaper.co.kr:2029/hoppin/movies?version=1&page=\(page)&count=30&genreId=&order=releasedateasc"
        
        let apiURI : URL! = URL(string: url)
        
        //url이 제대로 만들어졌나 print(apiURI)
        
        //REST API를 호출
        let apidata = try! Data(contentsOf: apiURI)
        
        //데이터 전송 결과를 로그로 출력
        let log = NSString(data: apidata, encoding: String.Encoding.utf8.rawValue) ?? ""
        //print("API Result=\( log )")
        
        //예외처리
        do{
            //전체 데이터를 디셔너리로 만들기
            let apiDict = try JSONSerialization.jsonObject(with: apidata, options: []) as! NSDictionary
            //위까지는 똑같다 밑에부터 신경써야 한다.
            //hoppin 키의 값을 디셔너리로 가져오기
            let hoppin = apiDict["hoppin"] as! NSDictionary //"hoppin":{ 뒤에 {을 풀어주었다
            // print(hoppin)
            
            let movies = hoppin["movies"] as! NSDictionary
            //movies":{
            //print (movies)
            
            let ar = movies["movie"] as! NSArray //"movie":[
            
            //안에 있는 배열을 순회
            for row in ar{
                let imsi = row as! NSDictionary
                //하나하나 가져오는 것을 형변환 해주고
                
                var movie = MovieVO()
                movie.title = imsi["title"] as! String
                movie.generNames = imsi["genreNames"] as! String
                movie.linkUrl = imsi["linkUrl"] as! String
                movie.ratingAverage = (imsi["ratingAverage"] as! NSString).doubleValue
                movie.thumbnailImage = imsi["thumbnailImage"] as! String
                
                
                //이미지 URL을 가지고 이미지 데이터를 다운로드 받아서 저장
                let url = URL(string: movie.thumbnailImage!)
                //데이터 다운로드
                let imageData = try Data(contentsOf: url!)
                
                //저장
                movie.image = UIImage(data: imageData)
                
                //한바뀌 돌면 저장
               // self.list.append(movie)
                //이메일은 이렇게 // 최신께 제일 위로 들어온다.
                self.list.insert(movie, at: 0)
                
            }
            //데이터 확인
            //print(self.list)
            //테이블 뷰 재출력 // 굉장히 중요하다 이부분이  이것을 안하면 재출력 되지 않는다.
            self.tableView.reloadData()
            
            //전체 데이터를 표시한 경우에는 refreshController을 숨김
            let totalCount = (hoppin["totalCount"] as? NSString)!.integerValue
            if totalCount <= self.list.count{
                self.refreshControl?.isHidden = true
                //리프레쉬를 죽이면 이벤트가 다시 발생하지 않게 된다.
                self.refreshControl = nil
            }
            
        }catch{
            print("파싱 예외 발생")
        }
    }
    
    
    //refreshControl이 화면에 보여질 때 호출될 메소드
    @objc func handleRequest(_
        refreshControl:UIRefreshControl){
        //페이지 번호를 1 증가 시키고 데이터를 다시 받아오기
        self.page = self.page + 1
        self.download()
        //refreshControl 애니메이션 중지
        refreshControl.endRefreshing()
    }

    
    
    //파싱한 결과를 저장할 List 변수 - 지연생성 이용
    // 지연생성 - 처음부터 만들어두지 않고 처음 사용할 때 생성
    lazy var list : [MovieVO] = {
        var datalist = [MovieVO]()
        return datalist
    }()

    
    //인덱스에 해당하는 UIImage를 리턴하는 메소드 - 비동기 추가
    func getThumbnailImage(_ index : Int) -> UIImage{
        //배열에서 인덱스에 해당하는 데이터 가져오기
        var movie = self.list[index]
        //이미지가 있으면 바로 리턴
        if let savedImage = movie.image{
            return savedImage
        }else{
            //이미지가 없으면 다운로드 받아서 리턴
            let url : URL! = URL(string:movie.thumbnailImage!)
            let imageData = try! Data(contentsOf: url)
            movie.image = UIImage(data: imageData)
            return movie.image!
            
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "영화제목"
       
    }

    //화면에 뷰가 보여질 때 호출되는 메소드
    override func viewDidAppear(_ animated: Bool) {
        //추상 메소드(내용이 없는 메소드)가 아니면 상위 클래스의 메소드를 호출하고 기능 추가
        super.viewDidAppear(animated)
        //URL을 생성해서 다운로드 받기 // 웹주소는 url로 만들고 넣는다 . 주소 안되는 것을 입력하면 다운로드를 받으려고 하다가 실패를한다 url을 거쳐갔다가 하면 url 밑에 코드에서 분리를 할 수 있다.
       
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(MovieListController.handleRequest(_:)), for: .valueChanged)
        self.refreshControl?.tintColor = UIColor.red
        download()
        
        self.title = "영화 목록 보기"
        //self.navigationItem.title = "영화목록보기"
        
        
    }
    //섹션의 개수를 설정하는 메소드
    //없으면 1을 리턴하는 것으로 간주
    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }
    
    //그룹 별 행의 개수를 설정하는 메소드
    //없으면 에러 - 필수
    // TableViewController의 경우는 이 메소드도 없으면 1을 리턴한 것으로 간주
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.list.count
    }

  // 셀을 모양을 만드는 메소드 - 필수 // 없으면 에러가 난다.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //사용자 정의 셀 만들기
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        //행번호에 해당하는 데이터 찾기
        let movie = self.list[indexPath.row]
        //데이터 출력
        cell.lblTitle.text = movie.title!
        cell.lblGenre.text = movie.generNames!
        cell.lblRating.text = "\(movie.ratingAverage!)"
        //cell.thumbnailImage.image = movie.image!
        
        //비동기 적으로 이미지 출력
        DispatchQueue.main.async(execute: {
          cell.thumbnailImage.image =  self.getThumbnailImage(indexPath.row)
        })
        
        return cell
    }
    
    
    //셀의 높이를 설정하는 메소드 테이블 뷰를 쓰려면 해주는 것이좋다 짤리는 경우가 있어서
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80
    }

    //셀을 선택했을 때 호출되는 메소드
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //선택한 행 번호에 해당하는 데이터 찾아오기
        let movie = self.list[indexPath.row]
        //하위 뷰 컨트롤러 인스턴스 생성
        let detailViewController =
        self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        
        //데이터 넘겨주기
        detailViewController?.linkUrl = movie.linkUrl
        detailViewController?.title = movie.title
        //네비게이션으로 출력
        self.navigationController?.pushViewController(detailViewController!, animated: true)
    }
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
