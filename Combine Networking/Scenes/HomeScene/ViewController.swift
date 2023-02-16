//
//  ViewController.swift
//  Combine Networking
//
//  Created by Ali Fayed on 15/02/2023.
//
import UIKit
class ViewController: UIViewController {
    private var viewModel = ViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetch()
    }
}
