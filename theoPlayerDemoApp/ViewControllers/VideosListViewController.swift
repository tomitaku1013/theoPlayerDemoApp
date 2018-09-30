//
//  VideosListViewController.swift
//  theoPlayerDemoApp
//
//  Created by Med on 9/27/18.
//  Copyright © 2018 Med Abida. All rights reserved.
//
//videosListVC
import UIKit

class VideosListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    // load tableview dataset
    lazy var tableViewDataSet: [videoListItem] = {
        return loadVideosDataSet()
    }()
    
    // UI elemets
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // prepare tableViewOutlet UI
        prepareTableView()
        
        
    }
    
    //MARK - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataSet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = tableViewDataSet[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "tCell")! as UITableViewCell
        cell.textLabel?.text = data.title
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.flatColor.navyBlue.accent1
        }else{
            cell.backgroundColor = UIColor.flatColor.navyBlue.accent2
        }
        cell.textLabel?.textColor = UIColor.flatColor.yellow.accent1
        return cell
    }
    
    
    //MARK - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "playerVC") as! PlayerViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.videoItem = tableViewDataSet[indexPath.row]
        self.present(vc, animated: true) {
            // deselect row automatically
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    
    
    

}




extension VideosListViewController {
    
    func prepareTableView(){
        tableViewOutlet.backgroundColor = UIColor.flatColor.navyBlue.accent1
    }
    
    
    //load dataset from the json file "videos_list.json"
    func loadVideosDataSet()->[videoListItem]{
        var dataset = [videoListItem]()
        if let path = Bundle.main.path(forResource: "videos_list", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Array<Dictionary<String, String>> {
                    for item in jsonResult {
                        guard let title = item["title"],
                        let path = item["path"] else{
                            print("error in parsing data from Json File videos_list")
                            return dataset
                        }
                        
                        let videoItem = videoListItem(title: title, path: path)
                        dataset.append(videoItem)
                    }
                }
            } catch let err{
                print(err)
            }
        }else{
            print("Path not found")
        }
        return dataset
    }
    
    
    
    
}



