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
        static let currencyPickerFromCurrencyTag = 1
        static let currencyPickerToCurrencyTag = 2
    }
    
    // MARK: Properties
    
    private let viewModel: ConverterViewModelProtocol
    private let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 2
        return numberFormatter
    }()
    
    // MARK: UI elements
    
    private let contentStackView = UIStackView(axis: .vertical, spacing: 40)
    private let currenciesStackView = UIStackView(axis: .vertical, spacing: 20)
    private let fromCurrencyStackView = UIStackView(axis: .horizontal, spacing: 10)
    private let fromCurrencyTitleLabel = UILabel()
    private let fromCurrencyButton = UIButton(type: .custom)
    private let toCurrencyStackView = UIStackView(axis: .horizontal, spacing: 10)
    private let toCurrencyTitleLabel = UILabel()
    private let toCurrencyButton = UIButton(type: .custom)
    private let valueToConvertContainerView = UIView()
    private let valueToConvertTextField = DecimalTextField()
    private let valueToConvertUnderlineView = UIView()
    private let valueToReceiveContainerView = UIView()
    private let valueToReceiveLabel = UILabel()
    private let valueToReceiveUnderlineView = UIView()
    private let notesLabel = UILabel()
    private let errorStackView = UIStackView(axis: .vertical, spacing: 10)
    private let errorTitleLabel = UILabel()
    private let errorDetailsLabel = UILabel()
    private let invisibleCurrencyTextField = UITextField()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    
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
        setupGestures()
        bind()
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideKeyboard()
        viewModel.viewWillDisappear()
    }
}

// MARK: - Actions

private extension ConverterViewController {
    
    @objc func onFromCurrencyTouchUpInside(_ sender: UIButton) {
        hideKeyboard()
        selectInPicker(currency: viewModel.fromCurrency.value)
        invisibleCurrencyTextField.tag = Constants.currencyPickerFromCurrencyTag
        invisibleCurrencyTextField.becomeFirstResponder()
    }
    
    @objc func onToCurrencyTouchUpInside(_ sender: UIButton) {
        hideKeyboard()
        selectInPicker(currency: viewModel.toCurrency.value)
        invisibleCurrencyTextField.tag = Constants.currencyPickerToCurrencyTag
        invisibleCurrencyTextField.becomeFirstResponder()
    }
    
    @objc func onPickerCancelPressed(_ sender: UIBarButtonItem) {
        invisibleCurrencyTextField.resignFirstResponder()
    }
    
    @objc func onPickerSelectPressed(_ sender: UIBarButtonItem) {
        invisibleCurrencyTextField.resignFirstResponder()
        guard let picker = invisibleCurrencyTextField.inputView as? UIPickerView else { return }
        let idx = picker.selectedRow(inComponent: 0)
        let supportedCurrencies = viewModel.supportedCurrencies.value
        guard idx < supportedCurrencies.count else { return }
        let currency = supportedCurrencies[idx]
        switch invisibleCurrencyTextField.tag {
        case Constants.currencyPickerFromCurrencyTag:
            viewModel.didChangeFromCurrency(to: currency)
        case Constants.currencyPickerToCurrencyTag:
            viewModel.didChangeToCurrency(to: currency)
        default:
            break
        }
    }
    
    @objc func onValueToConvertTextFieldValueChanged(_ sender: UITextField) {
        let text = (sender.text ?? "").replacingOccurrences(of: numberFormatter.decimalSeparator, with: ".")
        print("value to convert is changed to \(text)")
        viewModel.didChangeOriginalValue(to: text.doubleValue ?? 0)
    }
}

// MARK: - Private methods

private extension ConverterViewController {
    
    func setupViewHierarchy() {
        view.addSubview(contentStackView)
        contentStackView.addArrangedSubview(currenciesStackView)
        currenciesStackView.addArrangedSubview(fromCurrencyStackView)
        fromCurrencyStackView.addArrangedSubview(fromCurrencyTitleLabel)
        fromCurrencyStackView.addArrangedSubview(valueToConvertContainerView)
        valueToConvertContainerView.addSubview(valueToConvertTextField)
        valueToConvertContainerView.addSubview(valueToConvertUnderlineView)
        fromCurrencyStackView.addArrangedSubview(fromCurrencyButton)
        currenciesStackView.addArrangedSubview(toCurrencyStackView)
        toCurrencyStackView.addArrangedSubview(toCurrencyTitleLabel)
        toCurrencyStackView.addArrangedSubview(valueToReceiveContainerView)
        valueToReceiveContainerView.addSubview(valueToReceiveLabel)
        valueToReceiveContainerView.addSubview(valueToReceiveUnderlineView)
        valueToReceiveContainerView.addSubview(activityIndicator)
        toCurrencyStackView.addArrangedSubview(toCurrencyButton)
        contentStackView.addArrangedSubview(notesLabel)
        contentStackView.addArrangedSubview(errorStackView)
        errorStackView.addArrangedSubview(errorTitleLabel)
        errorStackView.addArrangedSubview(errorDetailsLabel)
        view.addSubview(invisibleCurrencyTextField)
    }
    
