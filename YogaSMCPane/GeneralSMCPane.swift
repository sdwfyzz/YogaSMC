//
//  GeneralSMCPane.swift
//  YogaSMCPane
//
//  Created by Zhen on 12/21/20.
//  Copyright © 2020 Zhen. All rights reserved.
//

import AppKit
import Foundation

extension YogaSMCPane {
    @IBAction func DYTCset(_ sender: NSSlider) {
        _ = sendString("DYTCMode", DYTCCommand[DYTCSlider.integerValue], service)
        if let dict = getDictionary("DYTC", service) {
            updateDYTC(dict)
        }
    }

    @IBAction func backlightSet(_ sender: NSSlider) {
        if !sendNumber("BacklightLevel", backlightSlider.integerValue, service) {
            let backlightLevel = getNumber("BacklightLevel", service)
            if backlightLevel != -1 {
                backlightSlider.integerValue = backlightLevel
            } else {
                backlightSlider.isEnabled = false
            }
        }
    }

    @IBAction func vClamshellModeSet(_ sender: NSButton) {
        _ = sendBoolean("ClamshellMode", (vClamshellMode.state == .on), service)
    }

    @IBAction func autoBacklightSet(_ sender: NSButton) {
        let val = ((autoSleepCheck.state == .on) ? 1 << 0 : 0) +
                ((yogaModeCheck.state == .on) ? 1 << 1 : 0) +
                ((indicatorCheck.state == .on) ? 1 << 2 : 0) +
                ((muteCheck.state == .on) ? 1 << 3 : 0) +
                ((micMuteCheck.state == .on) ? 1 << 4 : 0)
        if !sendNumber("AutoBacklight", val, service) {
            let autoBacklight = getNumber("AutoBacklight", service)
            if autoBacklight != -1 {
                autoSleepCheck.state = ((autoBacklight & (1 << 0)) != 0) ? .on : .off
                yogaModeCheck.state =  ((autoBacklight & (1 << 1)) != 0) ? .on : .off
                indicatorCheck.state =  ((autoBacklight & (1 << 2)) != 0) ? .on : .off
                muteCheck.state =  ((autoBacklight & (1 << 3)) != 0) ? .on : .off
                micMuteCheck.state =  ((autoBacklight & (1 << 4)) != 0) ? .on : .off
            } else {
                autoSleepCheck.isEnabled = false
                yogaModeCheck.isEnabled = false
                indicatorCheck.isEnabled = false
                muteCheck.isEnabled = false
                micMuteCheck.isEnabled = false
            }
        }
    }

    func updateDYTC(_ dict: NSDictionary) {
        if let ver = dict["Revision"] as? NSNumber,
           let subver = dict["SubRevision"] as? NSNumber {
            vDYTCRevision.stringValue = "\(ver.intValue).\(subver.intValue)"
        } else {
            vDYTCRevision.stringValue = "Unknown"
        }
        if let funcMode = dict["FuncMode"] as? String {
            vDYTCFuncMode.stringValue = funcMode
        } else {
            vDYTCFuncMode.stringValue = "Unknown"
        }
        if let perfMode = dict["PerfMode"] as? String {
            if perfMode == "Quiet" {
                DYTCSlider.integerValue = 0
            } else if perfMode == "Balance" {
                DYTCSlider.integerValue = 1
            } else if perfMode == "Performance" {
                DYTCSlider.integerValue = 2
            } else if perfMode == "Performance (Reduced as lapmode active)" {
                DYTCSlider.integerValue = 2
            } else {
                DYTCSlider.isEnabled = false
            }
        } else {
            DYTCSlider.isEnabled = false
        }
    }

    func updateMain(_ props: NSDictionary) {
        if let val = props["AutoBacklight"] as? NSNumber {
            let autoBacklight = val.intValue
            autoSleepCheck.state = ((autoBacklight & (1 << 0)) != 0) ? .on : .off
            yogaModeCheck.state =  ((autoBacklight & (1 << 1)) != 0) ? .on : .off
            indicatorCheck.state =  ((autoBacklight & (1 << 2)) != 0) ? .on : .off
            muteCheck.state =  ((autoBacklight & (1 << 3)) != 0) ? .on : .off
            micMuteCheck.state =  ((autoBacklight & (1 << 4)) != 0) ? .on : .off
        } else {
            autoSleepCheck.isEnabled = false
            yogaModeCheck.isEnabled = false
            indicatorCheck.isEnabled = false
            micMuteCheck.isEnabled = false
        }
        #if !DEBUG
        muteCheck.isEnabled = false
        if muteCheck.state == .on {
            muteCheck.state = .off
            autoBacklightSet(muteCheck)
        }
        #endif

        if let val = props["BacklightLevel"] as? NSNumber {
            backlightSlider.integerValue = val.intValue
        } else {
            backlightSlider.isEnabled = false
        }

        if let dict = props["DYTC"]  as? NSDictionary {
            updateDYTC(dict)
        } else {
            vDYTCRevision.stringValue = "Unsupported"
            vDYTCFuncMode.isHidden = true
            DYTCSlider.isHidden = true
        }

        if defaults.bool(forKey: "HideIcon") {
            vHideMenubarIcon.state = .on
        } else {
            vHideMenubarIcon.state = .off
            vMenubarIcon.isEnabled = true
        }
        vMenubarIcon.stringValue = defaults.string(forKey: "Title") ?? ""

        vHideCapsLock.state = defaults.bool(forKey: "HideCapsLock") ? .on : .off

        if let val = props["ClamshellMode"] as? Bool {
            vClamshellMode.isEnabled = true
            vClamshellMode.state = val ? .on : .off
        }
    }
}
