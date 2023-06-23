//
//  ViewController.swift
//  HW_if else_Date Picker
//
//  Created by 曹家瑋 on 2023/6/22.
//


/*
 公元年份除以4能整除但除以100不能整除的，為閏年。（例如2004年就是閏年，1900年不是閏年）
 公元年份除以400能整除的，也為閏年。（例如2000年是閏年）
 */

import UIKit

// UIPickerViewDataSource 和 UIPickerViewDelegate 是 UIPickerView 的兩個協議
class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // 選擇日期
    @IBOutlet weak var datePicker: UIDatePicker!
    // 顯示選擇的年份是 平年 / 閏年
    @IBOutlet weak var leapYearSegmentedControl: UISegmentedControl!
    // 顯示選擇的日期是星期幾
    @IBOutlet weak var dayOfWeekSegmentedControl: UISegmentedControl!
    // 選擇的日期對應農曆年份
    @IBOutlet weak var lunarYearLabel: UILabel!
    // 選擇的日期對應的星座
    @IBOutlet weak var zodiacPickerView: UIPickerView!
    // 選擇的日期對應的星座圖片
    @IBOutlet weak var zodiacImageView: UIImageView!

    // 定義 ZodiacSign 類型的數組，存儲所有的星座以及對應的圖片名稱
    let zodiacSigns = [
        ZodiacSign(displayName: "水瓶座（01/21~02/19）", imageName: "Aquarius"),
        ZodiacSign(displayName: "雙魚座（02/21~03/21）", imageName: "Pisces"),
        ZodiacSign(displayName: "牡羊座（03/21~04/20）", imageName: "Aries"),
        ZodiacSign(displayName: "金牛座（04/21~05/21）", imageName: "Taurus"),
        ZodiacSign(displayName: "雙子座（05/22~06/21）", imageName: "Gemini"),
        ZodiacSign(displayName: "巨蠍座（06/22~07/22）", imageName: "Cancer"),
        ZodiacSign(displayName: "獅子座（07/23~08/23）", imageName: "Leo"),
        ZodiacSign(displayName: "處女座（08/24~09/23）", imageName: "Virgo"),
        ZodiacSign(displayName: "天秤座（09/24~10/23）", imageName: "Libra"),
        ZodiacSign(displayName: "天蠍座（10/24~11/22）", imageName: "Scorpio"),
        ZodiacSign(displayName: "射手座（11/23~12/21）", imageName: "Sagittarius"),
        ZodiacSign(displayName: "摩羯座（12/22~01/20）", imageName: "Capricorn")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // zodiacPickerView 的資料源和代理
        zodiacPickerView.dataSource = self
        zodiacPickerView.delegate = self
        
        // 獲取當前的日期和時間
        let currentDate = Date()
        // 更新 datePicker 的值
        datePicker.date = currentDate
        // 使用當前的日期和時間更新界面
        datePickerValueChanged(datePicker)
    }


    // 日期的選擇（星座顯示（PickerView）、星座圖片、閏年平年（SegmentedControl）、星期幾（SegmentedControl）、農曆時間（Label））
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        
        // 存儲使用者在 UIDatePicker 中選擇的日期
        let selectedDate = sender.date
        
        // 該日期所在的年份，閏年平年判斷
        let isLeapYear = checkLeapYear(birthday: selectedDate)
        // 透過 isLeapYear 來判斷 selectedSegmentIndex
        leapYearSegmentedControl.selectedSegmentIndex = isLeapYear ? 1 : 0
        
        // 判斷星期幾
        updateDayOfWeekSegmentedControl(for: selectedDate)
        
        // 將選定的日期轉換為農曆並顯示
        calcuateLunarYear(from: selectedDate)
        
        
        // 更新 UIPickerView
        // 得到與選定日期相對應的星座名稱
        let zodiacSign = calculateZodiac(from: selectedDate)
        
        // 查找選定的星座在星座列表中的位置（索引）
        if let index = zodiacSigns.firstIndex(of: zodiacSign) {
            
            // 如果找到星座，則更新 UIPickerView 的選擇行，使得對應到該星座
            zodiacPickerView.selectRow(index, inComponent: 0, animated: true)
        }
        else {
            print("找不到對應的星座")
        }

        // 根據星座的名稱更新相對應的星座圖片
        zodiacImageView.image = UIImage(named: zodiacSign.imageName)
        
    }
    
    // 判斷選擇的日期對應的年份是否為閏年
    func checkLeapYear(birthday: Date) -> Bool {
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: birthday)
        
        // 閏年的條件
        if year % 4 == 0 {
            if year % 100 != 0 {
                return true
            } else {
                if year % 400 == 0 {
                    return true
                }
            }
        }
        // 平年
        return false
    }
    
    // 判斷星期幾（更改 dayOfWeekSegmentedControl）
    func updateDayOfWeekSegmentedControl(for date: Date) {
        
        let weekday = Calendar.current.component(.weekday, from: date)
        let segmentedControlIndex = weekday - 1
        dayOfWeekSegmentedControl.selectedSegmentIndex = segmentedControlIndex
    }
    
    // 顯示給定的日期對應的農曆年份（練習DateFormatter）
    func calcuateLunarYear(from date: Date) {
        
        // 創建日期格式器
        let formatter = DateFormatter()
        // 將格式器的語言設置為中文（繁體）
        formatter.locale = Locale(identifier: "zh_TW")
        // 將日曆系統設置為農曆
        formatter.calendar = Calendar(identifier: .chinese)
        // 將日期的格式設置為全格式（包括年份、月份和日期）
        formatter.dateStyle = .full

        lunarYearLabel.text = formatter.string(from: date)
    }
    
    // 判斷相對應的星座
    func calculateZodiac(from date: Date) -> ZodiacSign {
        
        let calendar = Calendar.current
        let birthMonth = calendar.component(.month, from: date)
        let birthDay = calendar.component(.day, from: date)
        
        // 日期區間對應星座 ZodiacSign
        switch (birthMonth, birthDay) {
        case (1, 21...31), (2, 1...19):
            return ZodiacSign(displayName: "水瓶座（01/21~02/19）", imageName: "Aquarius")
        case (2, 20...29), (3, 1...20):
            return ZodiacSign(displayName: "雙魚座（02/21~03/21）", imageName: "Pisces")
        case (3, 21...31), (4, 1...20):
            return ZodiacSign(displayName: "牡羊座（03/21~04/20）", imageName: "Aries")
        case (4, 21...30), (5, 1...21):
            return ZodiacSign(displayName: "金牛座（04/21~05/21）", imageName: "Taurus")
        case (5, 22...31), (6, 1...21):
            return ZodiacSign(displayName: "雙子座（05/22~06/21）", imageName: "Gemini")
        case (6, 22...30), (7, 1...22):
            return ZodiacSign(displayName: "巨蠍座（06/22~07/22）", imageName: "Cancer")
        case (7, 23...31), (8, 1...23):
            return ZodiacSign(displayName: "獅子座（07/23~08/23）", imageName: "Leo")
        case (8, 24...31), (9, 1...23):
            return ZodiacSign(displayName: "處女座（08/24~09/23）", imageName: "Virgo")
        case (9, 24...30), (10, 1...23):
            return ZodiacSign(displayName: "天秤座（09/24~10/23）", imageName: "Libra")
        case (10, 24...31), (11, 1...22):
            return ZodiacSign(displayName: "天蠍座（10/24~11/22）", imageName: "Scorpio")
        case (11, 23...30), (12, 1...21):
            return ZodiacSign(displayName: "射手座（11/23~12/21）", imageName: "Sagittarius")
        case (12, 22...31), (1, 1...20):
            return ZodiacSign(displayName: "摩羯座（12/22~01/20）", imageName: "Capricorn")
        default:
            return ZodiacSign(displayName: "查無星座", imageName: "question mark")
        }
    }
    
    
    // PickerView 部分：以下為 UIPickerViewDataSource 和 UIPickerViewDelegate 協議的方法
    
    // 返回 UIPickerView 的列數（只需要一列顯示星座 displayName）
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // 返回指定列的行數（在此的行數等於星座的數量）
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return zodiacSigns.count
    }
    
    // 返回指定行的標題（對應的星座名稱 displayName ）
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return zodiacSigns[row].displayName
    }
}






