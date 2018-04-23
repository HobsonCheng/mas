//
//  SettingViewModel.swift
//  UIDS
//
//  Created by one2much on 2018/1/25.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import Differentiator

public enum SettingViewModelType {
    case none                             // 未知
    case mine                             // 我的
    case setting                          // 设置
}


class SettingViewModel: NSObject {
    let vmDatas = Variable<[[SettingCellModel]]>([])
}


extension SettingViewModel: ViewModelType {
    
    typealias Input = SettingInput
    typealias Output = SettingOutput
    
    struct SettingInput {
        
        let type: SettingViewModelType
        
        init(type: SettingViewModelType) {
            self.type = type
        }
    }
    
    struct SettingOutput {
        
        let sections: Driver<[SettingSection]>
        
        init(sections: Driver<[SettingSection]>) {
            self.sections = sections
        }
    }
    
    func transform(input: SettingViewModel.SettingInput) -> SettingViewModel.SettingOutput {
        
        let temp_sections = self.vmDatas.asObservable().map({ (sections) -> [SettingSection] in
            return sections.map({ (models) -> SettingSection in
                return SettingSection(items: models)
            })
        }).asDriver(onErrorJustReturn: [])
        
        let output = SettingOutput(sections: temp_sections)
        
        let sectionArr: [[SettingCellModel]]
        
        switch input.type {
        case .none:
            sectionArr = []
            break
        case .setting:
            sectionArr = SetConfig.loadSettingModels()
            break
        case .mine:
            sectionArr = SetConfig.loadMineModels()
            break
        }
        self.vmDatas.value = sectionArr
        
        return output
    }
}

struct SettingSection {
    
    var items: [Item]
}

extension SettingSection: SectionModelType {
    typealias Item = SettingCellModel
    
    init(original: SettingSection, items: [SettingCellModel]) {
        self = original
        self.items = items
    }
}
