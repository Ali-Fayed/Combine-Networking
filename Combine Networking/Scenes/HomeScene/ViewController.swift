//
//  ViewController.swift
//  Combine Networking
//
//  Created by Ali Fayed on 15/02/2023.
//
import UIKit
import Combine
import CombineCocoa
class ViewController: UIViewController {
    private var subscribtions = Set< AnyCancellable > ()
    @IBOutlet weak var successOrFaliureLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var usersCountLabel: UILabel!
    private var viewModel = ViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    func initUI() {
        viewModel.usersPublisher.sink { completion in
            switch completion {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.successOrFaliureLabel.text = "Status: Failure"
                    self.errorMessageLabel.text = error.code?.errorDescription
                    self.usersCountLabel.text = "Count: Empty"
                }
            case .finished:
               print("finished")
            }
        } receiveValue: { values in
            DispatchQueue.main.async {
                self.successOrFaliureLabel.text = "Status: Success"
                self.errorMessageLabel.text = "Error: No Error"
                self.usersCountLabel.text = "Count: \(values.count)"
            }
        }.store(in: &subscribtions)
    }
}
