//
//  WXMessage.swift
//  bbm
//
//  Created by ericsong on 15/12/21.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit

import Foundation
//好友消息结构
struct WXMessage {
    var body = ""
    var from = ""
    var isComposing = false
    var isDelay = false
    var isMe = false
}

//状态结构
struct Zhuangtai {
    var name = ""
    var isOnline = false
    
}

protocol XxDL {
    func newMsg(_ aMsg:WXMessage)
}

protocol XxMainDL {
    func newMainMsg(_ aMsg:WXMessage)
}

protocol XxRecentDL {
    func newRecentMsg(_ aMsg:WXMessage)
}

//状态代理协议
protocol ZtDL {
    func isOn(_ zt:Zhuangtai)
    func isOff(_ zt:Zhuangtai)
    func meOff()
}


