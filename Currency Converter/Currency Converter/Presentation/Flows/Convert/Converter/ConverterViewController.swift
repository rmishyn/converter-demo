//
//  ConverterViewController.swift
//  currency converter
//
//  Created by Ruslan Mishyn on 23.05.2024.
//

import UIKit
import SnapKit

@MainActor
class ConverterViewController: UIViewController {
    
    struct Constants {
        static let currencyButtonWidth: CGFloat = 55
        static let currencyButtonHeight: CGFloat = 44
    }
    
    // MARK: Properties
    
    private let viewModel: ConverterViewModelProtocol
    
    // MARK: UI elements
    
    private var contentStackView = UIStackView(axis: .vertical, spacing: 40)
    private var currenciesStackView = UIStackView(axis: .vertical, spacing: 20)
    private var fromCurrencyStackView = UIStackView(axis: .horizontal, spacing: 10)
    private var fromCurrencyTitleLabel = UILabel()
    private var fromCurrencyButton = UIButton(type: .custom)
    private var toCurrencyStackView = UIStackView(axis: .horizontal, spacing: 10)
    private var toCurrencyTitleLabel = UILabel()
    private var toCurrencyButton = UIButton(type: .custom)
    private var valueToConvertTextField = UITextField()
    private var valueToReceiveLabel = UILabel()
    private var notesLabel = UILabel()
    private var errorStackView = UIStackView(axis: .vertical, spacing: 10)
    private var errorTitleLabel = UILabel()
    private var errorDetailsLabel = UILabel()
    
    // MARK: Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(viewModel: ConverterViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBehaviours()
        bind()
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        valueToConvertTextField.becomeFirstResponder()
        viewModel.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        viewModel.viewWillDisappear()
    }
}

// MARK: - Private methods

private extension ConverterViewController {
    
    func setupViewHierarchy() {
        view.addSubview(contentStackView)
        contentStackView.addArrangedSubview(currenciesStackView)
        currenciesStackView.addArrangedSubview(fromCurrencyStackView)
        fromCurrencyStackView.addArrangedSubview(fromCurrencyTitleLabel)
        fromCurrencyStackView.addArrangedSubview(valueToConvertTextField)
        fromCurrencyStackView.addArrangedSubview(fromCurrencyButton)
        currenciesStackView.addArrangedSubview(toCurrencyStackView)
        toCurrencyStackView.addArrangedSubview(toCurrencyTitleLabel)
        toCurrencyStackView.addArrangedSubview(valueToReceiveLabel)
        toCurrencyStackView.addArrangedSubview(toCurrencyButton)
        contentStackView.addArrangedSubview(notesLabel)
        contentStackView.addArrangedSubview(errorStackView)
        errorStackView.addArrangedSubview(errorTitleLabel)
        errorStackView.addArrangedSubview(errorDetailsLabel)
    }
    
    func setupViewConstraints() {
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges).inset(20)
        }
        fromCurrencyTitleLabel.snp.makeConstraints {
            $0.width.equalTo(toCurrencyTitleLabel.snp.width)
        }
        [fromCurrencyButton, toCurrencyButton].forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(Constants.currencyButtonWidth)
                $0.height.equalTo(Constants.currencyButtonHeight)
            }
        }
    }
    
    func setupViews() {
        title = viewModel.screenTitle
        navigationItem.title = viewModel.screenTitle
        
        setupViewHierarchy()
        setupViewConstraints()
        
        // General styling
        view.applyStyle(.screenView)
        [contentStackView, currenciesStackView, fromCurrencyStackView, toCurrencyStackView, errorStackView].forEach {
            $0.applyStyle(.transparent)
        }
        [fromCurrencyTitleLabel, toCurrencyTitleLabel].forEach {
            $0.applyStyle(.itemTitle)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        }
        valueToReceiveLabel.applyStyle(.itemTitle)
        notesLabel.applyStyle(.explanation)
        errorTitleLabel.applyStyle(.errorTitle)
        errorDetailsLabel.applyStyle(.errorDetails)
        [fromCurrencyButton, toCurrencyButton].forEach {
            $0.applyStyle(.selectCurrency)
        }
        valueToConvertTextField.applyStyle(.numeric)
        
        valueToReceiveLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        //valueToReceiveLabel.textAlignment = .right
        currenciesStackView.distribution = .fillEqually
        
        fromCurrencyTitleLabel.text = viewModel.fromCurrencyTitle
        toCurrencyTitleLabel.text = viewModel.toCurrencyTitle
        valueToConvertTextField.placeholder = viewModel.valueToConvertPlaceholder
        notesLabel.text = viewModel.notes
        errorTitleLabel.text = viewModel.errorTitle
    }
    
    func setupBehaviours() {
        // TODO: setup behaviours
    }
    
    func bind() {
        viewModel.fromCurrency.observe(on: self) { [weak self] in self?.updateFromCurrency($0?.id) }
        viewModel.toCurrency.observe(on: self) { [weak self] in self?.updateToCurrency($0?.id) }
        viewModel.convertedValue.observe(on: self) { [ weak self] in self?.updateConvertedValue($0)}
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0?.localizedDescription) }
    }
    
    func updateFromCurrency(_ currency: String?) {
        fromCurrencyButton.setTitle(currency ?? "-", for: .normal)
    }
    
    func updateToCurrency(_ currency: String?) {
        toCurrencyButton.setTitle(currency ?? "-", for: .normal)
    }
    
    func updateConvertedValue(_ value: String?) {
        valueToReceiveLabel.text = value ?? "---"
    }
    
    func showError(_ error: String?) {
        if let error = error {
            errorStackView.isHidden = false
            errorDetailsLabel.text = error
        } else {
            errorStackView.isHidden = true
            errorDetailsLabel.text = ""
        }
    }
}
