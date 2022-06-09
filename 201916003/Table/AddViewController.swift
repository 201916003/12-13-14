

import UIKit

class AddViewController: UIViewController {

    @IBOutlet var tfAddItem: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func btnAddItem(_ sender: UIButton) {
        items.append(tfAddItem.text!)
        // items에 텍스트 필드의 텍스트 값을 추가합니다.
        itemsImageFile.append("clock.png")
        // itemsimageFile에는 무조건 'clock.png' 파일을 추가합니다.
        tfAddItem.text=""
        //텍스트 필드의 내용을 지웁니다.
        _ = navigationController?.popViewController(animated: true)
        //루트 뷰 컨트롤러, 즉 테이블 뷰로 돌아갑니다.
    }
    

}






