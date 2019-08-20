//
//  ValidationError.swift
//  TrainingTask
//
//  Created by Vadzim Sasnouski on 8/9/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation
import SwiftyJSON

enum ValidationError: Error {
	case parsingError
	case jsonDataError
	case serverError
}

extension ValidationError {
	var errorDescription: String? {
		switch self {
		case .parsingError:
			return NSLocalizedString("Parsing error", comment: "")
		case .jsonDataError:
			return NSLocalizedString(SwiftyJSONError.invalidJSON.localizedDescription, comment: "")
		case .serverError:
			return NSLocalizedString("Server error", comment: "")
		}
	}
}
