
import UIKit

class PlaceholderTextView: UITextView, UITextViewDelegate {
    
    fileprivate let placeholderColor = UIColor.init(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1)

    weak var inputViewDelegate: PlaceholderTextViewDelegate?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        _initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        _initialize()
    }
    
    override var font: UIFont? {
        didSet {
            placeholderLabel.font = font
        }
    }
    
    private func _initialize() {
        delegate = self
        showsVerticalScrollIndicator   = false
        showsHorizontalScrollIndicator = false
        returnKeyType                  = .done
                
        placeholderLabel.font = font
        placeholderLabel.textColor = placeholderColor
        addSubview(placeholderLabel)
        
        placeholderLabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(5)
            make.right.equalTo(self).offset(-5)
            make.top.equalTo(self).offset(5)
            make.bottom.equalTo(self).offset(-5)
        }
    }

    //MARK:
    //MARK: placeholder 设置

    private var placeholderLabel: UILabel = {
        let lbl = UILabel.init()
        lbl.textAlignment = .natural
        lbl.numberOfLines = 0
        return lbl
    }()
    
    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    var placeholderCenter: Bool! = false {
        didSet {
            if placeholderCenter == true {
                placeholderLabel.snp.remakeConstraints({ make in
                    make.centerY.equalTo(self.snp.centerY)
                    make.left.equalTo(self).offset(5)
                    make.right.equalTo(self).offset(-5)
                })
            }else {
                placeholderLabel.snp.remakeConstraints { make in
                    make.left.equalTo(self).offset(5)
                    make.right.equalTo(self).offset(-5)
                    make.top.equalTo(self).offset(5)
                    make.bottom.equalTo(self).offset(-5)
                }
            }
        }
    }
    
    //MARK:
    //MARK: UITextViewDelegate
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        placeholderLabel.isHidden = true
        return inputViewDelegate?.inputViewShouldBeginEditing(self) ?? true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        inputViewDelegate?.inputViewDidEndEditing(self)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            placeholderLabel.isHidden = false
            textView.resignFirstResponder()
        }
        return inputViewDelegate?.inputView(self, shouldChangeTextIn: range, replacementText: text) ?? true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        inputViewDelegate?.textViewDidChange(self)
    }
    
}

protocol PlaceholderTextViewDelegate: class {
    
    func inputView(_ inputView: PlaceholderTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    
    func inputViewShouldBeginEditing(_ inputView: PlaceholderTextView) -> Bool
    
    func inputViewDidEndEditing(_ inputView: PlaceholderTextView)
    
    func textViewDidChange(_ textView: PlaceholderTextView)
}

extension PlaceholderTextViewDelegate {
    
    func inputView(_ inputView: PlaceholderTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    func inputViewShouldBeginEditing(_ inputView: PlaceholderTextView) -> Bool {
        return true
    }
    
    func inputViewDidEndEditing(_ inputView: PlaceholderTextView) { }
    
    func textViewDidChange(_ textView: PlaceholderTextView) { }
}
