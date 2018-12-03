
import UIKit

private let bottomVirtualArea: CGFloat = UIDevice.current.isBangScreen == true ? 34.0 : 0

class FaceThemeView: UIView {
    
    fileprivate let pageCtrlHeight: CGFloat = 15.0
    
    fileprivate let rowsCount: Int  = 3
    fileprivate let countInRow: Int = 8
    fileprivate let lineSpacing: CGFloat      = adaptationHeight(18)
    fileprivate let interitemSpacing: CGFloat = adaptationWidth(12)

    fileprivate var collectionView: UICollectionView!
    
    fileprivate var pageCtrl      : UIPageControl!
    
    /** 可根据表情包种类对以下两个变量做相应的修改 */
    fileprivate var emojiDatasource = [FaceModel]()
    fileprivate var faceTheme = FaceThemeModel()
    
    public weak var delegate: FaceThemeViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .white
    }
    
    private func setupView() {
        let layout = EmojiViewFlowLayout()
        layout.scrollDirection  = .horizontal
        layout.rowsCount        = rowsCount
        layout.countInRow       = countInRow
        layout.sectionNum       = emojiSections()
        layout.lineSpacing      = lineSpacing
        layout.interitemSpacing = interitemSpacing
        layout.emojItemSize     = faceTheme.themeStyle.itemSize
        //计算每个分区的左右边距
        let xOffset = (frame.size.width - CGFloat(countInRow) * faceTheme.themeStyle.itemSize.width - CGFloat(countInRow - 1) * interitemSpacing)/2.0
        //设置分区的内容偏移
        layout.edgeInsets = .init(top: 0, left: xOffset, bottom: 0, right: xOffset)

        if collectionView == nil {
            collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
            collectionView.isPagingEnabled = true
            collectionView.bounces = false
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.backgroundColor = .white
            collectionView.showsVerticalScrollIndicator = false
            collectionView.showsHorizontalScrollIndicator = false
            
            
            pageCtrl = UIPageControl.init()
            pageCtrl.pageIndicatorTintColor = .gray
            pageCtrl.currentPageIndicatorTintColor = .red

            addSubview(collectionView)
            addSubview(pageCtrl)
            
            collectionView.register(FaceThemeCell.self, forCellWithReuseIdentifier: "cellIdenfiter")
            
            collectionView.snp.makeConstraints {
                $0.left.equalTo(0)
                $0.right.equalTo(0)
                $0.top.equalTo(0)
                $0.height.equalTo(frame.size.height - pageCtrlHeight - bottomVirtualArea)
            }
            
            pageCtrl.snp.makeConstraints {
                $0.left.equalTo(self)
                $0.right.equalTo(self)
                $0.top.equalTo(collectionView.snp.bottom)
                $0.height.equalTo(pageCtrlHeight)
            }
        }else {
            collectionView.collectionViewLayout = layout
        }
        
        pageCtrl.numberOfPages = layout.sectionNum
    }
    
    private func emojiSections() ->Int {
        let itemsInSection = countInRow * rowsCount - 1;
        return (emojiDatasource.count / itemsInSection) + (emojiDatasource.count % itemsInSection == 0 ? 0 : 1);
    }
    
    // 计算当期 cell 的 row
    private func row(forCell indexPath: IndexPath) ->Int {
        return indexPath.row + indexPath.section * (countInRow * rowsCount - 1)
    }

    //MARK:
    //MARK: datasource
    func load(faceThemes: [FaceThemeModel]) {
        // 只考虑有系统表情包
        if let t = faceThemes.first {
            faceTheme = t
            emojiDatasource = faceTheme.faceModels
            
            let h = faceTheme.themeStyle.itemSize.height * 3 + lineSpacing * 4 + pageCtrlHeight + bottomVirtualArea
            let rect = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: h)
            frame = rect

            setupView()
        }
    }
    
}

extension FaceThemeView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return emojiSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemsInSection = countInRow * rowsCount - 1
        if((section + 1) * itemsInSection <= emojiDatasource.count) {
            return (itemsInSection + 1)
        }else{
            let countItems = emojiDatasource.count - section * itemsInSection;
            return (countItems + 1);
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 不考虑有多种 emoji 包
        let itemCount = self.collectionView(collectionView, numberOfItemsInSection: indexPath.section)

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellIdenfiter", for: indexPath) as! FaceThemeCell

        if indexPath.row == itemCount - 1 {
            // 最后一个cell是删除按钮
            cell.model = FaceModel.creatDelete()
        }else {
            cell.model = emojiDatasource[row(forCell: indexPath)]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //获取section cell总数
        let itemCount = self.collectionView(collectionView, numberOfItemsInSection: indexPath.section)
        
        let itemsInSection = countInRow * rowsCount - 1;
        let idx = indexPath.section * itemsInSection + indexPath.row

        if (indexPath.row == itemCount - 1){
            //最后一个cell是删除按钮
            delegate?.deleteEmoji()
        }else{
            //这里手动将表情符号添加到textField上
            delegate?.input(emoji: emojiDatasource[idx].faceTitle)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contenOffset = scrollView.contentOffset.x
        var page = contenOffset/scrollView.frame.size.width
        page += (Int(contenOffset) % Int(scrollView.frame.size.width)) == 0 ? 0:1
        pageCtrl.currentPage = Int(page)
    }

}

//MARK:
//MARK: Cell

class FaceThemeCell: UICollectionViewCell {
    
    lazy var deleteItem: UIImageView = {
        let item = UIImageView.init(image: UIImage.init(named: "emoji_delete"))
        return item
    }()
    
    lazy var contentItem: UILabel = {
        let l = UILabel.init()
        l.font = .systemFont(ofSize: 25)
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(deleteItem)
        addSubview(contentItem)
        
        deleteItem.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets.zero) }
        contentItem.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: FaceModel! {
        didSet {
            deleteItem.isHidden = !model.isDelete
            
            contentItem.text = model.faceTitle
        }
    }
}

//MARK:
//MARK: delegate

public protocol FaceThemeViewDelegate: class {
    func deleteEmoji()
    func input(emoji name : String)
}
