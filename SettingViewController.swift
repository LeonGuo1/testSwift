//
//  SettingViewController.swift
//  Drone
//
//  Created by BC600 on 16/1/21.
//  Copyright © 2016年 fimi. All rights reserved.
//

import UIKit
import Reachability
import CocoaLumberjack

class SettingViewController: StackSubViewController {
    
//    private let loadingView = LoadingView()
//    private let tableView = UITableView(frame: CGRect.zero, style: .Grouped)
//    private var sections: [[[String: AnyObject]]]!
    
    private var rcOperationMode = RCOperationMode.USA {
        didSet {
            let indexPath = NSIndexPath(forRow: 1, inSection: 1)
            updateTableViewCellSwitching(tableView.cellForRowAtIndexPath(indexPath))
        }
    }
    
    // 新手模式
    private var isNoviceMode = false {
        didSet {
            tableView.reloadData()
            if !isNoviceMode {
                queryFlySpeed()
            }
        }
    }
    
    // VPU
    private var isLocationMode = false {
        didSet{
            tableView.reloadData()
        }
    }
    
    // 姿态模式
    private var isPostureMode = false {
        didSet{
            tableView.reloadData()
        }
    }
    
    private var aloftadv = false {
        didSet{
            if aloftadv != oldValue {
                tableView.reloadData()
                
            }
        }
    }
    
    private var flyDistance = false {
        didSet{
            let flyDistanceIndexPath = NSIndexPath(forRow: 5, inSection: 0)
            updateTableViewCellFlyDistance(tableView.cellForRowAtIndexPath(flyDistanceIndexPath))
        }
    }
    
    private var flySpeed = 0 {
        didSet{
            let flySpeedIndexPath = NSIndexPath(forRow: 6, inSection: 0)
            updateTableViewCellFlySpeed(tableView.cellForRowAtIndexPath(flySpeedIndexPath))
        }
    }
    
    private var backHeight: Float = 0 {
        didSet{
            let flyBackHeightIndexPath = NSIndexPath(forRow: 7, inSection: 0)
            updateTableViewCellBackHeight(tableView.cellForRowAtIndexPath(flyBackHeightIndexPath))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupLoadingView()
        setupView()
        initData()
        
        flyDistance = false
        flySpeed = 10
        backHeight = 30
    }
    
    private func setupTableView() {
        
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = .None
        tableView.allowsSelection = true
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset.bottom = 20
        tableView.registerClass(SettingTableViewCell.self, forCellReuseIdentifier: "SettingTableViewCell")
        tableView.registerClass(SwitchTableViewCell.self, forCellReuseIdentifier: "SwitchTableViewCell")
        tableView.registerClass(LabelTableViewCell.self, forCellReuseIdentifier: "LabelTableViewCell")
        tableView.registerClass(SettingHeaderView.self, forHeaderFooterViewReuseIdentifier: "SettingHeaderView")
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(tableView)
        
        tableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(50)
            make.left.right.bottom.equalTo(0)
        }
    }
    
    private func initData() {
        self.sections = [
            [
                ["title": R.string.localizable.settingTableCellTitileLink()
                    , "image": R.image.settingIconLink()!
                    , "detail": ""
                    , "type": "Label"
                    , "action": "Link"
                ],
                ["title": R.string.localizable.settingTableCellTitileUpgrade()
                    , "image": R.image.settingIconUpdate()!
                    , "detail": ""
                    , "type": "Label"
                    , "action": "Update"
                ],
                ["title": R.string.localizable.settingTableCellTitileCompass()
                    , "image": R.image.settingIconCompass()!
                    , "detail": ""
                    , "type": "Label"
                    , "action": "Compass"
                ],
                ["title": R.string.localizable.settingTableCellTitileGuide()
                    , "image": R.image.settingIconGuide()!
                    , "detail": ""
                    , "type": "Label"
                    , "action": "Guide"
                ],
                ["title": R.string.localizable.settingTableCellTitileNewbie()
                    , "image": R.image.settingIconNewbieMode()!
                    , "detail": R.string.localizable.settingTableCellLabelNewbie()
                    , "type": "Switch"
                    , "action": "Newbie"
                ],
                ["title": R.string.localizable.settingTableCellTitileFlyDistance()
                    , "image": R.image.settingIconFlyDistance()!
                    , "detail": R.string.localizable.settingTableCellLabelOpenNewbie()
                    , "type": "Switch"
                    , "action": "FlyDistance"
                ],
                ["title": R.string.localizable.settingTableCellTitileFlySpeed()
                    , "image": R.image.settingIconFlySpeed()!
                    , "detail": R.string.localizable.settingTableCellLabelOpenNewbie()
                    , "type": "Label"
                    , "action": "FlySpeed"
                ],
                ["title": R.string.localizable.settingTableCellTitileBackHeight()
                    , "image": R.image.settingIconFlybackHeight()!
                    , "detail": R.string.localizable.settingTableCellLabelOpenNewbie()
                    , "type": "Label"
                    , "action": "BackHeight"
                ],
                ["title": R.string.localizable.settingTableCellTitileLocationMode()
                    , "image": R.image.settingIconLocationMode()!
                    , "detail": R.string.localizable.settingTableCellLabelOpenNewbie()
                    , "type": "Switch"
                    , "action": "LocationMode"
                ],
                ["title": R.string.localizable.settingTableCellTitilePostureMode()
                    , "image": R.image.settingIconPostureMode()!
                    , "detail": R.string.localizable.settingTableCellLabelOpenNewbie()
                    , "type": "Switch"
                    , "action": "PostureMode"
                ],
                ["title": R.string.localizable.settingTableCellTitileParam()
                    , "image": R.image.settingIconMoreParameter()!
                    , "detail": ""
                    , "type": "Switch"
                    , "action": "Param"
                ]
            ],
            [
                ["title": R.string.localizable.settingTableCellTitileCalibrate()
                    , "image": R.image.settingIconCalibrate()!
                    , "detail": ""
                    , "type": "Label"
                    , "action": "Calibrate"
                ],
                ["title": R.string.localizable.settingTableCellTitileSwitching()
                    , "image": R.image.settingIconSwitching()!
                    , "detail": ""
                    , "type": "Label"
                    , "action": "Switching"
                ]
            ],
            [
                ["title": R.string.localizable.settingTableCellTitileBatteryInfo()
                    , "image": R.image.settingIconBatteryInfo()!
                    , "detail": ""
                    , "type": "Label"
                    ,"action":"BatteryInfo"
                ],
            ],
            [
                ["title": R.string.localizable.settingTableCellTitileGcCompass()
                    , "image": R.image.settingIconCalibrate()!
                    , "detail": ""
                    , "type": "Label"
                    , "action": "GcCompass"
                ]
            ],
            [
                ["title": R.string.localizable.settingTableCellTitileCamera()
                    , "image": R.image.settingIconCamera()!
                    , "detail": ""
                    , "type": "Label"
                    , "action": "Camera"
                ]
            ],
            [
                ["title": R.string.localizable.settingTableCellTitileSatellite()
                    , "image": R.image.settingIconSatellite()!
                    , "detail": ""
                    , "type": "Switch"
                    , "action": "Satellite"
                ]
            ],
            [
                ["title": R.string.localizable.flightRecordsSettingTitle()
                    , "image": R.image.settingIconFlyRecord()!
                    , "detail": ""
                    , "type": "Label"
                    , "action": "FlyRecord"
                ],
                ["title": R.string.localizable.settingTableCellTitileFlyLog()
                    , "image": R.image.settingIconFlyLog()!
                    , "detail": ""
                    , "type": "Label"
                    , "action": "FlyLog"
                ],
                ["title": R.string.localizable.settingTableCellTitileMiInsurance()
                    , "image": R.image.settingIconMiInsurance()!
                    , "detail": ""
                    , "type": "Label"
                    , "action": "Insurance"
                ],
                ["title": R.string.localizable.settingTableCellTitileFeedback()
                    , "image": R.image.settingIconFeedback()!
                    , "detail": ""
                    , "type": "Label"
                    , "action": "Feedback"
                ],
                ["title": R.string.localizable.settingTableCellTitileAbout()
                    , "image": R.image.settingIconAbout()!
                    , "detail": ""
                    , "type": "Label"
                    , "action": "About"
                ],
                ["title": R.string.localizable.settingTableCellTitileAccount()
                    , "image": R.image.settingIconAccount()!
                    , "detail": ""
                    , "type": "Label"
                    , "action": "Account"
                ],
            ]
        ]
    }
    
