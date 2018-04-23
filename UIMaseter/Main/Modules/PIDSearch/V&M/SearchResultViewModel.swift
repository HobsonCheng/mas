//
//  SearchResultViewModel.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 4/3/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import RxSwift
import RxCocoa
import RxSwift
import NSObject_Rx
import Differentiator

class SearchResultViewModel: NSObject {
    

    //创建监听对象
    var searchList = Variable([SectionModel<String, Project>]())
    
    let searchUseable: Driver<String>
    
    init(searchBar: UITextField) {
        let searchDriver =  searchBar.rx.text.orEmpty.asDriver()
        
        searchUseable = searchDriver.skip(1).flatMapLatest { status in
            
            return  Observable.just(status).asDriver(onErrorJustReturn: "error")
        }
    }
    
    func getSearchEnd(loadMode: Bool,params: NSMutableDictionary,callback: @escaping (_ noMove: Bool)->()) {

        ApiUtil.share.searchProject(params: params) { [weak self] (status, data, msg) in

            let search = SearchModel.deserialize(from: data)
            
            var list = search?.data.projects
            if loadMode {
                let mylist = self?.searchList.value[0].items
                
                list = mylist! + list!
            }
            
            let section = [SectionModel(model: "", items: (list)!)]
            
            self?.searchList.value = section
            
            if search?.data.projects.count == search?.data.total {
                callback(true)
            }else {
                callback(false)
            }
        }
        
    }
    
}

