import Foundation
import UIKit
public  enum FlowLyoutStyle {
      case verticalEqualWidth
      case HorizontalEqualHeight
      case VerticalEqualHeight
      case HorizontalGrid
}
 protocol MyFlowLayoutUIProtocol
{
     func columnCount() -> Int
     func rowCount() -> Int
     func columnMargin() -> CGFloat
     func rowMargin() -> CGFloat
     func edgeInset() -> UIEdgeInsets
}
 protocol MyFlowLayoutProtocol:MyFlowLayoutUIProtocol,AnyObject{
    func sizeForItem(_ indxPath:IndexPath) -> CGSize
    func sizeForHeaderViewInSection(_ indxPath:IndexPath) -> CGSize
    func sizeForFooterViewInSection(_ indxPath:IndexPath) -> CGSize
    
 
}

extension MyFlowLayoutProtocol {
    
   func sizeForHeaderViewInSection() -> CGSize {
          return CGSize.zero
      }
    func sizeForFooterViewInSection(_ indxPath:IndexPath) -> CGSize
      {
          return CGSize.zero
      }
    func columnCount() -> Int
    {
        return 2
    }
    func rowCount() -> Int
    {
        return 5
    }
     func columnMargin() -> CGFloat
     {
        return 10
    }
     func rowMargin() -> CGFloat
     {
        return 10
    }
     func edgeInset() -> UIEdgeInsets
     {
        return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}

public class MyFlowLayout: UICollectionViewLayout {
    weak var  Mydelegate:MyFlowLayoutProtocol?
    public var flowLayoutStyle:FlowLyoutStyle = .verticalEqualWidth;
    
   /** 存放所有cell的布局属性*/
    private lazy var attrsArray:Array = {
        return [UICollectionViewLayoutAttributes]()
    }()
    /** 存放每一列的最大y值*/
    private lazy var columnHeights = {
        return [CGFloat]()
    }()
    /** 存放每一行的最大x值*/
    private lazy var rowWidths = {
        return [CGFloat]()
    }()
    
    var maxColumnHeight:CGFloat = 0.0/** 内容的高度*/
    
    var maxRowWidth:CGFloat = 0.0 /** 内容的宽度*/
    
    
}
//重写系统方法
extension MyFlowLayout{
    public override func prepare() {
        super.prepare()
        if flowLayoutStyle == .verticalEqualWidth {
            maxColumnHeight = 0
            columnHeights.removeAll()
            for _ in 1...columnCount(){
                columnHeights.append(edgeInset().top)
            }
        }else if flowLayoutStyle == .HorizontalEqualHeight {
            maxRowWidth = 0
            rowWidths.removeAll()
            for _ in 1...rowCount(){
                rowWidths.append(edgeInset().left)
            }
            
        }else if flowLayoutStyle == .VerticalEqualHeight{
            maxColumnHeight = 0
            columnHeights.removeAll()
            columnHeights.append(edgeInset().top)
            maxRowWidth = 0
            rowWidths.removeAll()
            rowWidths.append(edgeInset().left)
            
        }else if flowLayoutStyle == .HorizontalGrid{
            maxColumnHeight = 0
            maxRowWidth = 0
            rowWidths.removeAll()
            for _ in 1...2{
                rowWidths.append(edgeInset().left)
            }
        }
         //清除之前数组
        attrsArray.removeAll()
        //开始创建每一组cell的布局属性
        if let sectionCount = collectionView?.numberOfSections {
             for section in 0...sectionCount-1 {
                       if let headerAttrs = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath.init(row: 0, section: section)) {
                           attrsArray.append(headerAttrs)
                       }
                      
                if  let rowCount = collectionView?.numberOfItems(inSection: section) {
                     for row in 0...rowCount-1 {
                                              let indexPath = IndexPath.init(row: row, section: section)
                                              if let attrs = layoutAttributesForItem(at: indexPath) {
                                                  attrsArray.append(attrs)
                                              }
                                              
                                          }
                }
                       if let footAttrs = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: IndexPath.init(item: 0, section: section)){
                           attrsArray.append(footAttrs)
                       }
                       
                    
                   }
        }
        
       
        
    }
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
         return attrsArray
    }
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        switch flowLayoutStyle {
        case .verticalEqualWidth:
             attrs.frame = self.itemFrameVerticalWaterFlow(indexPath)
        case .HorizontalEqualHeight:
            attrs.frame = self.itemFrameHorizontalWaterFlow(indexPath)
        case .VerticalEqualHeight:
            attrs.frame = self.itemFrameVerticalHWaterFlow(indexPath)
        case .HorizontalGrid:
            attrs.frame = self.itemFrameVerticalWaterFlow(indexPath)
  
        }
        return attrs
        
    }
    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) ->
        UICollectionViewLayoutAttributes? {
            let attri :UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: elementKind, with: indexPath)
            if elementKind == UICollectionView.elementKindSectionHeader {
                attri.frame = headerViewFrameOfVerticalWaterFlow(indexPath)
            }else if elementKind == UICollectionView.elementKindSectionFooter{
                attri.frame = FooterViewFrameOfVerticalWaterFlow(indexPath)
            }

        return attri
    }
