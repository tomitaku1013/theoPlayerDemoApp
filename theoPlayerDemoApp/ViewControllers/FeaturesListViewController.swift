//
//  FeaturesListViewController.swift
//  theoPlayerDemoApp
//
//  Created by Med on 9/27/18.
//  Copyright © 2018 Med Abida. All rights reserved.
//
//featuresListVC
import UIKit

class FeaturesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // load tableview dataset
    lazy var tableViewDataSet: [featureListItem] = {
        return loadFeaturesDataSet()
    }()
    
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
        cell.textLabel?.text = data.videoItem.title
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
        vc.videoItem = tableViewDataSet[indexPath.row].videoItem
        vc.videoPlayerFeatures = tableViewDataSet[indexPath.row].config
        self.present(vc, animated: true) {
            // deselect row automatically
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    
    
}


extension FeaturesListViewController {
    
    func prepareTableView(){
        tableViewOutlet.backgroundColor = UIColor.flatColor.navyBlue.accent1
    }
    
    
    //load dataset from the json file "videos_list.json"
    func loadFeaturesDataSet()->[featureListItem]{
        var dataset = [featureListItem]()
        if let path = Bundle.main.path(forResource: "features_list", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Array<Dictionary<String, Any>> {
                    for item in jsonResult {
                        guard let title = item["title"] as? String,
                            let path = item["path"] as? String,
                            let posterPath = item["posterPath"] as? String,
                            let config = item["config"] as? Array<String> else {
                                print("error in parsing data from Json File videos_list")
                                return dataset
                        }
                        
                        let videoItem = videoListItem(title: title, path: path, posterURL: posterPath)
                        let featureItem = featureListItem(videoListItem: videoItem, configs: config)
                        dataset.append(featureItem)
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



