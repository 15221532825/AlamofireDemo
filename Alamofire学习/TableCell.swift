
//
//  TableCell.swift
//  Alamofire学习
//
//  Created by 飞翔 on 2020/4/5.
//  Copyright © 2020 飞翔. All rights reserved.
//

import UIKit
import SnapKit

class TableCell: UITableViewCell {
    
    lazy var nameLabel:UILabel = {
        
        let nameLabel =  self.createLabel(color: .black, font:UIFont.systemFont(ofSize: 14))
        return nameLabel
    }()
    
    lazy var customImageView:UIImageView = {
        let image = UIImageView()
        image.sizeToFit()
        return image
    }()
    
    lazy var contentLabel:UILabel = {
        let label = self.createLabel(color: .black, font: UIFont.systemFont(ofSize: 15))
        return label
    }()
    lazy var lineLabel:UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.backgroundColor = .white
        addViews()
        layout()
        
    }
    
    var obj:AlamofireObj?{
        
        willSet{
            
            if let alamObj = newValue{
                self.nameLabel.text = alamObj.name
                self.contentLabel.text = alamObj.text
                
                let url = URL.init(string: alamObj.header)
                
                DispatchQueue.global().async{
                    let data =  NSData.init(contentsOf: url!)
                    let image = UIImage.init(data: data! as Data)
                    
                    DispatchQueue.main.async {
                        self.customImageView.image = image
                    }
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TableCell{
    
    func addViews() {
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(customImageView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(lineLabel)
    }
    
    func layout(){
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(10)
        }
        
        customImageView.snp.makeConstraints { (make) in
            
            make.right.equalTo(-20)
            make.top.equalTo(10)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(customImageView.snp_bottomMargin).offset(10)
            make.right.equalTo(-10)
        }

        lineLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentLabel)
            make.top.equalTo(contentLabel.snp_bottomMargin).offset(10)
            make.height.equalTo(1)
            make.bottom.equalTo(-3)
        }
    }
    
    func createLabel(color:UIColor,font:UIFont) -> UILabel {
        
        let label = UILabel()
        label.textColor = color
        label.font = font
        label.numberOfLines = 0
        label.sizeToFit()
        //默认的是左对齐
        label.textAlignment = .left
        
        return label
    }
    
}