//    func collectionViewContentSize() -> CGSize {
//        return CGSize.init(width: 0, height: maxColumnHeight+edgeInset().bottom)
//    }
    public override var collectionViewContentSize: CGSize{
        get{
          
            switch flowLayoutStyle {
                  case .verticalEqualWidth:
                        return CGSize.init(width: 0, height: maxColumnHeight+edgeInset().bottom)
                  case .HorizontalEqualHeight:
                    return CGSize.init(width: maxRowWidth + edgeInset().right, height: 0)
                  case .VerticalEqualHeight:
                        return CGSize.init(width: 0, height: maxColumnHeight+edgeInset().bottom)
                  case .HorizontalGrid:
                      return CGSize.init(width: 0, height: maxColumnHeight+edgeInset().bottom)
            
                  }
        }
    }
}

extension MyFlowLayout:MyFlowLayoutUIProtocol {
    
   public func columnCount() -> Int {
        if let columCont = Mydelegate?.columnCount(){
            return columCont
        }
        return 0
    }
   public func rowCount() -> Int {
        if let row = Mydelegate?.rowCount()
        {
            return row
        }
        return 0
    }
   public func rowMargin() -> CGFloat {
        if let margin  = Mydelegate?.rowMargin(){
            return margin
        }
        return 0
    }
   public func columnMargin() -> CGFloat {
        if let cMargin = Mydelegate?.columnMargin() {
            return cMargin
        }
        return 0
    }
    public func edgeInset() -> UIEdgeInsets {
        if let edge = Mydelegate?.edgeInset() {
                   return edge
               }
        return UIEdgeInsets.zero
    }

}
extension MyFlowLayout {
    //竖向瀑布流 item等宽不等高
    func itemFrameVerticalWaterFlow(_ indexPath:IndexPath) -> CGRect {
        let collectionW = collectionView?.frame.size.width ?? 0.0
        let w_temp = CGFloat(collectionW) - CGFloat(edgeInset().left) - CGFloat(edgeInset().right)
        let gaps = (CGFloat(columnCount()) - 1.0)*columnMargin()
        let w = (w_temp - gaps)/CGFloat(columnCount())
        guard let h = Mydelegate?.sizeForItem(indexPath).height else {
            return CGRect.zero
        }
        var destColumn = 0
        var minColumnHeight = columnHeights[0]
        for i in 1...columnCount()-1 {
             let columnHeight = columnHeights[i]
             if minColumnHeight>columnHeight {
                minColumnHeight = columnHeight
                destColumn = i
                }
         }
        let x = edgeInset().left + CGFloat(destColumn)*(w + columnMargin())
        var y =  minColumnHeight
        if y != edgeInset().top {
            y += rowMargin()
        }
     //更新最短那列的高度
        columnHeights[destColumn] = CGRect(x: x, y: y, width: w, height: h).maxY
     //记录内容的高度
        let columnHeight = columnHeights[destColumn]
        if maxColumnHeight < columnHeight {
            maxColumnHeight = columnHeight
        }
        
        return CGRect(x: x, y: y, width: w, height: h)
        
    }
    //竖向瀑布流 item等高不等宽
    func itemFrameVerticalHWaterFlow(_ indexPath:IndexPath) -> CGRect {
        guard let colloctionW = collectionView?.frame.size.width else { return CGRect.zero }
        var headViewSize = CGSize.zero
        if let headSize = Mydelegate?.sizeForFooterViewInSection(indexPath){
            headViewSize = headSize
        }
        guard let itemSize = Mydelegate?.sizeForItem(indexPath) else {
            return CGRect.zero
        }
        var x:CGFloat = 0
        var y:CGFloat = 0
        if colloctionW - rowWidths.first! - edgeInset().right > itemSize.width{
            if rowWidths.first! == edgeInset().left {
                x  = rowWidths.first!
            }else{
                x = rowWidths.first! + columnMargin()
            }
            if columnHeights.first! == edgeInset().top {
                y = columnHeights.first!
            }else if columnHeights.first! == edgeInset().top + headViewSize.height  {
                y = columnHeights.first! + rowMargin()
            }else{
                y = columnHeights.first! - itemSize.height
            }
            rowWidths.removeFirst()
            rowWidths.insert(x+itemSize.width, at: 0)
            if rowWidths.first! == edgeInset().left || columnHeights.first! == edgeInset().top + headViewSize.height  {
                columnHeights.removeFirst()
                columnHeights.insert(y+itemSize.height, at: 0)
            }
            
        }else{
            x =  edgeInset().left
            y = columnHeights.first! + rowMargin()
            rowWidths.removeFirst()
            rowWidths.insert( x+itemSize.width, at:0)
            columnHeights.removeFirst()
            columnHeights.insert(y + itemSize.height, at: 0)
        }
        maxColumnHeight = columnHeights.first!
        return CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
    }
    ////水平瀑布流 item等高不等宽
    func itemFrameHorizontalWaterFlow(_ indexPath:IndexPath) -> CGRect {
        guard let collectionH = collectionView?.frame.size.height else {
            return CGRect.zero
        }
        let w_temp = CGFloat(collectionH) - CGFloat(edgeInset().top) - CGFloat(edgeInset().bottom)
             let gaps = (CGFloat(rowCount()) - 1.0)*rowMargin()
             let h = (w_temp - gaps)/CGFloat(rowCount())
             guard let w = Mydelegate?.sizeForItem(indexPath).width else {
                 return CGRect.zero
             }
              var destColumn = 0
              var minColumnWidth = rowWidths[0]
              for i in 1...columnCount()-1 {
                   let columnWidth = rowWidths[i]
                   if minColumnWidth>columnWidth {
                      minColumnWidth = columnWidth
                      destColumn = i
                      }
               }
              var x =  minColumnWidth
              let y =  edgeInset().top + CGFloat(destColumn)*(h + rowMargin())
              if x != edgeInset().left {
                  x += columnMargin()
              }
              rowWidths[destColumn] = CGRect(x: x, y: y, width: w, height: h).maxY
           //记录内容的高度
              let columnHeight = columnHeights[destColumn]
              if maxColumnHeight < columnHeight {
                  maxColumnHeight = columnHeight
              }
            return CGRect(x: x, y: y, width: w, height: h)
        
    }
    func headerViewFrameOfVerticalWaterFlow(_ indexPath:IndexPath) -> CGRect {
        guard let size = Mydelegate?.sizeForHeaderViewInSection(indexPath) else {
            return CGRect.zero
        }
        let x:CGFloat =  0
       
        var  y:CGFloat = 0
        if maxColumnHeight == 0.0{
                           y = edgeInset().top
                      }else{
                          y = maxColumnHeight
                      }
                      guard let fotterHegit = Mydelegate?.sizeForFooterViewInSection(indexPath).height else {
                          return CGRect.zero
                      }
                      if fotterHegit == 0 {
                          if maxColumnHeight == 0.0{
                                    y = edgeInset().top
                                 }else{
                                     y = maxColumnHeight + rowMargin()
                                 }
                      }
                      maxColumnHeight = y + size.height
        if flowLayoutStyle == .verticalEqualWidth {
        
                   columnHeights.removeAll()
                   for _ in 0...columnCount()-1 {
                       columnHeights.append(maxColumnHeight)
                   }
        }else if flowLayoutStyle == .VerticalEqualHeight{
                rowWidths.removeFirst()
                rowWidths.insert(collectionView?.frame.size.width ?? 0, at: 0)
                maxColumnHeight = y + size.height
                columnHeights.removeFirst()
                columnHeights.insert(maxColumnHeight, at: 0)
        }
        
        return CGRect.init(origin: CGPoint(x: x, y: y), size: size)
    }
    func FooterViewFrameOfVerticalWaterFlow(_ indexPath:IndexPath) -> CGRect {
           guard let size = Mydelegate?.sizeForFooterViewInSection(indexPath) else {
               return CGRect.zero
           }
     if flowLayoutStyle == .verticalEqualWidth {
              let x:CGFloat =  0
              var  y:CGFloat = 0
             if size.height == 0.0{
                y = maxColumnHeight
                
             }else{
                y = maxColumnHeight + rowMargin()
        }
        maxColumnHeight = y + size.height
        columnHeights.removeAll()
        for _ in 0...columnCount()-1 {
            columnHeights.append(maxColumnHeight)
        }
        return CGRect.init(origin: CGPoint(x: x, y: y), size: size)
     }else if flowLayoutStyle == .VerticalEqualHeight {
         let x:CGFloat =  0
          var  y:CGFloat = 0
             if size.height == 0.0{
                y = maxColumnHeight
             }else{
                y = maxColumnHeight + rowMargin()
        }
        rowWidths.removeFirst()
        rowWidths.insert(collectionView?.frame.size.width ?? 0, at: 0)
        maxColumnHeight = y + size.height
        columnHeights.removeFirst()
         columnHeights.insert(maxColumnHeight, at: 0)
        return CGRect.init(origin: CGPoint(x: x, y: y), size: size)
     }
        return CGRect.zero
    }
}