    private func setupLoadingView() {
        self.view.addSubview(loadingView)
        loadingView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(0)
        }
        loadingView.hide(false)
    }
    
    private func setupView() {
        self.titleBarText = R.string.localizable.settingTitleBarText()
        self.backBarAction = { [weak self](_) -> Void in
            self?.stackVC?.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self
            , selector: #selector(minLinkStateChange(_:))
            , name: DeviceManager.NOTICE_LINK_CHANGE
            , object: nil
        )
        
        NSNotificationCenter.defaultCenter().addObserver(self
            , selector: #selector(deviceDidRecvMsg(_:))
            , name: Device.NOTICE_RECV_MESSAGE
            , object: nil
        )
        
        queryRCOperationMode()
        queryNoviceMode()
        queryFlyDistance()
        queryFlySpeed()
        queryBackHeight()
        
        tableView.reloadData()
        ApplicantX2Api.createApplicantX2Api().syncX2Status()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func minLinkStateChange(sender: NSNotification) {
        self.tableView.reloadData()
        if deviceMng.flightControl.linkState != .Linked {
            aloftadv = false
        } else {
            ApplicantX2Api.createApplicantX2Api().syncX2Status()
        }
        
        if deviceMng.minLinkState != .Linked {
            flyDistance = false
            flySpeed = 10
            backHeight = 30
            
            isNoviceMode = false
            isLocationMode = false
            isPostureMode = false
        } else {
            flyDistance = false
            
            queryRCOperationMode()
            queryNoviceMode()
            //queryFlyDistance()
            queryFlySpeed()
            queryBackHeight()
        }
    }
    
    func deviceDidRecvMsg(sender: NSNotification) {
        guard let msg = sender.userInfo?["recvMsg"] as? HexMessage else {
            return
        }
        
        switch msg {
        case is RemoteControlMsg_62:
            if let ack = msg as? RemoteControlMsg_62 where ack.status == 0x02
                , let mode = RCOperationMode(rawValue: ack.additional_1)
            {
                rcOperationMode = mode
            }
        case is FlightControlMsg_86:
            if let ack = msg as? FlightControlMsg_86 where ack.report == 0x00
                && ack.cmdID == FC86CmdIdCode.Get.rawValue
            {
                backHeight = ack.height
            }
        case is FlightControlMsg_87:
            if let ack = msg as? FlightControlMsg_87 where (ack.report == 0x00 || ack.report == 0x10)
                && ack.oprationCode == FC87OprationCode.GetAck.rawValue
            {
                switch ack.targetID {
                case 1, 3:
                    if ack.targetID == 1 {
                        if let pilotMode = FCPilotMode(rawValue: ack.pilotMode) where pilotMode == .Primary {
                            isNoviceMode = true
                            
                        } else {
                            isNoviceMode = false
                        }

                    }
                    
                    if (ack.operateValue & 0x10) == 0x10 {
                        isLocationMode = false
                        isPostureMode = false
                    }
                    if (ack.operateValue & 0x02) == 0x02 {
                        isLocationMode = true
                        isPostureMode = false
                    }else {
                        isLocationMode = false
                    }
                    if (ack.operateValue & 0x04) == 0x04 {
                        isLocationMode = false
                        isPostureMode = true
                    }
                case 2:
                    if ack.byteCode == 7 {
                        flyDistance = ack.operateValue == 10000
                        DDLogDebug("flyDistance data is \(ack.operateValue)")
                    }
                    
                    if ack.byteCode == 3 {
                        flySpeed = Int(ack.operateValue)
                        DDLogDebug("flySpeed data is \(ack.operateValue)")
                    }
                default:
                    break
                }
            }
        case is FlightControlMsg_02:
            aloftadv = deviceMng.flightControl.flightFlag
        default:
            break
        }
    }
    
    private func queryRCOperationMode() {
        let req = RemoteControlMsg_62()
        req.mode = 0x72
        req.status = 0x01
        req.additional_1 = 0x03 // 查询
        DeviceSession.sendAsynchronousMessage(deviceMng.remoteControl
            , message: req
            , timeout: 0.2
            , resend: 5
            , recv: { (message, _) -> Bool in
                guard let ack = message as? RemoteControlMsg_62 where ack.mode == 0x72 else {
                    return false
                }
                return true
            }
            , completion: nil
        )
    }
    
    private func queryNoviceMode(completion: (() -> Void)? = nil) {
        let msg = FlightControlMsg_87()
        msg.oprationCode = FC87OprationCode.Get.rawValue
        msg.targetID = 0x01
        //msg.pilotMode = FCPilotMode.Primary.rawValue
        DeviceSession.sendAsynchronousMessage(deviceMng.flightControl
            , message: msg
            , timeout: 0.2
            , resend: 5
            , recv: { (message, _) -> Bool in
                guard let _ = message as? FlightControlMsg_87 else {
                    return false
                }
                return true
            }
            , completion: { (_,_) -> Void in
                completion?()
            }
        )
        
    }
    private func queryFlyDistance(completion: (() -> Void)? = nil) {
        let msg = FlightControlMsg_87()
        msg.oprationCode = FC87OprationCode.Get.rawValue
        msg.pilotMode = FCPilotMode.Senior.rawValue
        msg.targetID = 2
        msg.byteCode = 7
        DeviceSession.sendAsynchronousMessage(deviceMng.flightControl
            , message: msg
            , timeout: 0.2
            , resend: 5
            , recv: { (message, _) -> Bool in
                guard let _ = message as? FlightControlMsg_87 else {
                    return false
                }
                return true
            }
            , completion: { (_,_) -> Void in
                completion?()
            }
        )
    }
    
    private func queryFlySpeed(completion: (() -> Void)? = nil) {
        let msg = FlightControlMsg_87()
        msg.oprationCode = FC87OprationCode.Get.rawValue
        msg.pilotMode = FCPilotMode.Senior.rawValue
        msg.targetID = 2
        msg.byteCode = 3
        DeviceSession.sendAsynchronousMessage(deviceMng.flightControl
            , message: msg
            , timeout: 0.2
            , resend: 5
            , recv: { (message, _) -> Bool in
                guard let _ = message as? FlightControlMsg_87 else {
                    return false
                }
                return true
            }
            , completion: { (_,_) -> Void in
                completion?()
            }
        )
    }
    
    private func queryBackHeight(completion: (() -> Void)? = nil) {
        let msg = FlightControlMsg_86()
        msg.packetSequence = InterfaceManager.msgSeq
        msg.cmdID = FC86CmdIdCode.Get.rawValue
        DeviceSession.sendAsynchronousMessage(deviceMng.flightControl
            , message: msg
            , timeout: 0.2
            , resend: 5
            , recv: { (message, _) -> Bool in
                guard let _ = message as? FlightControlMsg_86 else {
                    return false
                }
                return true
            }
            , completion: { (_,_) -> Void in
                completion?()
            }
        )
    }
}

