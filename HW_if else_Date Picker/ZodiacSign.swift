//
//  ZodiacSign.swift
//  HW_if else_Date Picker
//
//  Created by 曹家瑋 on 2023/6/23.
//

import Foundation

// ZodiacSign 代表星座
// 使用 Equatable，藉此使用 firstIndex(of:) 方法在一個 ZodiacSign 數組中找到特定的 ZodiacSign 對象的索引。
struct ZodiacSign: Equatable {
    
    let displayName: String             // 星座的名稱以及日期範圍（pickerView 中顯示）
    let imageName: String               // 對應星座圖片的名稱
}
