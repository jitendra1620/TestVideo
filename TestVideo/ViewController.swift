//
//  ViewController.swift
//  TestVideo
//
//  Created by Jitendra Singh on 27/07/19.
//  Copyright © 2019 Jitendra Singh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var indexPathForCurrentPlayingCell:IndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
extension ViewController:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlayerTableViewCell.reuseIdentifier, for: indexPath) as? PlayerTableViewCell else { return UITableViewCell.init() }
        cell.thumbNailImage = #imageLiteral(resourceName: "Screenshot 2019-07-05 at 9.47.25 PM.png")
        cell.row = indexPath.row
        cell.parentVC = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 172.5
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath){
        guard let cell = cell as? PlayerTableViewCell else { return }
        cell.thumbNailImage = #imageLiteral(resourceName: "Screenshot 2019-07-05 at 9.47.25 PM.png")
    }
}
extension ViewController{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        self.managePlayerAfterEndScroll()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.managePlayerAfterEndScroll()
    }
}
extension ViewController{
    func managePlayerAfterEndScroll() {
        let arrIndexPath = self.tableView.indexPathsForVisibleRows?.filter({ (indexPath) -> Bool in
            guard ((self.tableView.cellForRow(at: indexPath) as? PlayerTableViewCell) != nil) else { return false}
            return true
        })
        guard (arrIndexPath != nil) && !arrIndexPath!.isEmpty else {
            return
        }
        if let indexPath = indexPathForCurrentPlayingCell, (arrIndexPath?.contains(indexPath) ?? false){
            return
        }
        if self.handleFirstFullVisibleCellOnScroll(indexPathsForVisibleRows: arrIndexPath!){
            return
        }
        var indexPathToPlay:IndexPath!
        if (arrIndexPath!.count)%2 == 0{
            let firstIndexToCheck = arrIndexPath![(arrIndexPath!.count)/2 - 1]
            let secondIndexToCheck = arrIndexPath![(arrIndexPath!.count)/2]
            guard let cellFirst = self.tableView.cellForRow(at: firstIndexToCheck) as? PlayerTableViewCell else { return }
            guard let cellSecond = self.tableView.cellForRow(at: secondIndexToCheck) as? PlayerTableViewCell else { return }
            let yOfCellOne = self.tableView.convert(cellFirst.center, to: self.view).y
            let yOfCellTwo = self.tableView.convert(cellSecond.center, to: self.view).y
            let yOfTable = self.tableView.center.y
            indexPathToPlay = (yOfCellTwo - yOfTable) < (yOfTable - yOfCellOne) ? secondIndexToCheck : firstIndexToCheck
        }else{
            indexPathToPlay = arrIndexPath![(arrIndexPath!.count - 1)/2]
        }
        _ = arrIndexPath?.map({ (item) -> Void in
            guard let cell = self.tableView.cellForRow(at: item) as? PlayerTableViewCell else { return }
            if item == indexPathToPlay!{
                cell.strURL = "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
                indexPathForCurrentPlayingCell = indexPathToPlay!
                return
            }
            cell.thumbNailImage = #imageLiteral(resourceName: "Screenshot 2019-07-05 at 9.47.25 PM.png")
        })
    }
    func handleFirstFullVisibleCellOnScroll(indexPathsForVisibleRows:[IndexPath]) -> Bool {
        var focusCell: PlayerTableViewCell?
        indexPathsForVisibleRows.forEach { (indexPath) in
            if let cell = self.tableView.cellForRow(at: indexPath) as? PlayerTableViewCell {
                if focusCell == nil {
                    let rect = self.tableView.rectForRow(at: indexPath)
                    if self.tableView.bounds.contains(rect) {
                        cell.strURL = "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
                        focusCell = cell
                        indexPathForCurrentPlayingCell = indexPath
                    } else {
                        cell.thumbNailImage = #imageLiteral(resourceName: "Screenshot 2019-07-05 at 9.47.25 PM.png")
                    }
                } else {
                    cell.thumbNailImage = #imageLiteral(resourceName: "Screenshot 2019-07-05 at 9.47.25 PM.png")
                }
            }
        }
        if focusCell != nil{
            return true
        }
        return false
    }
}
extension ViewController{
}
