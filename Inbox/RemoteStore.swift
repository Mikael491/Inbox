//
//  RemoteStore.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 12/14/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import Foundation

protocol RemoteStore {
    func signUp(phoneNumber: String, email: String, password: String, success: ()->(), error: (_ errorMessage: String)->())
    func startSyncing()
}
