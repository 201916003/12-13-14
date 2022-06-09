//
//  TableViewController.swift
//  Table
//
//  Created by BeomGeun Lee on 2021.
//

import UIKit

var items = ["책 구매", "철수와 약속", "스터디 준비하기"]
// 외부 변수인 items의 내용을 각각 "책 구매", "철수와 약속", "스터디 준비하기"로 지정한다.
var itemsImageFile = ["cart.png", "clock.png", "pencil.png"]
// 외부 변수인 이미지 파일은 각각 "cart.png", "clock.png" 입니다.

class TableViewController: UITableViewController {

    @IBOutlet var tvListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
            tvListView.reloadData()
    }
    // tvListView.reloadData 함수를 추가하여 테이블 뷰로 다시 불러옵니다. 다시 말해 추가된 내용을 목록으로 불러들입니다.
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    // 보통은 테이블 안에 섹션이 한 개이므로 numberOfSections의 리턴 값을 1로 합니다.

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    // 섹션당 열의 개수는 items의 개수이므로 tableView(_tableView:UITableView, numberOfRowsinSeciton section: Int) -> int 함수의 리턴 값을 items.count로 합니다.

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)

        cell.textLabel?.text = items[(indexPath as NSIndexPath).row]
        // 셀의 텍스트 레이블에 앞에서 선언한 items을 대입합니다. 그 내용은 "책 구매", "철수와 약속", "스터디 준비하기" 입니다.
        cell.imageView?.image = UIImage(named: itemsImageFile[(indexPath as NSIndexPath).row])
        // 셀의 이미지 뷰 앞에서 선언한 itemslmageFile("cart.png", clock.png", "pencil.png")을 대입합니다.

        return cell
    }
    


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            items.remove(at: (indexPath as NSIndexPath).row)
            itemsImageFile.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
           
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
    

    
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let itemToMove = items[(fromIndexPath as NSIndexPath).row]
        // 이동할 아이템의 위치를 itemToMove에 저장합니다.
        let itemImageToMove = itemsImageFile[(fromIndexPath as NSIndexPath).row]
        // 이동할 아이템의 이미지를 itemImageToMove에 저장합니다.
        items.remove(at: (fromIndexPath as NSIndexPath).row)
        // 이동할 아이템을 삭제합니다. 이때 삭제한 아이템 뒤의 아이템들의 인덱스가 재정렬됩니다.
        itemsImageFile.remove(at: (fromIndexPath as NSIndexPath).row)
        // 이동할 아이템의 이미지를 삭제합니다. 이때 삭제한 아이템 이미지 뒤에 아이템 이미지들의 인덱스가 재정렬 됩니다.
        items.insert(itemToMove, at: (to as NSIndexPath).row)
        // 삭제된 아이템을 이동할 위치로 삽입합니다. 또한 삽입한 아이템 뒤의 아이템들의 인덱스가 재정렬 됩니다.
        itemsImageFile.insert(itemImageToMove, at: (to as NSIndexPath).row)
        // 삭제된 아이템의 이미지를 이동할 위치로 삽입합니다. 또한 삽입한 아이템 이미지 뒤의 아이템 이미지들의 인덱스가 재정렬 됩니다.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "sgDetail" {
            let cell = sender as! UITableViewCell
            let indexPath = self.tvListView.indexPath(for: cell)
            let detailView = segue.destination as! DetailViewController
            detailView.reciveItem(items[((indexPath! as NSIndexPath).row)])
        }
    }
    

}

















