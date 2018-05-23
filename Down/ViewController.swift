//
//  ViewController.swift
//  Down
//
//  Created by K. Berk Cebi on 5/23/18.
//  Copyright © 2018 Zeplin, Inc. All rights reserved.
//

import AppKit

import Alamofire

final class ViewController: NSViewController {
    
    // MARK: Constants
    
    private static let urlString = "https://raw.githubusercontent.com/Alamofire/Alamofire/master/alamofire.png"
    
    private static let applicationSupportDirectoryURL: URL = {
        guard
            let applicationSupportDirectoryURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first,
            let bundleIdentifier = Bundle.main.bundleIdentifier
        else {
            fatalError("Locating application support directory url failed.")
        }
        
        return applicationSupportDirectoryURL.appendingPathComponent(bundleIdentifier)
    }()
    
    private static let width: CGFloat = 800.0
    private static let margin: CGFloat = 20.0
    
    // MARK: Properties
    
    private let urlTextField = NSTextField(string: ViewController.urlString)
    
    private let descriptionTextField: NSTextField = {
        let textField = NSTextField(labelWithString: "—")
        textField.isSelectable = true
        textField.usesSingleLineMode = false
        textField.lineBreakMode = .byWordWrapping
        textField.textColor = .lightGray
        
        return textField
    }()
    
    // MARK: NSViewController
    
    override func loadView() {
        self.view = NSView()
        
        urlTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(urlTextField)
        
        let downloadTaskButton = NSButton(title: "Use Download Task", target: self, action: #selector(downloadButtonClicked))
        downloadTaskButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(downloadTaskButton)
        
        let dataRequestButton = NSButton(title: "Make Data Request", target: self, action: #selector(dataRequestButtonClicked))
        dataRequestButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dataRequestButton)
        
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionTextField)
        
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: ViewController.width),
            urlTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: ViewController.margin),
            urlTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: ViewController.margin),
            downloadTaskButton.leftAnchor.constraint(equalTo: urlTextField.rightAnchor, constant: ViewController.margin),
            downloadTaskButton.topAnchor.constraint(equalTo: view.topAnchor, constant: ViewController.margin),
            dataRequestButton.leftAnchor.constraint(equalTo: downloadTaskButton.rightAnchor, constant: ViewController.margin),
            dataRequestButton.topAnchor.constraint(equalTo: view.topAnchor, constant: ViewController.margin),
            dataRequestButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -ViewController.margin),
            descriptionTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: ViewController.margin),
            descriptionTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -ViewController.margin),
            descriptionTextField.topAnchor.constraint(equalTo: urlTextField.bottomAnchor, constant: ViewController.margin),
            descriptionTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -ViewController.margin)
        ])
    }
    
    // MARK: Actions
    
    @objc private func downloadButtonClicked(sender: Any) {
        let urlString = urlTextField.stringValue
        let fileURL = ViewController.applicationSupportDirectoryURL.appendingPathComponent("downloadTask.png")
        let downloadDestination: DownloadRequest.DownloadFileDestination = { _,_ in (fileURL, [.removePreviousFile, .createIntermediateDirectories]) }
        
        descriptionTextField.stringValue = "…"
        Alamofire.download(urlString, to: downloadDestination).validate().response { [weak self] response in
            guard
                let destinationURL = response.destinationURL,
                let fileAttributes = try? FileManager.default.attributesOfItem(atPath: destinationURL.path),
                let posixPermissions = fileAttributes[.posixPermissions]
            else {
                self?.descriptionTextField.stringValue = "Reading file permissions at \(fileURL) failed."
                
                return
            }
            
            self?.descriptionTextField.stringValue = "Permissions \(posixPermissions) at \(destinationURL.path)."
        }
    }
    
    @objc private func dataRequestButtonClicked(sender: Any) {
        let urlString = urlTextField.stringValue
        let fileURL = ViewController.applicationSupportDirectoryURL.appendingPathComponent("dataRequest.png")
        
        // Remove previous file, when exists.
        try? FileManager.default.removeItem(at: fileURL)
        
        descriptionTextField.stringValue = "…"
        Alamofire.request(urlString).validate().responseData { [weak self] response in
            switch response.result {
            case let .success(data):
                do {
                    try data.write(to: fileURL)
                } catch {
                    self?.descriptionTextField.stringValue = "Writing file to \(fileURL.path) failed with error \(error)."
                }
                
                guard
                    let fileAttributes = try? FileManager.default.attributesOfItem(atPath: fileURL.path),
                    let posixPermissions = fileAttributes[.posixPermissions]
                else {
                    self?.descriptionTextField.stringValue = "Reading file permissions at \(fileURL.path) failed."
                    
                    return
                }
                
                self?.descriptionTextField.stringValue = "Permissions \(posixPermissions) at \(fileURL.path)."
            case let .failure(error):
                self?.descriptionTextField.stringValue = "Requesting data failed with error \(error)."
            }
        }
    }
}
