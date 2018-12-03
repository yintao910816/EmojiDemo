//
//  FaceThemeModel.swift
//  EmojiDemo
//
//  Created by sw on 02/12/2018.
//  Copyright © 2018 sw. All rights reserved.
//

import UIKit

func adaptationWidth(_ width: CGFloat) -> CGFloat {
    return (UIScreen.main.bounds.size.width/375.0) * width
}

func adaptationHeight(_ height: CGFloat) -> CGFloat {
    return (UIScreen.main.bounds.size.height/667.0) * height
}

enum FaceThemeStyle {
    case systemEmoji  //30*30
    case customEmoji  //40*40
    case gif          //60*60
}

extension FaceThemeStyle {
    
    var itemSize: CGSize {
        get {
            switch self {
            case .systemEmoji:
                let w = min(adaptationHeight(32), 32)
                return .init(width: w, height: w)
            case .customEmoji:
                return .init(width: 40, height: 40)
            case .gif:
                return .init(width: 60, height: 60)
            }
        }
    }
}

class FaceModel {
    
    /** 表情标题 */
    var faceTitle: String = ""
    /** 表情图片 */
    var faceIcon: String  = ""
    /** 最后一个删除按钮 */
    var isDelete: Bool = false

    // 创建最后一个删除按钮
    class func creatDelete() ->FaceModel {
        let m = FaceModel()
        m.isDelete = true
        return m
    }
}

class FaceThemeModel {
    
    var themeStyle: FaceThemeStyle = .systemEmoji
    
    var themeIcon: String = ""
    
    var faceModels        = [FaceModel]()
}
