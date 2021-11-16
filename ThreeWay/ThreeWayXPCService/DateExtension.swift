//
//  DateExtension.swift
//  ThreeWayXPCService
//
//  Created by Phaninder Kumar on 08/11/21.
//

import Foundation

extension Date {

    func getLocalStringDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd-MMM-yy hh:mm:ss a"
        return dateFormatter.string(from: self)
    }

    func getLocalStringLogFile() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd_MMM_yy_hh_mm_ss_a"
        return dateFormatter.string(from: self)
    }
    
    func timeAgo() -> String {
        let calendar = Calendar.current
        let now = Date()
        let earliest = self < now ? self : now
        let latest =  self > now ? self : now
        
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .second]
        let components: DateComponents = calendar.dateComponents(unitFlags, from: earliest, to: latest)
        
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        let second = components.second ?? 0
        
        let secondsString = String(second) + "s"
        let minutesString = String(minute) + "m"
        
        var hoursString = ""
        if hour > 0 {
            hoursString = String(hour) + "h"
        }

        var timeString = ""
        if !hoursString.isEmpty {
            timeString = "\(hoursString):\(minutesString)"
        } else {
            timeString = "\(minutesString)"
        }
        timeString += ":\(secondsString)"
        return timeString
    }

}
