//
//  ScoreBoardCollectionViewLayout.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/7/1.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

class ScoreBoardCollectionViewLayout: UICollectionViewFlowLayout {
    
    
    var numRow:Int = 0;//行数
    var numCol:Int = 0;//列数
    var contentInsets: UIEdgeInsets =  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    //所有cell的布局属性
    var layoutAttributes: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]();
    
    override init() {
        super.init();
//        self.itemSize = CGSize(width: 250, height: 50);
//        self.scrollDirection = .horizontal
//        self.numRow = 4;
//        self.numCol = 4;
//        self.contentInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.itemSize = CGSize(width: 270, height: 50);
        self.scrollDirection = .horizontal
        self.numRow = 2;
        self.numCol = 2;
        self.contentInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
    }
    
    
    //计算布局
    override func prepare() {
        
        let numsection = self.collectionView!.numberOfSections;
        let itemNum: Int = self.collectionView!.numberOfItems(inSection: 0)
        layoutAttributes.removeAll();
        for i in 0..<numsection{
            for j in 0..<itemNum{
                let layout = self.layoutAttributesForItem(at: IndexPath(item: j, section: i))!;
                self.layoutAttributes.append(layout);
            }
        }
        
    }
    
    /**
     返回true只要显示的边界发生改变就重新布局:(默认是false)
     内部会重新调用prepareLayout和调用
     layoutAttributesForElementsInRect方法获得部分cell的布局属性
     */
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true;
    }
    /*
     根据indexPath去对应的UICollectionViewLayoutAttributes  这个是取值的，要重写，在移动删除的时候系统会调用改方法重新去UICollectionViewLayoutAttributes然后布局
     */
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        assert((self.collectionView!.frame.width-self.contentInsets.left - self.contentInsets.right) >= (self.itemSize.width*CGFloat(self.numRow)), "布局宽度不能超过父试图宽度")
        
        assert((self.collectionView!.frame.height-self.contentInsets.top - self.contentInsets.bottom) >= self.itemSize.height*CGFloat(self.numCol), "布局高度不能超过父视图高度")
        
        let layoutAttribute = super.layoutAttributesForItem(at: indexPath);
        
        //计算水平距离
        let hor_spacing = (self.collectionView!.frame.width - CGFloat(self.numRow) * self.itemSize.width - self.contentInsets.left - self.contentInsets.right) / CGFloat(self.numRow - 1);
        
        //计算垂直距离
        let ver_spacing = (self.collectionView!.frame.height - CGFloat(self.numCol) * self.itemSize.height - self.contentInsets.top - self.contentInsets.bottom) / CGFloat(self.numCol - 1);
        
        //计算x的位置
        var frame_x = CGFloat(indexPath.section) * self.collectionView!.frame.width + CGFloat(indexPath.row%self.numRow) * self.itemSize.width + self.contentInsets.left;
        frame_x += (hor_spacing*(CGFloat(indexPath.row%self.numRow)));
        
        
        
        //计算y的位置
        var frame_y = CGFloat((indexPath.row/self.numRow)) * self.itemSize.height + self.contentInsets.top;
        
        frame_y += (ver_spacing*CGFloat(indexPath.row/self.numRow));
        
        layoutAttribute?.frame = CGRect(x:frame_x, y:frame_y, width: self.itemSize.width, height: self.itemSize.height);
        
        return layoutAttribute;
        
    }
    
    override open var collectionViewContentSize: CGSize {
        
        return CGSize(width: (self.collectionView?.frame.width)! * CGFloat(self.collectionView!.numberOfSections), height: self.collectionView!.frame.height);
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return self.layoutAttributes
    }
    
    
}
