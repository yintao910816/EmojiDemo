
import UIKit

class EmojiTextView: PlaceholderTextView {
    
    private var oldFont: UIFont!
    private var faceView: FaceThemeView!
    
    // 表情大小
    public var emojiSize: CGSize!
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        _init()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        _init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func _init() {
        emojiSize = CGSize.init(width: e_font.lineHeight, height: e_font.lineHeight)
        oldFont = e_font
        super.font = oldFont
        
        textContainerInset = UIEdgeInsets(top: 5, left: textContainer.lineFragmentPadding, bottom: 5, right: -textContainer.lineFragmentPadding)
        
        setupView()
    }
    
    private func setupView() {
        faceView = FaceThemeView()
        faceView.delegate = self
        faceView.load(faceThemes: loadFaceSource())
    }
    
    private func resetTextStyle() {
        let wholeRange = NSMakeRange(0, textStorage.length)
        textStorage.removeAttribute(NSAttributedString.Key.font, range: wholeRange)
        textStorage.addAttribute(NSAttributedString.Key.font, value: oldFont, range: wholeRange)
        font = oldFont
    }
    
    //MARK:
    //MARK: interface

    public var e_font: UIFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            oldFont = e_font
            super.font = e_font
        }
    }
    
    public func e_emojiShow() {
        inputView = faceView
        reloadInputViews()
        
        if isFirstResponder == false { becomeFirstResponder() }
    }
    
    public func e_emojiHidden(reload: Bool) {
        inputView = nil
        
        if reload == true { reloadInputViews() }
    }
    
}

//MARK:
//MARK: FaceThemeViewDelegate

extension EmojiTextView: FaceThemeViewDelegate {
    
    func deleteEmoji() { deleteBackward() }
    
    func input(emoji name: String) {
        textStorage.insert(NSAttributedString.init(string: name),at: selectedRange.location)
        selectedRange = NSMakeRange(selectedRange.location + 2, selectedRange.length)
        resetTextStyle()
        
        inputViewDelegate?.textViewDidChange(self)
    }
}
