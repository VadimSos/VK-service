//
//  ValidationError.swift
//  TrainingTask
//
//  Created by Vadzim Sasnouski on 8/9/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation

enum ValidationError: Error {
	case requestError
	case parsingError
}

extension ValidationError {
	var errorDescription: String? {
		switch self {
		case .requestError:
			return NSLocalizedString("Request error", comment: "")
		case .parsingError:
			return NSLocalizedString("Parsing error", comment: "")
		}
	}
}
