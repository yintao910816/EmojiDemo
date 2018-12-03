
import UIKit

class InputBoxView: UIView  {
    private let defaultFontSize: CGFloat = 15
    private let defaultTextColor = UIColor.black
    
    // 选择emoji表情
    private var emojiButton     : UIButton!
    // 发送
    private var sendButton     : UIButton!

    private var topLine         : UIView!
    
    private var inputTf     : EmojiTextView!
    
    weak var actionDelegate: InputBoxViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    //MARK:
    //MARK: UI 设置
    private func setupUI() {
        topLine = UIView()
        topLine.backgroundColor = UIColor(red : 230 / 255.0 ,green : 230 / 255.0 ,blue : 230 / 255.0 ,alpha : 1)
        
        inputTf = EmojiTextView()
        inputTf.font = UIFont.systemFont(ofSize: defaultFontSize)
        inputTf.textColor = defaultTextColor
        inputTf.backgroundColor = UIColor(red : 247 / 255.0 ,green : 247 / 255.0 ,blue : 247 / 255.0 ,alpha : 1)
        inputTf.layer.cornerRadius = 3
        inputTf.clipsToBounds = true
        inputTf.returnKeyType = .send
        inputTf.inputViewDelegate = self
        
        emojiButton = UIButton.init(type: .system)
        emojiButton.tintColor = UIColor.clear
        emojiButton.setBackgroundImage(UIImage.init(named: "keyboard_face"), for: .normal)
        emojiButton.addTarget(self, action: #selector(showEmojiView(_:)), for: .touchUpInside)
        
        sendButton    = UIButton.init(type: .custom)
        sendButton.setTitle("发送", for: .normal)
        sendButton.titleLabel?.font   = UIFont.systemFont(ofSize: defaultFontSize)
        sendButton.layer.cornerRadius = 14.5
        sendButton.clipsToBounds      = true
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        
        addSubview(topLine)
        addSubview(inputTf)
        addSubview(sendButton)
        addSubview(emojiButton)
        
        setSend(userInteraction: false)
        
        topLine.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.top.equalTo(self)
            make.height.equalTo(1)
        }
        
        emojiButton.snp.makeConstraints { make in
            make.left.equalTo(self).offset(10)
            make.centerY.equalTo(self.snp.centerY).offset(0.5)
            make.size.equalTo(CGSize.init(width: 29, height: 29))
        }
        
        sendButton.snp.makeConstraints { make in
            make.right.equalTo(self).offset(-10)
            make.centerY.equalTo(emojiButton.snp.centerY).offset(0.5)
            make.height.equalTo(29)
            make.width.equalTo(60)
        }

        inputTf.snp.makeConstraints { make in
            make.left.equalTo(emojiButton.snp.right).offset(10)
            make.right.equalTo(sendButton.snp.left).offset(-10)
            make.centerY.equalTo(emojiButton.snp.centerY)
            make.height.equalTo(emojiButton.snp.height)
        }
    }

    //MARK:
    //MARK: user actions

    @objc private func submit() {
        actionDelegate?.send(input: inputTf.text)
        
        inputTf.text = nil
        inputTf.placeholder = placeholder
        inputTf.resignFirstResponder()
        
        emojiButton.isSelected = false
        inputTf.e_emojiHidden(reload: false)
    }
    
    @objc func showEmojiView(_ button: UIButton) {
        if button.isSelected == true {
            inputTf.e_emojiHidden(reload: true)
        }else {
            inputTf.e_emojiShow()
        }
        button.isSelected = !button.isSelected
    }
    
    private func setSend(userInteraction isEnable: Bool) {
        if isEnable == false {
            sendButton.backgroundColor = UIColor(red : 178 / 255.0 ,green : 178 / 255.0 ,blue : 178 / 255.0 ,alpha : 1)
            sendButton.isUserInteractionEnabled = false
        }else {
            sendButton.backgroundColor = UIColor(red : 86 / 255.0 ,green : 142 / 255.0 ,blue : 214 / 255.0 ,alpha : 1)
            sendButton.isUserInteractionEnabled = true
        }
    }

    //MARK:
    //MARK: interface

    public func startInput() {
        if inputTf.isFirstResponder == false {
            inputTf.becomeFirstResponder()
        }
    }

    public var textFont: CGFloat? {
        didSet {
            inputTf.font = UIFont.systemFont(ofSize: (textFont ?? defaultFontSize))
        }
    }
    
    public var textColor: UIColor? {
        didSet {
            inputTf.textColor = textColor ?? defaultTextColor
        }
    }
    
    public var placeholder: String? {
        didSet {
            inputTf.placeholder = placeholder
        }
    }
    
}

extension InputBoxView: PlaceholderTextViewDelegate {
    
    func textViewDidChange(_ textView: PlaceholderTextView) {
        setSend(userInteraction: inputTf.text.count > 0)
    }
}

protocol InputBoxViewDelegate: class {
    
    func send(input content: String)
}
