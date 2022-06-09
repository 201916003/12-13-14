

import UIKit

class DetailViewController: UIViewController {
    
    var receiveItem = ""
    // Main View에서 받을 텍스트를 위해 변수 receive Item를 선업합니다.

    @IBOutlet var lblItem: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        lblItem.text = receiveItem
        // 뷰가 노출될 때마다 이 내용을 레이블의 텍스트로 표시합니다.
    }
    
    
    func reciveItem(_ item: String)
    // Main View에서 변수를 받기 위한 함수를 추가합니다.
    {
        receiveItem = item
    }
    

}


