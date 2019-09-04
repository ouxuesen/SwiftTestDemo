//
//  TimeDateSourse.swift
//  SwiftTestDemo
//
//  Created by ou xuesen on 2019/9/3.
//  Copyright © 2019 ou xuesen. All rights reserved.
//

import UIKit
extension Date{
    
    func dateFollowMonth() -> Date? {
        var datacomponets = DateComponents()
        datacomponets.month = 1
        return Calendar.current.date(byAdding: datacomponets, to: self);
    }
    
    func numberOfDaysCurrentMoth() -> Range<Int> {
        
        guard let range = Calendar.current.range(of:.day, in: .month, for: self) else { return 0..<1 }
        
        return range
    }
    
    func dateToString(_ formaterrS:String) -> String {
        let myFormatter = DateFormatter()
        //这里有很多默认的日期格式
        myFormatter.dateFormat = formaterrS
        return myFormatter.string(from: self)
    }
    
    func getWeekd() -> String {
        let weekDays = ["","周日","周一","周二","周三","周四","周五","周六"]
        let theComponents = Calendar.current.component(.weekday, from: self)
        return weekDays[theComponents]
    }
    //返回今天 明天 后天 或者nil
    func compareData() -> String {
        if Calendar.current.isDateInToday(self){
            return "今天"
        }else if Calendar.current.isDateInTomorrow(self){
            return "明天"
        }else{
          return self.getWeekd()
        }
    
    }
    func getTitle() -> String {
       return self.compareData()
    }
}
class DateModel {
    var currentDate:Date?
    var souceArray :Array<Array<Date>>?
    var title:String{
        get{

            return currentDate!.getTitle() + "\n" + currentDate!.dateToString("MM月dd日")
        }
 
    }
    
    init(date:Date,souce:Array<Array<Date>>) {
        currentDate = date
        souceArray = souce
    }
}
//运营时间是早10：00 - 21：00
class TimeDateSource: NSObject {
    
   class func compearTime(_ firstTime:Date,_ sencondTime:Date) -> Bool {
        let result:ComparisonResult =  firstTime.compare(sencondTime)
        return result == .orderedAscending||result == .orderedSame
    }
    class func getCurrent(_ date:Date) -> Array<Array<Date>>{
        let comDate = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: date)
        var noonSouceArray:Array = [Date]()
        var afterNoonSouceArray:Array = [Date]()
        
        var components = DateComponents()
        components.year = comDate.year
        components.month = comDate.month
        components.day = comDate.day
        components.hour = 10
        var currentDay:Date?
        var startDay:Date?
        var components_divite = DateComponents()
        components_divite.year = comDate.year
        components_divite.month = comDate.month
        components_divite.day = comDate.day
        components_divite.hour = 15
        components_divite.minute = 30
        let diviDay = Calendar.current.date(from: components_divite)
        
        var components_last = DateComponents()
        components_last.year = comDate.year
        components_last.month = comDate.month
        components_last.day = comDate.day
        components_last.hour = 21
        guard let lastDay = Calendar.current.date(from: components_last) else { return [[]]}
        if Calendar.current.isDateInToday(date){
            if comDate.minute ?? 0 > 30{
                components.hour = (comDate.hour! + 1)
            }else{
                components.hour = comDate.hour
            }
            
            startDay = Calendar.current.date(from: components)
        }else{
            startDay = Calendar.current.date(from: components)
        }
        currentDay = startDay
        while compearTime(currentDay!, lastDay) {
            if compearTime(currentDay!, diviDay!){
                noonSouceArray.append(currentDay!)
            }else{
                afterNoonSouceArray.append(currentDay!)
            }
            currentDay = Date.init(timeInterval:TimeInterval(30*60), since: currentDay!)
        }
        return [noonSouceArray,afterNoonSouceArray]
    }
    class  func getDaySource() -> Array<DateModel> {
        var daySouceArray:Array = [DateModel]()
        for n in 0..<30{
            let tempDate = Date.init(timeInterval:TimeInterval(n*24*60*60), since: Date())
            let dateModel = DateModel.init(date:tempDate as Date, souce:self.getCurrent(tempDate) as Array<Array<Date>>)
            daySouceArray.append(dateModel)
        }
        return daySouceArray
    }
}