// MARK: - Table view data source

extension SettingViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sections[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let data = sections[indexPath.section][indexPath.row]
        switch data["type"] as! String {
        case "Label":
            return tableView.dequeueReusableCellWithIdentifier("LabelTableViewCell", forIndexPath: indexPath)
        case "Switch":
            return tableView.dequeueReusableCellWithIdentifier("SwitchTableViewCell", forIndexPath: indexPath)
        case "Setting":
            return tableView.dequeueReusableCellWithIdentifier("SettingTableViewCell", forIndexPath: indexPath)
        default:
            return tableView.dequeueReusableCellWithIdentifier("LabelTableViewCell", forIndexPath: indexPath)
        }
    }
}

// MARK: - Table view delegate

extension SettingViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let settingHeaderView = view as? SettingHeaderView else {
            return
        }
        
        switch section {
        case 0:
            settingHeaderView.titileText = R.string.localizable.settingTableSection0()
        case 1:
            settingHeaderView.titileText = R.string.localizable.settingTableSection1()
        case 2:
            settingHeaderView.titileText = R.string.localizable.settingTableSection2()
        case 3:
            settingHeaderView.titileText = R.string.localizable.settingTableSection3()
        case 4:
            settingHeaderView.titileText = R.string.localizable.settingTableSection4()
        case 5:
            settingHeaderView.titileText = R.string.localizable.settingTableSection5()
        case 6:
            settingHeaderView.titileText = R.string.localizable.settingTableSection6()
        default:
            settingHeaderView.titileText = R.string.localizable.settingTableSection3()
        }
    }
    
    // 连接飞行器
    private func updateTableViewCellLink(cell: UITableViewCell?) {
        guard let settingTableViewCell = cell as? SettingTableViewCell else {
            return
        }
        
        settingTableViewCell.showDetailView = true
        settingTableViewCell.enabled = true
        
        if deviceMng.minLinkState == .Linked {
            settingTableViewCell.enabled = false
        } else {
            settingTableViewCell.enabled = true
        }
    }
    
    // 固件升级
    private func updateTableViewCellUpdate(cell: UITableViewCell?) {
        guard let lableTextTableViewCell = cell as? LabelTableViewCell else {
            return
        }
        
        let isNewFirmware = UpgradeManager.sharedInstance.checkDevicesIsUpgrade()
        lableTextTableViewCell.showDetailView = true
        lableTextTableViewCell.enabled = true
        lableTextTableViewCell.showIndicatorView = isNewFirmware
        if isNewFirmware {
            lableTextTableViewCell.labelText = R.string.localizable.settingTableCellLabelNewVersion()
        } else {
            lableTextTableViewCell.labelText = ""
        }
    }
    
    // 指南针校准 0_2
    private func updateTableViewCell_0_2(cell: UITableViewCell?) {
        guard let settingTableViewCell = cell as? SettingTableViewCell else {
            return
        }
        
        settingTableViewCell.showDetailView = true
        settingTableViewCell.enabled = true
    }
    
    // 飞行距离限制
    private func updateTableViewCellFlyDistance(cell: UITableViewCell?) {
        guard let switchTableViewCell = cell as? SwitchTableViewCell else {
            return
        }
        
        switchTableViewCell.showDetailView = false
        
        if aloftadv || isLocationMode {
            switchTableViewCell.enabled = false
        } else {
            switchTableViewCell.enabled = true
        }
        
        if flyDistance {
            switchTableViewCell.state = true
        } else {
            switchTableViewCell.state = false
        }
    }
    
    // 飞行速度限制
    private func updateTableViewCellFlySpeed(cell: UITableViewCell?) {
        guard let labelTableViewCell = cell as? LabelTableViewCell else {
            return
        }
        var despalyLable = "\(flySpeed)m/s"
        
        labelTableViewCell.showDetailView = true
        labelTableViewCell.showIndicatorView = false
        labelTableViewCell.enabled = true
        if isNoviceMode || isLocationMode || isPostureMode {
            labelTableViewCell.labelText = "N/A"
        } else {
            if flySpeed < 6 {
                despalyLable = despalyLable + R.string.localizable.settingSpeedLowspeed()
            } else if flySpeed <= 10 {
                despalyLable = despalyLable + R.string.localizable.settingSpeedStandardspeed()
            } else {
                despalyLable = despalyLable + R.string.localizable.settingSpeedHighspeed()
            }
            labelTableViewCell.labelText = despalyLable
        }
        
        if aloftadv || isNoviceMode || isPostureMode || isLocationMode {
            labelTableViewCell.enabled = false
        } else {
            labelTableViewCell.enabled = true
        }
    }
    
    // 返航高度
    private func updateTableViewCellBackHeight(cell: UITableViewCell?) {
        guard let labelTableViewCell = cell as? LabelTableViewCell else {
            return
        }
        
        labelTableViewCell.showDetailView = true
        labelTableViewCell.showIndicatorView = false
        labelTableViewCell.enabled = true
        labelTableViewCell.labelText = "\(backHeight)m"
        if isNoviceMode || isLocationMode || isPostureMode {
            labelTableViewCell.labelText = "N/A"
        }
        
        if isNoviceMode || isPostureMode || isLocationMode {
            labelTableViewCell.enabled = false
        } else {
            labelTableViewCell.enabled = true
        }
    }
    
    // 新手引导
    private func updateTableViewCell_0_4(cell: UITableViewCell?) {
        guard let settingTableViewCell = cell as? SettingTableViewCell else {
            return
        }
        
        settingTableViewCell.showDetailView = true
        settingTableViewCell.enabled = true
    }
    
    // 新手模式
    private func updateTableViewCellNewbie(cell: UITableViewCell?) {
        guard let switchTableViewCell = cell as? SwitchTableViewCell else {
            return
        }
        
        switchTableViewCell.showDetailView = false
        
        if aloftadv {
            switchTableViewCell.enabled = false
        } else {
            switchTableViewCell.enabled = true
        }
        
        if isNoviceMode {
            switchTableViewCell.state = true
        } else {
            switchTableViewCell.state = false
        }
    }
    
    // 光流模式
    private func updateTableViewCellLocationMode(cell: UITableViewCell?) {
        guard let switchTableViewCell = cell as? SwitchTableViewCell else {
            return
        }
        
        switchTableViewCell.showDetailView = false
        
        if aloftadv {
            switchTableViewCell.enabled = false
        } else {
            if isNoviceMode {
                switchTableViewCell.state = false
                switchTableViewCell.enabled = false
            } else {
                switchTableViewCell.state = isLocationMode
                switchTableViewCell.enabled = true
            }
        }
    }
    
    // 强制姿态
    private func updateTableViewCellPostureMode(cell: UITableViewCell?) {
        guard let switchTableViewCell = cell as? SwitchTableViewCell else {
            return
        }
        
        switchTableViewCell.showDetailView = false
        
        if aloftadv {
            switchTableViewCell.enabled = false
        } else {
            if isNoviceMode {
                switchTableViewCell.state = false
                switchTableViewCell.enabled = false
            } else {
                switchTableViewCell.state = isPostureMode
                switchTableViewCell.enabled = true
            }
        }
    }
    
    // 卫星地图
    private func updateTableViewCellSatellite(cell: UITableViewCell?) {
        guard let switchTableViewCell = cell as? SwitchTableViewCell else {
            return
        }
        
        switchTableViewCell.showDetailView = false
        switchTableViewCell.enabled = true
        switchTableViewCell.state = false
        
        guard databaseMng.setting.mapType == .Satellite else {
            return
        }
        
        // 打开卫星地图
        switchTableViewCell.state = true
    }
    
    // 显示更多飞行参数
    private func updateTableViewCellParam(cell: UITableViewCell?) {
        guard let switchTableViewCell = cell as? SwitchTableViewCell else {
            return
        }
        
        switchTableViewCell.showDetailView = false
        switchTableViewCell.enabled = true
        
        // 显示更多飞行参数
        switchTableViewCell.state = databaseMng.setting.moreParam
    }
    
    private func updateTableViewCellSwitching(cell: UITableViewCell?) {
        guard let labelTableViewCell = cell as? LabelTableViewCell else {
            return
        }
        
        labelTableViewCell.showDetailView = true
        labelTableViewCell.showIndicatorView = false
        labelTableViewCell.enabled = true
        
        switch rcOperationMode {
        case .USA:
            labelTableViewCell.labelText = R.string.localizable.settingTableCellLabelUSA()
        case .Japan:
            labelTableViewCell.labelText = R.string.localizable.settingTableCellLabelJapan()
        }
    }
    
    private func updateTableViewCellAccount(cell: UITableViewCell?) {
        guard let labelTableViewCell = cell as? LabelTableViewCell else {
            return
        }
        
        labelTableViewCell.showDetailView = false
        labelTableViewCell.showIndicatorView = false
        labelTableViewCell.enabled = true
        
        if let user = databaseMng.user {
            labelTableViewCell.labelText = user.miliaoNick
        } else {
            labelTableViewCell.labelText = R.string.localizable.settingTableCellLabelQuit()
        }
    }
    
    private func updateTableViewCellOther(cell: UITableViewCell?) {
        if let labelTableViewCell = cell as? LabelTableViewCell {
            labelTableViewCell.showDetailView = false
            labelTableViewCell.showIndicatorView = false
            labelTableViewCell.enabled = true
            labelTableViewCell.labelText = ""
        }
        if let settingTableViewCell = cell as? SettingTableViewCell {
            settingTableViewCell.showDetailView = true
            settingTableViewCell.enabled = true
            settingTableViewCell
        }
    }
    
    func tableView(tableView: UITableView
        , willDisplayCell cell: UITableViewCell
        , forRowAtIndexPath indexPath: NSIndexPath)
    {
        guard let settingTableViewCell = cell as? SettingTableViewCell else {
            return
        }
        let data = sections[indexPath.section][indexPath.row]
        settingTableViewCell.titileImage = data["image"] as? UIImage
        settingTableViewCell.titileText = data["title"] as? String
        settingTableViewCell.detailsText = data["detail"] as? String
        settingTableViewCell.showDetailView = true
        
        switch data["action"] as! String {
        case "Link":
            updateTableViewCellLink(settingTableViewCell)
        case "Update":
            updateTableViewCellUpdate(settingTableViewCell)
        case "Newbie":
            updateTableViewCellNewbie(settingTableViewCell)
        case "FlyDistance":
            updateTableViewCellFlyDistance(settingTableViewCell)
        case "FlySpeed":
            updateTableViewCellFlySpeed(settingTableViewCell)
        case "BackHeight":
            updateTableViewCellBackHeight(settingTableViewCell)
        case "LocationMode":
            updateTableViewCellLocationMode(settingTableViewCell)
        case "PostureMode":
            updateTableViewCellPostureMode(settingTableViewCell)
        case "Param":
            updateTableViewCellParam(settingTableViewCell)
        case "Switching":
            updateTableViewCellSwitching(settingTableViewCell)
        case "Satellite":
            updateTableViewCellSatellite(settingTableViewCell)
        case "Account":
            updateTableViewCellAccount(settingTableViewCell)
        default:
            updateTableViewCellOther(settingTableViewCell)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 50.0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50.0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.01
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return tableView.dequeueReusableHeaderFooterViewWithIdentifier("SettingHeaderView")
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return nil
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let data = sections[indexPath.section][indexPath.row]
        
        switch data["action"] as! String {
        case "Link":
            selectLink()
        case "Update":
            selectUpdate()
        case "Compass":
            selectCompass()
        case "GcCompass":
            selectGcCompass()
        case "Guide":
            selectGuide()
        case "Newbie":
            selectNewbie(indexPath)
        case "FlyDistance":
            selectFlyDistance(indexPath)
        case "FlySpeed":
            selectFlySpeed(indexPath)
        case "BackHeight":
            selectBackHeight(indexPath)
        case "LocationMode":
            selectLocationMode(indexPath)
        case "PostureMode":
            selectPostureMode(indexPath)
        case "Satellite":
            selectSatellite(indexPath)
        case "Param":
            selectParam(indexPath)
        case "Calibrate":
            selectCalibrate()
        case "Camera":
            selectCamera()
        case "Switching":
            selectSwitching()
        case "BatteryInfo":
            self.stackVC?.pushViewController(BatteryInfoViewController(), animated: true)
        case "Insurance":
            self.stackVC?.presentViewController(InsuranceViewController(), animated: true, completion: nil)
        case "FlyRecord":
            self.stackVC?.pushViewController(FlightRecordsViewController(), animated: true)
        case "FlyLog":
            self.stackVC?.pushViewController(FlightLogsViewController(), animated: true)
        case "Feedback":
            self.stackVC?.pushViewController(FeedbackViewController(), animated: true)
        case "About":
            self.stackVC?.pushViewController(AboutViewController(), animated: true)
        case "Account":
            selectAccount()
        default:
            break
        }
    }
    
    // 连接设备
    private func selectLink() {
        let startupVC = StartupViewController()
        startupVC.layoutType = .Connection
        self.navigationController?.pushViewController(startupVC, animated: true)
    }
    
    // 固件升级
    private func selectUpdate() {
        let isNewFirmware = UpgradeManager.sharedInstance.checkDevicesIsUpgrade()
        let isDownloadFirmware = UpgradeManager.sharedInstance.findNewFirmwareInDisk()
        let rcFaultCode = DeviceManager.sharedInstance.remoteControl.faultCode
        let startupVC = StartupViewController()
        startupVC.isRunGuide = false
        if rcFaultCode.contains(.LowBatteryAlarm) {
            stackVC?.toastText = R.string.localizable.settingUpgradeToastRCLowBatteryAlarm()
        } else if deviceMng.relay.linkState == .Unlink {
            if isDownloadFirmware {
                startupVC.layoutType = .FirmwareDowload
                self.navigationController?.pushViewController(startupVC, animated: true)
            } else {
                stackVC?.toastText = R.string.localizable.settingUpgradeToastUnlink()
            }
        } else if !isNewFirmware {
            stackVC?.toastText = R.string.localizable.settingUpgradeToastIsNewVersion()
        } else {
            if isDownloadFirmware {
                startupVC.layoutType = .FirmwareDowload
            } else {
                startupVC.layoutType = .FirmwareUpgrade
            }
            self.navigationController?.pushViewController(startupVC, animated: true)
        }
    }
    
    // 指南针校准
    private func selectCompass() {
        self.stackVC?.pushViewController(FCCalibrationViewController(), animated: true)
    }
    
    // 云台校准
    private func selectGcCompass() {
        self.stackVC?.pushViewController(GCCalibrationViewController(), animated: true)
    }
    
    // 新手引导
    private func selectGuide() {
        let startupVC = StartupViewController()
        startupVC.layoutType = .Guide
        self.navigationController?.pushViewController(startupVC, animated: true)
    }
    
    // 新手模式
    private func selectNewbie(indexPath: NSIndexPath) {
        
        guard deviceMng.flightControl.linkState == .Linked else {
            stackVC?.toastText = R.string.localizable.settingBeginnerModeUndeviceInfoError()
            return
        }
        
        guard deviceMng.flightControl.flightFlag == false else {
            stackVC?.toastText = R.string.localizable.settingNewbieFlightFlagError()
            return
        }
        
        guard let switchTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as? SwitchTableViewCell else {
            return
        }
        
        self.loadingView.show(true)
        
        let openNoviceMode = { (open: Bool) -> Void in
            var pilotMode = FCPilotMode.SemiSenior
            if open {pilotMode = .Primary}
            
            let msg = FlightControlMsg_87()
            msg.oprationCode = FC87OprationCode.Set.rawValue
            msg.pilotMode = pilotMode.rawValue
            msg.targetID = 1
            DeviceSession.sendAsynchronousMessage(DeviceManager.sharedInstance.flightControl
                , message: msg
                , timeout: 0.2
                , resend: 5
                , recv: { (message, _) -> Bool in
                    guard let _ = message as? FlightControlMsg_87 else {
                        return false
                    }
                    return true
                }
                , completion: { [weak self](error, message) -> Void in
                    if let ack = message as? FlightControlMsg_87 where ack.report == 0 {
                        let time: NSTimeInterval = 1.0
                        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC)))
                        dispatch_after(delay, dispatch_get_main_queue()) { [weak self] in
                            self?.queryNoviceMode { [weak self] in
                                self?.loadingView.hide(true)
                            }
                        }
                    } else {
                        self?.loadingView.hide(true)
                    }
                }
            )
        }
        
        // 关闭新手模式需要判断是否飞行超过一定时间
        if switchTableViewCell.state {
            BeginnerModelApi.createBeginnerModelApi().synchronousAllData { [weak self](result, model) in
                switch result {
                case .Succeeful:
                    self?.stackVC?.toastText = R.string.localizable.settingTotalFlyTime(model!.totalFlyTime / 60)
                    
                    // 判断飞行时长是否达到时间
                    guard model!.totalFlyTime >= DatabaseManager.sharedInstance.userConfig.flyTimeMin else {
                        break
                    }
                    
                    // 关闭新手模式
                    openNoviceMode(false)
                    return
                case .UnDeviceinfo:
                    self?.stackVC?.toastText = R.string.localizable.settingBeginnerModeUndeviceInfoError()
                case .Unlogin:
                    self?.stackVC?.toastText = R.string.localizable.settingBeginnerModeUnloginError()
                default:
                    self?.stackVC?.toastText = R.string.localizable.settingBeginnerModeError()
                }
                
                self?.loadingView.hide(true)
            }
        } else {
            openNoviceMode(true)
        }
    }
    
    // 卫星地图
    private func selectSatellite(indexPath: NSIndexPath) {
        let setting = databaseMng.setting
        if setting.mapType == .Standard {
            setting.mapType = .Satellite
        } else {
            setting.mapType = .Standard
        }
        databaseMng.setting = setting
        updateTableViewCellSatellite(tableView.cellForRowAtIndexPath(indexPath))
    }
    
    // 显示更多飞行参数
    private func selectParam(indexPath: NSIndexPath) {
        let setting = databaseMng.setting
        setting.moreParam = !setting.moreParam
        databaseMng.setting = setting
        updateTableViewCellParam(tableView.cellForRowAtIndexPath(indexPath))
    }
    
    private func selectCalibrate() {
        self.stackVC?.pushViewController(RCCalibrationViewController(), animated: true)
    }
    
    private func selectSwitching() {
        guard deviceMng.flightControl.linkState == .Unlink else {
            stackVC?.toastText = R.string.localizable.settingRCModeToastFCLinked()
            return
        }
        
        self.stackVC?.pushViewController(RCSwitchModeViewController(), animated: true)
    }
    
    private func selectCamera() {
        self.stackVC?.pushViewController(CameraSettingViewController(), animated: true)
    }
    
    private func selectAccount() {
        
        let loginSystem = { [weak self]() -> Void in
            let startupVC = StartupViewController()
            startupVC.layoutType = .Login
            self?.navigationController?.pushViewController(startupVC, animated: true)
        }
        
        if let _ = databaseMng.user {
            let cancelItem = MessageBoxView.Item()
            cancelItem.title = R.string.localizable.settingLogoutCancel()
            cancelItem.action = { (view, _) -> Void in
                view.hideView(true)
            }
            
            let confirmItem = MessageBoxView.Item()
            confirmItem.title = R.string.localizable.settingLogoutConfirm()
            confirmItem.normalColor = UIColor(red: 1, green: 66.0/255, blue: 0, alpha: 1.0)
            confirmItem.highlightedColor = UIColor(red: 1, green: 66.0/255, blue: 0, alpha: 0.5)
            confirmItem.action = { [weak self](view, _) -> Void in
                view.hideView(true)
                
                self?.databaseMng.user = nil
                let indexPath = NSIndexPath(forRow: 0, inSection: 3)
                self?.updateTableViewCellAccount(self?.tableView.cellForRowAtIndexPath(indexPath))
                
                loginSystem()
            }
            
            MessageBoxView.showViewAddedTo(self.view.window!
                , animated: true
                , titleText: R.string.localizable.settingLogoutTips()
                , buttons: [cancelItem, confirmItem]
            )
        } else {
            loginSystem()
        }
    }
    
    // 设置飞行距离
    private func selectFlyDistance(indexPath: NSIndexPath) {
        guard deviceMng.flightControl.linkState == .Linked else {
            stackVC?.toastText = R.string.localizable.settingBeginnerModeUndeviceInfoError()
            return
        }
        
        let cancelItem = FlyDistanceView.Item()
        cancelItem.title = R.string.localizable.settingLogoutCancel()
        cancelItem.action = { (view, _) -> Void in
            view.hideView(true)
        }
        
        guard let switchTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as? SwitchTableViewCell else {
            return
        }
        
        let openFlyDistance = { () -> Void in
            self.loadingView.show(true)
            let msg = FlightControlMsg_87()
            msg.oprationCode = FC87OprationCode.Set.rawValue
            msg.pilotMode = FCPilotMode.Senior.rawValue
            msg.targetID = 2
            msg.byteCode = 7
            
            if switchTableViewCell.state {
                msg.operateValue = 500
            } else {
                msg.operateValue = 10000
            }
            DeviceSession.sendAsynchronousMessage(DeviceManager.sharedInstance.flightControl
                , message: msg
                , timeout: 0.2
                , resend: 5
                , recv: { (message, _) -> Bool in
                    guard let _ = message as? FlightControlMsg_87 else {
                        return false
                    }
                    return true
                }
                , completion: { [weak self](error, message) -> Void in
                    if let message = message as? FlightControlMsg_87 where message.report == 0 {
                        let time: NSTimeInterval = 1.0
                        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC)))
                        dispatch_after(delay, dispatch_get_main_queue()) {
                            self?.queryFlyDistance({
                                self?.loadingView.hide(false)
                            })
                        }
                        
                    } else {
                        self?.loadingView.hide(false)
                        self?.stackVC?.toastText = R.string.localizable.settingSendError()
                    }
                }
            )
        }
        self.showMessage({
            openFlyDistance()
        })
    }
    
    private func showMessage(confirm: (() -> Void)){
        let cancelItem = MessageBoxView.Item()
        cancelItem.title = R.string.localizable.settingLogoutCancel()
        cancelItem.action = { (view, _) -> Void in
            view.hideView(true)
        }
        
        let confirmItem = MessageBoxView.Item()
        confirmItem.title = R.string.localizable.switchRCConfirm()
        confirmItem.action = { (view, _) -> Void in
            view.hideView(true)
            confirm()
        }
        
        let titleLable = UILabel()
        titleLable.text = R.string.localizable.settingFlyDistanceTips()
        titleLable.numberOfLines = 0
        titleLable.font = R.font.fZLTHJWGB10(size: 15)
        titleLable.textColor = UIColor.blackColor()
        titleLable.textAlignment = .Left
        titleLable.numberOfLines = 0
        
        MessageBoxView.showViewAddedTo(self.view.window!
            , animated: true
            , titleView: titleLable
            , buttons: [cancelItem, confirmItem]
        )
    }
    
    // 设置飞行速度
    private func selectFlySpeed(indexPath: NSIndexPath) {
        guard deviceMng.flightControl.linkState == .Linked else {
            stackVC?.toastText = R.string.localizable.settingBeginnerModeUndeviceInfoError()
            return
        }
        
        let cancelItem = FlySpeedView.Item()
        cancelItem.title = R.string.localizable.settingLogoutCancel()
        cancelItem.action = { (view, _) -> Void in
            view.hideView(true)
        }
        
        let confirmItem = FlySpeedView.Item()
        confirmItem.title = R.string.localizable.switchRCConfirm()
        confirmItem.action = { [weak self](view, _) -> Void in
            view.hideView(true)
            self?.loadingView.show(true)
            let msg = FlightControlMsg_87()
            msg.oprationCode = FC87OprationCode.Set.rawValue
            msg.pilotMode = FCPilotMode.Senior.rawValue
            msg.targetID = 2
            msg.byteCode = 3
            msg.operateValue = Int32(view.flytime)
            DeviceSession.sendAsynchronousMessage(DeviceManager.sharedInstance.flightControl
                , message: msg
                , timeout: 0.2
                , resend: 5
                , recv: { (message, _) -> Bool in
                    guard let _ = message as? FlightControlMsg_87 else {
                        return false
                    }
                    return true
                }
                , completion: { [weak self](error, message) -> Void in
                    if let message = message as? FlightControlMsg_87 where message.report == 0 {
                        let time: NSTimeInterval = 1.0
                        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC)))
                        dispatch_after(delay, dispatch_get_main_queue()) {
                            self?.queryFlySpeed({
                                self?.loadingView.hide(false)
                            })
                        }
                        
                    } else {
                        self?.loadingView.hide(false)
                        self?.stackVC?.toastText = R.string.localizable.settingSendError()
                    }
                }
            )
        }
        
        FlySpeedView.showViewAddedTo(self.view.window!
            , animated: true
            , titleText: R.string.localizable.settingFlyspeedTips()
            , currentValue: flySpeed
            , showSlider: true
            , buttons: [cancelItem, confirmItem]
        )
    }
    
    
    private func selectBackHeight(indexPath: NSIndexPath) {
        guard deviceMng.flightControl.linkState == .Linked else {
            stackVC?.toastText = R.string.localizable.settingBeginnerModeUndeviceInfoError()
            return
        }
        
        let cancelItem = FlyDistanceView.Item()
        cancelItem.title = R.string.localizable.settingLogoutCancel()
        cancelItem.action = { (view, _) -> Void in
            view.hideView(true)
        }
        
        let confirmItem = FlyDistanceView.Item()
        confirmItem.title = R.string.localizable.switchRCConfirm()
        confirmItem.action = { [weak self](view, _) -> Void in
            view.hideView(true)
            self?.loadingView.show(true)
            let msg = FlightControlMsg_86()
            msg.packetSequence = InterfaceManager.msgSeq
            msg.cmdID = FC86CmdIdCode.Set.rawValue
            msg.height = view.flytime
            DeviceSession.sendAsynchronousMessage(DeviceManager.sharedInstance.flightControl
                , message: msg
                , timeout: 0.2
                , resend: 5
                , recv: { (message, _) -> Bool in
                    guard let _ = message as? FlightControlMsg_86 else {
                        return false
                    }
                    return true
                }
                , completion: { [weak self](error, message) -> Void in
                    if let message = message as? FlightControlMsg_86 where message.report == 0 {
                        let time: NSTimeInterval = 1.0
                        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC)))
                        dispatch_after(delay, dispatch_get_main_queue()) {
                            self?.queryBackHeight({
                                self?.loadingView.hide(false)
                            })
                        }
                        
                    } else {
                        self?.loadingView.hide(false)
                        self?.stackVC?.toastText = R.string.localizable.settingSendError()
                    }
                }
            )
        }
        
        FlyDistanceView.showViewAddedTo(self.view.window!
            , animated: true
            , titleText: R.string.localizable.settingTableCellTitileBackHeight()
            , minVaue: 30
            , maxVaue: 120
            , currentValue: backHeight
            , showSlider: true
            , buttons: [cancelItem, confirmItem]
        )
    }
    
    // VPU模式
    private func selectLocationMode(indexPath: NSIndexPath) {
        guard deviceMng.flightControl.linkState == .Linked else {
            stackVC?.toastText = R.string.localizable.settingBeginnerModeUndeviceInfoError()
            return
        }
        
        guard deviceMng.flightControl.flightFlag == false else {
            stackVC?.toastText = R.string.localizable.settingVPUFlightFlagError()
            return
        }
        
        guard let switchTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as? SwitchTableViewCell else {
            return
        }
        
        let openNoviceMode = { (open: Bool) -> Void in
            self.loadingView.show(true)
            let msg = FlightControlMsg_87()
            msg.oprationCode = FC87OprationCode.Set.rawValue
            msg.pilotMode = FCPilotMode.Primary.rawValue
            msg.targetID = 0x03
            msg.byteCode = 0x02
            if open {
                msg.operateValue = 1
            } else {
                msg.operateValue = 0
            }
            
            DeviceSession.sendAsynchronousMessage(DeviceManager.sharedInstance.flightControl
                , message: msg
                , timeout: 0.2
                , resend: 5
                , recv: { (message, _) -> Bool in
                    guard let _ = message as? FlightControlMsg_87 else {
                        return false
                    }
                    return true
                }
                , completion: { [weak self](error, message) -> Void in
                    if let message = message as? FlightControlMsg_87 where message.report == 0 {
                        self?.selectPlaneModel(msg, cell: switchTableViewCell) {
                            self?.loadingView.hide(true)
                        }
                    } else {
                        self?.loadingView.hide(true)
                        self?.stackVC?.toastText = R.string.localizable.settingSendError()
                    }
                }
            )
        }
        
        if switchTableViewCell.state {
            openNoviceMode(false)
        } else {
            let cancelItem = MessageBoxView.Item()
            cancelItem.title = R.string.localizable.settingBeginnerModeOpenCancel()
            cancelItem.action = { (view, _) -> Void in
                self.loadingView.hide(true)
                view.hideView(true)
            }
            
            let confirmItem = MessageBoxView.Item()
            if databaseMng.setting.applyX2 == .Passed {
                confirmItem.title = R.string.localizable.settingBeginnerModeOpenConfirm()
            } else {
                confirmItem.title = R.string.localizable.settingBeginnerModeOpenApply()
            }
            confirmItem.action = { [weak self](view, _) -> Void in
                view.hideView(true)
                if let settting = self?.databaseMng.setting {
                    switch settting.applyX2 {
                    case .Passed:
                        openNoviceMode(true)
                    case .Verifying:
                        self?.stackVC?.toastText = R.string.localizable.settingVPUApplyVerifying()
                    case.Reject:
                        self?.stackVC?.toastText = R.string.localizable.settingVPUApplyReject()
                    default:
                        view.hideView(true)
                        self?.loadingView.show(true)
                        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        if let reachability = delegate.reachability where reachability.isReachable() {
                            ApplicantX2Api.createApplicantX2Api().applyOrFindX2 { [weak self](result, model) in
                                if result == .Succeeful {
                                    self?.loadingView.hide(false)
                                    if let model = model{
                                        switch model.result {
                                        case .Passed:
                                            openNoviceMode(true)
                                        case .Verifying:
                                            self?.stackVC?.toastText = R.string.localizable.settingVPUApplyVerifying()
                                        default:
                                            self?.stackVC?.toastText = R.string.localizable.settingVPUApplyReject()
                                        }
                                    }else {
                                        self?.stackVC?.toastText = R.string.localizable.settingVPUApplyFailure()
                                    }
                                } else {
                                    self?.loadingView.hide(false)
                                    self?.stackVC?.toastText = R.string.localizable.settingVPUApplyFailure()
                                }
                            }
                        } else {
                            self?.loadingView.hide(false)
                            self?.stackVC?.toastText = R.string.localizable.settingVPUApplyNetworkError()
                        }
                    }
                }
            }
            
            let titleLable = UILabel()
            titleLable.text = R.string.localizable.settingVPUOpenTips()
            titleLable.numberOfLines = 0
            titleLable.font = R.font.fZLTHJWGB10(size: 15)
            titleLable.textColor = UIColor.blackColor()
            titleLable.textAlignment = .Left
            titleLable.numberOfLines = 0
            
            
            MessageBoxView.showViewAddedTo(self.view.window!
                , animated: true
                , titleText: ""
                , titleView: titleLable
                , buttons: [cancelItem, confirmItem]
            )
        }
        
    }
    
    // 姿态模式
    private func selectPostureMode(indexPath: NSIndexPath) {
        guard let switchTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as? SwitchTableViewCell else {
            return
        }
        
        guard deviceMng.flightControl.linkState == .Linked else {
            stackVC?.toastText = R.string.localizable.settingBeginnerModeUndeviceInfoError()
            return
        }
        
        let openNoviceMode = { () -> Void in
            self.loadingView.show(true)
            let msg = FlightControlMsg_87()
            msg.oprationCode = FC87OprationCode.Set.rawValue
            msg.pilotMode = FCPilotMode.Primary.rawValue
            msg.targetID = 0x03
            msg.byteCode = 0x04
            if switchTableViewCell.state {
                msg.operateValue = 0
            } else {
                msg.operateValue = 1
            }
            
            DeviceSession.sendAsynchronousMessage(DeviceManager.sharedInstance.flightControl
                , message: msg
                , timeout: 0.2
                , resend: 5
                , recv: { (message, _) -> Bool in
                    guard let _ = message as? FlightControlMsg_87 else {
                        return false
                    }
                    return true
                }
                , completion: { [weak self](error, message) -> Void in
                    if let message = message as? FlightControlMsg_87 where message.report == 0 {
                        self?.selectPlaneModel(msg, cell: switchTableViewCell) {
                            self?.loadingView.hide(true)
                        }
                    } else {
                        self?.loadingView.hide(true)
                        self?.stackVC?.toastText = R.string.localizable.settingSendError()
                    }
                }
            )
        }
        
        let cancelItem = MessageBoxView.Item()
        cancelItem.title = R.string.localizable.settingBeginnerModeOpenCancel()
        cancelItem.action = { (view, _) -> Void in
            self.loadingView.hide(true)
            view.hideView(true)
        }
        
        let confirmItem = MessageBoxView.Item()
        confirmItem.title = R.string.localizable.settingBeginnerModeOpenConfirm()
        confirmItem.action = { (view, _) -> Void in
            view.hideView(true)
            openNoviceMode()
        }
        
        let titleLable = UILabel()
        titleLable.text = R.string.localizable.settingPostureModeTips()
        titleLable.numberOfLines = 0
        titleLable.font = R.font.fZLTHJWGB10(size: 15)
        titleLable.textColor = UIColor.blackColor()
        titleLable.textAlignment = .Left
        titleLable.numberOfLines = 0

        if switchTableViewCell.state {
            openNoviceMode()
        } else {
            MessageBoxView.showViewAddedTo(self.view.window!
                , animated: true
                , titleText: ""
                , titleView: titleLable
                , buttons: [cancelItem, confirmItem]
            )
        }
        
    }
    
    private func selectPlaneModel(msg: FlightControlMsg_87, cell: SwitchTableViewCell, completion:(() -> Void)) {
        let time: NSTimeInterval = 1.0
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) {
            msg.oprationCode = FC87OprationCode.Get.rawValue
            DeviceSession.sendAsynchronousMessage(DeviceManager.sharedInstance.flightControl
                , message: msg
                , timeout: 0.2
                , resend: 5
                , recv: { (message, _) -> Bool in
                    guard let _ = message as? FlightControlMsg_87 else {
                        return false
                    }
                    return true
                }
                , completion: { (_, _) -> Void in
                    completion()
                }
            )
        }
    }
}