    func setupViewConstraints() {
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(40)
            $0.width.equalToSuperview().multipliedBy(UIDevice.current.isIPad ? 0.6 : 0.9)
            $0.centerX.equalToSuperview()
        }
        fromCurrencyTitleLabel.snp.makeConstraints {
            $0.width.equalTo(toCurrencyTitleLabel.snp.width)
        }
        valueToConvertTextField.snp.makeConstraints {
            $0.leading.trailing.centerY.equalToSuperview()
        }
        valueToConvertUnderlineView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(valueToConvertTextField.snp.horizontalEdges)
            $0.top.equalTo(valueToConvertTextField.snp.bottom)
            $0.height.equalTo(1)
        }
        valueToReceiveLabel.snp.makeConstraints {
            $0.leading.trailing.centerY.equalToSuperview()
            $0.height.equalTo(valueToConvertTextField.snp.height)
        }
        valueToReceiveUnderlineView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(valueToReceiveLabel.snp.horizontalEdges)
            $0.top.equalTo(valueToReceiveLabel.snp.bottom)
            $0.height.equalTo(1)
        }
        activityIndicator.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
        }
        [fromCurrencyButton, toCurrencyButton].forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(Constants.currencyButtonWidth)
                $0.height.equalTo(Constants.currencyButtonHeight)
            }
        }
        invisibleCurrencyTextField.snp.makeConstraints {
            $0.size.equalTo(1)
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
        [valueToConvertContainerView, valueToReceiveContainerView].forEach {
            $0.applyStyle(.transparent)
        }
        [valueToConvertUnderlineView, valueToReceiveUnderlineView].forEach {
            $0.applyStyle(.underline)
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
        fromCurrencyButton.addTarget(self, action: #selector(onFromCurrencyTouchUpInside(_:)), for: .touchUpInside)
        toCurrencyButton.addTarget(self, action: #selector(onToCurrencyTouchUpInside(_:)), for: .touchUpInside)
        valueToConvertTextField.addTarget(self, action: #selector(onValueToConvertTextFieldValueChanged(_:)), for: .editingChanged)
        valueToConvertTextField.applyStyle(.numeric)
        valueToReceiveLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        activityIndicator.hidesWhenStopped = true
        currenciesStackView.distribution = .fillEqually
        
        fromCurrencyTitleLabel.text = viewModel.fromCurrencyTitle
        toCurrencyTitleLabel.text = viewModel.toCurrencyTitle
        valueToConvertTextField.placeholder = viewModel.valueToConvertPlaceholder
        notesLabel.text = viewModel.notes
        errorTitleLabel.text = viewModel.errorTitle
        invisibleCurrencyTextField.alpha = 0
        invisibleCurrencyTextField.inputView = {
            let picker = UIPickerView()
            (picker.delegate, picker.dataSource) = (self, self)
            picker.backgroundColor = view.backgroundColor
            return picker
        }()
        createCurrenciesToolBar(invisibleCurrencyTextField)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func setupGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func bind() {
        viewModel.fromCurrency.observe(on: self) { [weak self] in self?.updateFromCurrency($0?.id) }
        viewModel.toCurrency.observe(on: self) { [weak self] in self?.updateToCurrency($0?.id) }
        viewModel.convertedValue.observe(on: self) { [ weak self] in self?.updateConvertedValue($0)}
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0?.localizedDescription) }
        viewModel.supportedCurrencies.observe(on: self) {[weak self] _ in
            Task { await self?.updateSupportedCurrencies() }
        }
        viewModel.isConversionActive.observe(on: self) { [weak self] isActive in
            Task { await self?.updateRequestActivity(isActive: isActive) }
        }
    }
    
    func updateFromCurrency(_ currency: String?) {
        fromCurrencyButton.setTitle(currency ?? "-", for: .normal)
    }
    
    func updateToCurrency(_ currency: String?) {
        toCurrencyButton.setTitle(currency ?? "-", for: .normal)
    }
    
    func updateConvertedValue(_ value: String?) {
        guard let value = value else {
            valueToReceiveLabel.text = "---"
            return
        }
        if let doubleValue = value.doubleValue {
            // change format using decimal separator for current locale
            valueToReceiveLabel.text = numberFormatter.string(from: NSNumber(floatLiteral: doubleValue))
        } else {
            valueToReceiveLabel.text = value
        }
        
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
    
    func updateSupportedCurrencies() async {
        guard let picker = invisibleCurrencyTextField.inputView as? UIPickerView else { return }
        picker.reloadAllComponents()
    }
    
    func updateRequestActivity(isActive: Bool) async {
        isActive ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    func createCurrenciesToolBar(_ textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = false
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(systemItem: .cancel)
        cancelButton.action = #selector(onPickerCancelPressed(_:))
        let selectButton = UIBarButtonItem(systemItem: .done)
        selectButton.action = #selector(onPickerSelectPressed(_:))
        toolBar.setItems([cancelButton, space, selectButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        textField.inputAccessoryView = toolBar
    }
    
    func selectInPicker(currency: Currency?) {
        guard let currency = currency,
              let picker = invisibleCurrencyTextField.inputView as? UIPickerView,
              let idx = viewModel.supportedCurrencies.value.firstIndex(of: currency) else { return }
        picker.selectRow(idx, inComponent: 0, animated: false)
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension ConverterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.supportedCurrencies.value.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        viewModel.supportedCurrencies.value[row].id
    }
}
