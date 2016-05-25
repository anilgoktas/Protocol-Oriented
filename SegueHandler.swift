//
//  SegueHandler.swift
//
//
//  Created by Anıl Göktaş on 4/30/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Foundation

protocol SegueHandler {
    associatedtype SegueIdentifier: RawRepresentable
}

extension SegueHandler where Self: UIViewController, SegueIdentifier.RawValue == String {

    func performSegueWithIdentifier(segueIdentifier: SegueIdentifier, sender: AnyObject?) {
        performSegueWithIdentifier(segueIdentifier.rawValue, sender: sender)
    }

    func segueIdentifier(segue segue: UIStoryboardSegue) -> SegueIdentifier {
        guard
        let identifier = segue.identifier,
        let segueIdentifier = SegueIdentifier(rawValue: identifier)
        else { fatalError("Invalid segue identifier \(segue.identifier).") }

        return segueIdentifier
    }

}