//import UIKit
//
//// UIPickerViewDataSource 和 UIPickerViewDelegate 是 UIPickerView 的兩個協議
//class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
//
//    // DatePicker 的 Outlet
//    @IBOutlet weak var datePicker: UIDatePicker!
//    // 閏年平年 SegmentedControl 的 Outlet
//    @IBOutlet weak var leapYearSegmentedControl: UISegmentedControl!
//    // 星期幾 SegmentedControl 的 Outlet
//    @IBOutlet weak var dayOfWeekSegmentedControl: UISegmentedControl!
//    // 農曆時間 Label
//    @IBOutlet weak var lunarYearLabel: UILabel!
//    // 當前星座的顯示 PickerView
//    @IBOutlet weak var zodiacPickerView: UIPickerView!
//    // 當前星座 ImageView
//    @IBOutlet weak var zodiacImageView: UIImageView!
//
//
//    // 星座的陣列
////    let zodiacSigns = [
////        "水瓶座（01/21~02/19）",
////        "雙魚座（02/21~03/21）",
////        "牡羊座（03/21~04/20）",
////        "金牛座（04/21~05/21）",
////        "雙子座（05/22~06/21）",
////        "巨蠍座（06/22~07/22）",
////        "獅子座（07/23~08/23）",
////        "處女座（08/24~09/23）",
////        "天秤座（09/24~10/23）",
////        "天蠍座（10/24~11/22）",
////        "射手座（11/23~12/21）",
////        "摩羯座（12/22~01/20）"
////    ]
//
//    // 星座 Struct Array
//    let zodiacSigns = [
//        ZodiacSign(displayName: "水瓶座（01/21~02/19）", imageName: "Aquarius"),
//        ZodiacSign(displayName: "雙魚座（02/21~03/21）", imageName: "Pisces"),
//        ZodiacSign(displayName: "牡羊座（03/21~04/20）", imageName: "Aries"),
//        ZodiacSign(displayName: "金牛座（04/21~05/21）", imageName: "Taurus"),
//        ZodiacSign(displayName: "雙子座（05/22~06/21）", imageName: "Gemini"),
//        ZodiacSign(displayName: "巨蠍座（06/22~07/22）", imageName: "Cancer"),
//        ZodiacSign(displayName: "獅子座（07/23~08/23）", imageName: "Leo"),
//        ZodiacSign(displayName: "處女座（08/24~09/23）", imageName: "Virgo"),
//        ZodiacSign(displayName: "天秤座（09/24~10/23）", imageName: "Libra"),
//        ZodiacSign(displayName: "天蠍座（10/24~11/22）", imageName: "Scorpio"),
//        ZodiacSign(displayName: "射手座（11/23~12/21）", imageName: "Sagittarius"),
//        ZodiacSign(displayName: "摩羯座（12/22~01/20）", imageName: "Taurus")
//    ]
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // zodiacPickerView 的資料源和代理
//        zodiacPickerView.dataSource = self
//        zodiacPickerView.delegate = self
//
//        // 獲取當前的日期和時間
//        let currentDate = Date()
//        // 更新 datePicker 的值
//        datePicker.date = currentDate
//        // 使用當前的日期和時間更新界面
//        datePickerValueChanged(datePicker)
//    }
//
//
//    // 日期的選擇（改動時間時會影響星座顯示（PickerView）、閏年平年（SegmentedControl）
//    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
//
//        // 選取的時間值
//        let selectedDate = sender.date
//
//        // 閏年平年判斷
//        let isLeapYear = checkLeapYear(birthday: selectedDate)
//        // 透過 isLeapYear 來判斷 selectedSegmentIndex
//        leapYearSegmentedControl.selectedSegmentIndex = isLeapYear ? 1 : 0
//
//        // 判斷星期幾
//        updateDayOfWeekSegmentedControl(for: selectedDate)
//
//        // 農曆年
//        calcuateLunarYear(from: selectedDate)
//
//        // 更新 UIPickerView
//        // 得到星座名稱
//        let zodiacSign = calculateZodiac(from: selectedDate)
//
//        // 查找該星座名稱的索引
//        if let index = zodiacSigns.firstIndex(of: zodiacSign) {
//            zodiacPickerView.selectRow(index, inComponent: 0, animated: true)
//        } else {
//            print("找不到對應的星座")
//        }
//
//    }
//
//    // 判斷閏年平年
//    func checkLeapYear(birthday: Date) -> Bool {
//
//        let calendar = Calendar.current
//        let year = calendar.component(.year, from: birthday)
//
//        // 閏年的條件
//        if year % 4 == 0 {
//            if year % 100 != 0 {
//                return true
//            } else {
//                if year % 400 == 0 {
//                    return true
//                }
//            }
//        }
//        // 平年
//        return false
//    }
//
//    // 判斷星期幾
//    func updateDayOfWeekSegmentedControl(for date: Date) {
//
//        let weekday = Calendar.current.component(.weekday, from: date)
//        let segmentedControlIndex = weekday - 1
//        dayOfWeekSegmentedControl.selectedSegmentIndex = segmentedControlIndex
//    }
//
//    // 判斷農曆年份（練習DateFormatter）
//    func calcuateLunarYear(from date: Date) {
//
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "zh_TW")
//        formatter.calendar = Calendar(identifier: .chinese)
//        // 將日期轉換成格式化的字串（日期風格）
//        formatter.dateStyle = .full
//
//        lunarYearLabel.text = formatter.string(from: date)
//    }
//
//    // 判斷相對應的星座
//    func calculateZodiac(from date: Date) -> ZodiacSign {
//
//        let calendar = Calendar.current
//        let birthMonth = calendar.component(.month, from: date)
//        let birthDay = calendar.component(.day, from: date)
//
////        switch (birthMonth, birthDay) {
////        case (1, 21...31), (2, 1...19):
////            return "水瓶座（01/21~02/19）"
////        case (2, 20...29), (3, 1...20):
////            return "雙魚座（02/21~03/21）"
////        case (3, 21...31), (4, 1...20):
////            return "牡羊座（03/21~04/20）"
////        case (4, 21...30), (5, 1...21):
////            return "金牛座（04/21~05/21）"
////        case (5, 22...31), (6, 1...21):
////            return "雙子座（05/22~06/21）"
////        case (6, 22...30), (7, 1...22):
////            return "巨蠍座（06/22~07/22）"
////        case (7, 23...31), (8, 1...23):
////            return "獅子座（07/23~08/23）"
////        case (8, 24...31), (9, 1...23):
////            return "處女座（08/24~09/23）"
////        case (9, 24...30), (10, 1...23):
////            return "天秤座（09/24~10/23）"
////        case (10, 24...31), (11, 1...22):
////            return "天蠍座（10/24~11/22）"
////        case (11, 23...30), (12, 1...21):
////            return "射手座（11/23~12/21）"
////        case (12, 22...31), (1, 1...20):
////            return "摩羯座（12/22~01/20）"
////        default:
////            return "無效日期"
////        }
//
//        switch (birthMonth, birthDay) {
//        case (1, 21...31), (2, 1...19):
//            return ZodiacSign(displayName: "水瓶座（01/21~02/19）", imageName: "Aquarius")
//        case (2, 20...29), (3, 1...20):
//            return ZodiacSign(displayName: "雙魚座（02/21~03/21）", imageName: "Pisces")
//        case (3, 21...31), (4, 1...20):
//            return ZodiacSign(displayName: "牡羊座（03/21~04/20）", imageName: "Aries")
//        case (4, 21...30), (5, 1...21):
//            return ZodiacSign(displayName: "金牛座（04/21~05/21）", imageName: "Taurus")
//        case (5, 22...31), (6, 1...21):
//            return ZodiacSign(displayName: "雙子座（05/22~06/21）", imageName: "Gemini")
//        case (6, 22...30), (7, 1...22):
//            return ZodiacSign(displayName: "巨蠍座（06/22~07/22）", imageName: "Cancer")
//        case (7, 23...31), (8, 1...23):
//            return ZodiacSign(displayName: "獅子座（07/23~08/23）", imageName: "Leo")
//        case (8, 24...31), (9, 1...23):
//            return ZodiacSign(displayName: "處女座（08/24~09/23）", imageName: "Virgo")
//        case (9, 24...30), (10, 1...23):
//            return ZodiacSign(displayName: "天秤座（09/24~10/23）", imageName: "Libra")
//        case (10, 24...31), (11, 1...22):
//            return ZodiacSign(displayName: "天蠍座（10/24~11/22）", imageName: "Scorpio")
//        case (11, 23...30), (12, 1...21):
//            return ZodiacSign(displayName: "射手座（11/23~12/21）", imageName: "Sagittarius")
//        case (12, 22...31), (1, 1...20):
//            return ZodiacSign(displayName: "摩羯座（12/22~01/20）", imageName: "Taurus")
//        default:
//            return ZodiacSign(displayName: "查無星座", imageName: "question mark")
//        }
//    }
//
//
//    // PickerView 的 dataSource 和 delegate 方法
//    // 要求返回 UIPickerView 的列數
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    // 要求返回每列的行數（返回星座名稱）
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return zodiacSigns.count
//    }
//
//    // 返回每行的標題
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return zodiacSigns[row]
//    }
//}
