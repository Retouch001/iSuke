//
//  ZQCodeTextField.swift
//  ZQCodeTextField
//
//  Created by zhangqq on 2018/3/2.
//  Copyright © 2018年 zhangqq. All rights reserved.
//



import UIKit

var inputString = ""

protocol RTCodeTextFieldDelegate :class {
    func codeView(_ inputString: String)
}

@IBDesignable class ZQCodeTextField: UIView {
    var codeTextField:UITextField?
    let codeCount: Int = 5
    var delegate: RTCodeTextFieldDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        exchangeMethod()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        exchangeMethod()
    }
    
    func commonInit(){
        let space:CGFloat! = 30.0
        let itemWidth = (frame.size.width - space*CGFloat(codeCount - 1))/CGFloat(codeCount)
        let itemHeight = frame.size.height
        
        for i in 1...codeCount {
            let item = UILabel()
            let x = CGFloat(i - 1) * (itemWidth + space)
            item.frame = CGRect.init(x: x, y: 0, width: itemWidth, height: itemHeight-1)
            item.textAlignment = .center
            item.backgroundColor = UIColor.clear
            item.font = UIFont.systemFont(ofSize: 35)
            item.tag = i
            item.text = ""
            addSubview(item)
            
            let line = UIView()
            line.backgroundColor = UIColor(hex: 0xdfdfdf)
            line.frame = CGRect.init(x: x, y: itemHeight - 1, width: itemWidth, height: 1)
            addSubview(line)
        }
        
        let item = self.viewWithTag(1)
        
        codeTextField = UITextField()
        codeTextField?.frame = (item?.frame)!
        codeTextField?.textAlignment = .center
        codeTextField?.delegate = self
        codeTextField?.keyboardType = .numberPad
        addSubview(codeTextField!)
    }
    
    func getHaveCodeItem() -> UILabel {
        for i in (1...codeCount).reversed() {
            let item = self.viewWithTag(i) as! UILabel
            if let text = item.text {
                if text.isEmpty == false {
                    return item
                }
            }
        }
        return self.viewWithTag(1) as! UILabel
    }
    
    func getEmptyCodeItem() -> UILabel {
        for i in 1...codeCount {
            let item = self.viewWithTag(i) as! UILabel
            if let text = item.text {
                if text.isEmpty {
                    return item
                }
            }
        }
        return self.viewWithTag(codeCount) as! UILabel
    }
    
    func clear() {
        for i in (1...codeCount).reversed() {
            let item = self.viewWithTag(i) as! UILabel
            item.text = ""
        }
        
        let label = self.viewWithTag(1) as! UILabel
        codeTextField?.frame = label.frame
        
        inputString = ""
    }
    
    override open func becomeFirstResponder() -> Bool {
        superview?.becomeFirstResponder()
        return (self.codeTextField?.becomeFirstResponder())!
    }
}

extension ZQCodeTextField:UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty == false {
            if inputString.count < 5{
                inputString = inputString.appending(string)
            }

            let item = self.getEmptyCodeItem()
            if item.text?.isEmpty == false {
                return false
            }
            item.text = string
            if item.tag != codeCount {
                let nextItem = self.viewWithTag(item.tag + 1) as! UILabel
                codeTextField?.frame = nextItem.frame
            }else{
                if(delegate != nil) {
                    delegate?.codeView(inputString)
                }
            }
        }
        return false
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         return false
    }
}

extension ZQCodeTextField {
    func exchangeMethod() {
        let originaMethod = class_getInstanceMethod(UITextField.classForCoder(), NSSelectorFromString("deleteBackward"))
        let swizzeMethod = class_getInstanceMethod(object_getClass(self), #selector(zq_DeleteBackward))
        method_exchangeImplementations(originaMethod!, swizzeMethod!)
    }
    
    @objc func zq_DeleteBackward() {
        if  let codeView:ZQCodeTextField = self.superview as? ZQCodeTextField {
            let item = codeView.getHaveCodeItem()
            if (item.text?.isEmpty)! == false {
                inputString.remove(at: inputString.index(before: inputString.endIndex))
                item.text = ""
                if item.tag != codeView.codeCount {
                    let nextItem = codeView.viewWithTag(item.tag) as! UILabel
                    self.frame = nextItem.frame
                }
            }
        }
    }
}
