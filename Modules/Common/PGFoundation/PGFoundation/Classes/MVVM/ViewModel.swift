//
//  ViewModel.swift
//  RxTest
//
//  Created by 方昱恒 on 2021/8/23.
//

public protocol ViewModelInput { }
public protocol ViewModelOutput { }

public protocol ViewModel {
    
    associatedtype Input: ViewModelInput
    associatedtype Output: ViewModelOutput
    
    var input: Input { get set }
    
    func transformToOutput() -> Output
    
}


// 如果你的界面比较简单，不需要用到MVVM，请使用 EmptyViewModel 占位。
public struct EmptyViewModelInput: ViewModelInput { }
public struct EmptyViewModelOutput: ViewModelOutput { }

public class EmptyViewModel: ViewModel {
    
    public typealias Input = EmptyViewModelInput
    public typealias Output = EmptyViewModelOutput
    
    public var input: EmptyViewModelInput = EmptyViewModelInput()
    
    public func transformToOutput() -> EmptyViewModelOutput {
        fatalError("不能直接使用 EmptyViewModel ！！")
    }
    
}
