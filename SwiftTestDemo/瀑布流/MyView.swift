
import UIKit

public class MyViewController : UIViewController {
    var flowStyle:FlowLyoutStyle =  .VerticalEqualHeight
    lazy var souceArray:Array = {
        return [Int]()
    }()
        lazy var mycollection:UICollectionView = {
           
            let myFlowlayout = MyFlowLayout()
            myFlowlayout.flowLayoutStyle = flowStyle
            myFlowlayout.Mydelegate = self
            let collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: myFlowlayout)
            collection.delegate = self
            collection.dataSource = self
            collection.register(MyCollectionCell.self, forCellWithReuseIdentifier: "MyCollectionCellIdentifier")
            collection.register(CollectionHeaderAndFooterView.self,forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:"sectionHeader")
             collection.register(CollectionHeaderAndFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier:"sectionHeader")
            return collection
        }()
        
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mycollection)
      
        mycollection.backgroundColor = .red
        for _ in 0...30{
            souceArray.append(Int(arc4random()%200+30))
        }
        if flowStyle == .HorizontalGrid{
            mycollection.snp.makeConstraints { (make) in
                make.top.left.right.equalToSuperview().inset(UIEdgeInsets.zero)
                make.height.equalTo(100)
                  }
        }else {
            mycollection.snp.makeConstraints { (make) in
                      make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
                  }
        }
    }
}
extension MyViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  colletcionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionCellIdentifier", for: indexPath) as! MyCollectionCell
        colletcionCell.reloadCell("\(indexPath.section)---"+"\(indexPath.row)")
        colletcionCell.backgroundColor = .white
        return colletcionCell
    }
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
       let hearder = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as! CollectionHeaderAndFooterView
        hearder.reloadHeaderAndFooter(kind)
        hearder.backgroundColor = .blue
       return hearder
    }

}
extension MyViewController:MyFlowLayoutProtocol{
    func columnCount() -> Int{
        return 3
    }
     func rowCount() -> Int
     {
        return 5
    }
    func columnMargin() -> CGFloat{
        return 5.0
    }
     func rowMargin() -> CGFloat
     {
        return 5.0
    }
     func edgeInset() -> UIEdgeInsets
     {
        if flowStyle == . HorizontalGrid{
            return UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20)
        }else{
            return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    func sizeForItem(_ indxPath:IndexPath) -> CGSize
    {
        /**     case verticalEqualWidth
         case HorizontalEqualHeight
         case VerticalEqualHeight
         case HorizontalGrid*/
        if flowStyle == .verticalEqualWidth {
            return CGSize.init(width: 0, height:souceArray[indxPath.section*10+indxPath.row])
        }else if flowStyle == .HorizontalEqualHeight{
            return CGSize.init(width: souceArray[indxPath.section*10+indxPath.row], height: 0)
        }else if flowStyle == .VerticalEqualHeight{
            return CGSize.init(width: souceArray[indxPath.section*10+indxPath.row], height: 100)
        }else if flowStyle == .HorizontalGrid{
            return CGSize.zero
        }else{
            return CGSize.zero
        }
        
    }
     func sizeForHeaderViewInSection(_ indxPath:IndexPath) -> CGSize
     {
        return CGSize.init(width: view.frame.size.width, height: 40)
    }
     func sizeForFooterViewInSection(_ indxPath:IndexPath) -> CGSize
     {
         return CGSize.init(width: view.frame.size.width, height: 40)
    }
     
}
