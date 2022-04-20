//
//  NewPostViewController.swift
//  BBS
//
//  Created by 方昱恒 on 2022/4/19.
//

import PGFoundation
import UIComponents
import SnapKit
import RxSwift
import RxCocoa
import Provider

class NewPostViewController: UIViewController, ViewController {
    
    typealias VM = NewPostViewModel
    
    var viewModel = NewPostViewModel()
    
    var disposeBag = DisposeBag()
    
    private var task: TaskModel
    
    private lazy var indicator = UIActivityIndicatorView(style: .medium)
    
    private lazy var postContentHintLabel: UILabel = {
        let label = UILabel()
        label.font = .textFont(for: .body, weight: .medium)
        label.text = "帖子内容："
        
        return label
    }()
    
    private lazy var textView: TextView = {
        let text = TextView()
        text.font = .textFont(for: .caption0, weight: .regular)
        text.layer.cornerRadius = 6
        text.clipsToBounds = true
        text.placeholder = "说点什么吧..."
        
        return text
    }()
    
    private lazy var todoView: BBSToDoView = {
        let todo = BBSToDoView()
        
        return todo
    }()
    
    private let completeButtonTapAction = PublishSubject<Void>()
    
    init(task: TaskModel) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        setUpSubViews()
        setUpNavagationBarButton()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func bindViewModel() {
        completeButtonTapAction
            .map { [weak self] _ in
                self?.indicator.startAnimating()
                return (self?.textView.text, self?.task.taskID)
            }
            .bind(to: viewModel.input.sendNewPostAction)
            .disposed(by: disposeBag)
        
        let output = viewModel.transformToOutput()
        
        output.sendNewPostCompleted
            .subscribe(onNext: { [weak self] result in
                self?.indicator.stopAnimating()
                switch result {
                    case .succeeded:
                        self?.dismiss(animated: true)
                        let todoService = PGProviderManager.shared.provider { ToDoProvider.self }
                        todoService?.setTaskShared(taskId: self?.task.taskID ?? "")
                    case .duplicateShare:
                        Toast.show(text: "已经分享过了...")
                    case .error:
                        Toast.show(text: "网络异常")
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setUpNavagationBarButton() {
        let leftButton = UIBarButtonItem(title: "取消", style: .plain, target: nil, action: nil)
        let rightButton = UIBarButtonItem(title: "发布", style: .done, target: nil, action: nil)
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem  = rightButton
        
        leftButton.rx.tap.bind { [weak self] _ in
            self?.dismiss(animated: true)
        }.disposed(by: disposeBag)
        
        rightButton.rx.tap
            .bind(to: completeButtonTapAction)
            .disposed(by: disposeBag)
        
        textView.rx.text.orEmpty
            .map { content in
                !content.isEmpty
            }
            .bind(to: rightButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    private func setUpSubViews() {
        view.backgroundColor = .systemGroupedBackground
        title = "发布帖子"
        
        view.addSubview(postContentHintLabel)
        view.addSubview(textView)
        view.addSubview(todoView)
        view.addSubview(indicator)
        
        todoView.configViews(with: task)
        
        postContentHintLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(64)
        }
        
        textView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(postContentHintLabel.snp.bottom).offset(10)
            make.height.equalTo(100)
        }
        
        todoView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(textView)
            make.top.equalTo(textView.snp.bottom).offset(20)
        }
        
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

}
