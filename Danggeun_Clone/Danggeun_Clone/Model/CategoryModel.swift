//
//  CategoryModel.swift
//  Danggeun_Clone
//
//  Created by PKW on 2022/05/12.
//

import Foundation

struct CategoryModel {
    let categoryName: String
    var isSelected: Bool
    
    static func configureCategoryList() -> [CategoryModel] {
        return [
            CategoryModel(categoryName: "디지털기기", isSelected: false),
            CategoryModel(categoryName: "생활가전", isSelected: false),
            CategoryModel(categoryName: "가구/인테리어", isSelected: false),
            CategoryModel(categoryName: "유아동", isSelected: false),
            CategoryModel(categoryName: "생활/가공식품", isSelected: false),
            CategoryModel(categoryName: "유아도서", isSelected: false),
            CategoryModel(categoryName: "스포츠/레저", isSelected: false),
            CategoryModel(categoryName: "여성잡화", isSelected: false),
            CategoryModel(categoryName: "여성의류", isSelected: false),
            CategoryModel(categoryName: "남성패션/잡화", isSelected: false),
            CategoryModel(categoryName: "게임/취미", isSelected: false),
            CategoryModel(categoryName: "뷰티/미용", isSelected: false),
            CategoryModel(categoryName: "반려동물물품", isSelected: false),
            CategoryModel(categoryName: "도서/티켓/음반", isSelected: false),
            CategoryModel(categoryName: "식물", isSelected: false),
            CategoryModel(categoryName: "기타 중고물품", isSelected: false),
            CategoryModel(categoryName: "삽니다", isSelected: false)
        ]
    }
}
