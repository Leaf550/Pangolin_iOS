//
//  ViewController.swift
//  RxTest
//
//  Created by 方昱恒 on 2021/12/23.
//

import UIKit
import RxSwift

// 页面基类，支持利用RxSwift实现的MVVM。可在此扩展其他功能。
open class ViewController<VM: ViewModel>: UIViewController {
 
    public var viewModel: VM?
    public let disposeBag = DisposeBag()
    
    public init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    open func bindViewModel() { }
    
}
