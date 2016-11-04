//
//  RFCodeCountdownBtn.swift
//  bbm
//
//  Created by songgc on 2016/11/4.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit

///验证码倒计时
class RFCodeCountdownBtn:UIButton{
    ///验证码倒计时的起始秒数
    var maxTimer = 10
    
    var countDown = false{
        didSet{
            
            if oldValue != countDown{
                countDown ? startCountDown() : stopCountDown()
            }
        }
    }
    
    private var second = 0
    private var timer: Timer?
    ///倒计时显示
    private var timeLabel: UILabel!
    private var normalText: String!
    private var normalTextColor: UIColor!
    private var disabledText: String!
    private var disabledTextColor: UIColor!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setuptimeLabel()
    }
    
    deinit {
        countDown = false
    }
    
    // MARK: Setups
    private func setuptimeLabel() {
        normalText = title(for: .normal)!
        disabledText = title(for: .disabled)!
        normalTextColor = UIColor .red
        disabledTextColor = UIColor .lightGray
        setTitle("", for: .normal)
        setTitle("", for: .disabled)
        timeLabel = UILabel(frame:bounds)
        timeLabel.textAlignment = .center
        timeLabel.font = titleLabel?.font
        timeLabel.textColor = normalTextColor
        timeLabel.text = normalText
        addSubview(timeLabel)
    }
    
    // MARK: Private
    private func startCountDown() {
        second = maxTimer
        updateDisabled()
        
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(RFCodeCountdownBtn.updateCountdown), userInfo: nil, repeats: true)
    }
    
    private func stopCountDown() {
        timer?.invalidate()
        timer = nil
        updateNormal()
    }
    
    private func updateNormal() {
        isEnabled = true
        timeLabel.textColor = normalTextColor
        timeLabel.text = normalText
    }
    
    private func updateDisabled() {
        isEnabled = false
        timeLabel.textColor = disabledTextColor
        timeLabel.text = "重新发送" + String(second) + "'"
    }
    
    @objc private func updateCountdown() {
        //        print("second == \(second)")
        if second <= 1 {
            countDown = false
        } else {
            second = second - 1
            updateDisabled()
        }
    }
}
