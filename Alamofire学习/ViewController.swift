//
//  ViewController.swift
//  Alamofire学习
//
//  Created by 飞翔 on 2020/4/5.
//  Copyright © 2020 飞翔. All rights reserved.
//

import UIKit
import MJRefresh

class ViewController: UIViewController {
    
    lazy var dataAry : NSMutableArray = {
    
        let dataAry = NSMutableArray()
        return dataAry
    }()
    
    lazy var tableView:UITableView = {
        
        let tableView = UITableView.init(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(TableCell.self, forCellReuseIdentifier: self.cellID)
        
        return tableView;
    }()
    
    lazy var indicatorView:UIActivityIndicatorView = {
        
        let indicatorView = UIActivityIndicatorView()
        indicatorView.center = self.view.center
        return indicatorView
    }()
    
    let cellID = "CELLID"
    var index = 1;
    var isFirst = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(indicatorView)
        
        addRefresh()
        loadData()
    }
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! TableCell
        
        let obj = self.dataAry[indexPath.row] as! AlamofireObj
        cell.obj = obj
        
        return cell
    }
    
}
extension ViewController{
    
    func addRefresh() {
        
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.index = 1
            self.loadData()
        });
        
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
           
            self.index+=1;
            self.loadData()
        });
        self.tableView.mj_header.isHidden = true
        self.tableView.mj_footer.isHidden = true
        
    }
    func loadData(){
        
        let urlString = "https://api.apiopen.top/getJoke?page=\(self.index)&count=10&type=text"
        
        self.indicatorView.isHidden = self.tableView.mj_header.isHidden == false
        self.indicatorView.startAnimating()
        
        AlamofireObj.loadHttpData(urlString,self.index,self.dataAry) { (dataAry) in
        
            if self.indicatorView.isHidden==false{
                self.indicatorView.stopAnimating()
            }
            
            self.tableView.mj_header.isHidden = false
            self.tableView.mj_footer.isHidden = false
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            self.dataAry = dataAry
            
            self.tableView.reloadData()
        }
        
    }
}
