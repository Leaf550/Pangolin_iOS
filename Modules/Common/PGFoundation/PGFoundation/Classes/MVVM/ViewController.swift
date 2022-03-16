//
//  ViewController.swift
//  RxTest
//
//  Created by 方昱恒 on 2021/12/23.
//

import UIKit
import RxSwift

// 页面基类，支持利用RxSwift实现的MVVM。可在此扩展其他功能。
public protocol ViewController {
    
    associatedtype VM: ViewModel
 
    var viewModel: VM { get set }
    var disposeBag: DisposeBag { get set }
    
    func bindViewModel()
    
}
