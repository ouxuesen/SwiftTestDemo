import Foundation
import UIKit

class MyCollectionCell: UICollectionViewCell {
    lazy var titleLable:UILabel = {
        let title = UILabel()
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 15)
        return title
    }()
    
    public func reloadCell(_ title:String) {
        if titleLable.superview == nil {
            contentView.addSubview(titleLable)
            titleLable.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
            }
        }
        titleLable.text = title
    }
    
}
 
class CollectionHeaderAndFooterView: UICollectionReusableView {
    lazy var titleLable:UILabel = {
          let title = UILabel()
          title.textColor = .black
          title.font = UIFont.systemFont(ofSize: 15)
          return title
      }()
      
      public func reloadHeaderAndFooter(_ title:String) {
          if titleLable.superview == nil {
              addSubview(titleLable)
              titleLable.snp.makeConstraints { (make) in
                  make.center.equalToSuperview()
              }
          }
          titleLable.text = title
      }
}
