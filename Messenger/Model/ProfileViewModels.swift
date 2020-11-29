//
//  ProfileViewModels.swift
//  Messenger
//
//  Created by Valerian   on 29/11/2020.
//

import Foundation

enum ProfileViewModelType {
    case info, logout
}

struct ProfileViewModel {
    let viewModelType: ProfileViewModelType
    let title: String
    let handler: (() -> Void)?
}
