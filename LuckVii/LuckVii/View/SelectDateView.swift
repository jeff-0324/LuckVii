//
//  SelectDateView.swift
//  LuckVii
//
//  Created by 손겸 on 12/17/24.
//

import UIKit
import SnapKit

final class SelectDateView: UIView {

    // 컬렉션뷰 데이터
    let startTime = ["07:00", "09:00", "11:00", "13:00", "15:00", "17:00", "19:00", "21:00"]
    let endTime = ["08:50", "10:50", "12:50", "14:50", "16:50", "18:50", "20:50", "22:50"]
    var selectedItemOfIndex = 0 // 컬렉션뷰 선택된 아이템 인덱스 저장

    // 달력 뷰
    var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        var components = DateComponents()
        components.day = 14
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        picker.minimumDate = Date() // 최소 날짜는 오늘로 설정
        picker.maximumDate = Calendar.autoupdatingCurrent.date(byAdding: components, to: Date()) // 최대 선택 날짜는 + 14일
        picker.date = Date() // 최초 선택 날짜 오늘로 설정
        picker.tintColor = .systemGreen
        picker.locale = Locale(identifier: "ko_KR")
        picker.addTarget(self, action: #selector(changedDate), for: .valueChanged)
        return picker
    }()

    var bottomButtonView = BottomButonView()

    var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 6

        return button
    }()

    private let timeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.itemSize = .init(width: 70, height: 70)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TimeCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()

    // 시간 선택
    public let timePicker: UIPickerView = {
        let picker = UIPickerView()

        return picker
    }()

    // 선택된 시간
    public var selectedTime: String?

    // 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupTimeCollectionView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        [
            datePicker,
            timeCollectionView,
            bottomButtonView
        ].forEach { addSubview($0) }

        let safeArea = self.safeAreaLayoutGuide

        // 제약 조건
        datePicker.snp.makeConstraints {
            $0.top.equalTo(safeArea.snp.top).offset(10)
            $0.centerX.equalToSuperview()
        }

        timeCollectionView.snp.makeConstraints {
            $0.top.equalTo(datePicker.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(180)
        }

        bottomButtonView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.bottom.equalTo(safeArea.snp.bottom).inset(10)
            $0.height.equalTo(50)
        }
    }

    private func setupTimeCollectionView() {
        timeCollectionView.dataSource = self
        timeCollectionView.delegate = self
    }

    @objc func changedDate() {
        selectedItemOfIndex = 0
        timeCollectionView.reloadData()
    }
}
