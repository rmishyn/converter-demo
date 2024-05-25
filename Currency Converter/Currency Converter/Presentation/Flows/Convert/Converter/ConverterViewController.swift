//
//  ConverterViewController.swift
//  currency converter
//
//  Created by Ruslan Mishyn on 23.05.2024.
//

import UIKit
import SnapKit

class ConverterViewController: UIViewController {
    
    struct Constants {
        static let currencyButtonWidth: CGFloat = 66
        static let currencyButtonHeight: CGFloat = 44
    }
    
    // MARK: Properties
    
    private let viewModel: ConverterViewModelProtocol
    
    // MARK: UI elements
    
    private var contentStackView = UIStackView(axis: .vertical, spacing: 20)
    private var currenciesStackView = UIStackView(axis: .vertical, spacing: 20)
    private var fromCurrencyStackView = UIStackView(axis: .horizontal, spacing: 10)
    private var fromCurrencyTitleLabel = UILabel()
    private var fromCurrencyButton = UIButton(type: .custom)
    private var toCurrencyStackView = UIStackView(axis: .horizontal, spacing: 10)
    private var toCurrencyTitleLabel = UILabel()
    private var toCurrencyButton = UIButton(type: .custom)
    private var amountToExchangeTextField = UITextField()
    private var amountToReceiveLabel = UILabel()
    private var notesLabel = UILabel()
    
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
}

// MARK: - Private methods

private extension ConverterViewController {
    
    func setupViews() {
        title = viewModel.screenTitle
        navigationItem.title = viewModel.screenTitle
        
        view.addSubview(contentStackView)
        contentStackView.addArrangedSubview(currenciesStackView)
        currenciesStackView.addArrangedSubview(fromCurrencyStackView)
        fromCurrencyStackView.addArrangedSubview(fromCurrencyTitleLabel)
        fromCurrencyStackView.addArrangedSubview(amountToExchangeTextField)
        fromCurrencyStackView.addArrangedSubview(fromCurrencyButton)
        currenciesStackView.addArrangedSubview(toCurrencyStackView)
        toCurrencyStackView.addArrangedSubview(toCurrencyTitleLabel)
        toCurrencyStackView.addArrangedSubview(amountToReceiveLabel)
        toCurrencyStackView.addArrangedSubview(toCurrencyButton)
        contentStackView.addArrangedSubview(notesLabel)
        
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges).inset(20)
        }
        
        view.applyStyle(.screenView)
        [contentStackView, currenciesStackView, fromCurrencyStackView, toCurrencyStackView].forEach {
            $0.applyStyle(.transparent)
        }
        [fromCurrencyTitleLabel, toCurrencyTitleLabel, amountToReceiveLabel].forEach {
            $0.applyStyle(.itemTitle)
        }
        notesLabel.applyStyle(.explanation)
        [fromCurrencyButton, toCurrencyButton].forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(Constants.currencyButtonWidth)
                $0.height.equalTo(Constants.currencyButtonHeight)
            }
            $0.applyStyle(.selectCurrency)
        }
        amountToExchangeTextField.applyStyle(.numeric)
        
        fromCurrencyTitleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        fromCurrencyTitleLabel.setContentHuggingPriority(.required, for: .horizontal)
        amountToReceiveLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        amountToReceiveLabel.textAlignment = .right
        currenciesStackView.distribution = .fillEqually
        
        fromCurrencyTitleLabel.text = viewModel.fromCurrencyTitle
        toCurrencyTitleLabel.text = viewModel.toCurrencyTitle
        amountToExchangeTextField.placeholder = viewModel.amountToExchangePlaceholder
        notesLabel.text = viewModel.notes
    }
    
    func setupBehaviours() {
        // TODO: setup behaviours
    }
    
    func bind() {
        viewModel.fromCurrency.observe(on: self) { [weak self] in self?.updateFromCurrency($0) }
        viewModel.toCurrency.observe(on: self) { [weak self] in self?.updateToCurrency($0) }
        viewModel.convertedValue.observe(on: self) { [ weak self] in self?.updateConvertedValue($0)}
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0?.localizedDescription) }
    }
    
    func updateFromCurrency(_ currency: String?) {
        fromCurrencyButton.setTitle(currency ?? "-", for: .normal)
    }
    
    func updateToCurrency(_ currency: String?) {
        toCurrencyButton.setTitle(currency ?? "-", for: .normal)
    }
    
    func updateConvertedValue(_ value: Double) {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        amountToReceiveLabel.text = formatter.string(from: NSNumber(value: value))
    }
    
    func showError(_ error: String?) {
        
    }
}
