//
//  HttpStatus.swift
//
//
//  Created by Jonathan Bereyziat on 09/01/2024.
//

import SwiftUI

enum HttpStatus: Int {
    case http100Continue = 100
    case http101SwitchingProtocols = 101
    case http102Processing = 102
    case http200Ok = 200
    case http201Created = 201
    case http202Accepted = 202
    case http203NonAuthoritativeInformation = 203
    case http204NoContent = 204
    case http205ResetContent = 205
    case http206PartialContent = 206
    case http207MultiStatus = 207
    case http208AlreadyReported = 208
    case http226ImUsed = 226
    case http300MultipleChoices = 300
    case http301MovedPermanently = 301
    case http302Found = 302
    case http303SeeOther = 303
    case http304NotModified = 304
    case http305UseProxy = 305
    case http306SwitchProxy = 306
    case http307TemporaryRedirect = 307
    case http308PermanentRedirect = 308
    case http400BadRequest = 400
    case http401Unauthorized = 401
    case http402PaymentRequired = 402
    case http403Forbidden = 403
    case http404NotFound = 404
    case http405MethodNotAllowed = 405
    case http406NotAcceptable = 406
    case http407ProxyAuthenticationRequired = 407
    case http408RequestTimeout = 408
    case http409Conflict = 409
    case http410Gone = 410
    case http411LengthRequired = 411
    case http412PreconditionFailed = 412
    case http413PayloadTooLarge = 413
    case http414UriTooLong = 414
    case http415UnsupportedMediaType = 415
    case http416RangeNotSatisfiable = 416
    case http417ExpectationFailed = 417
    case http418ImATeapot = 418
    case http421MisdirectedRequest = 421
    case http422UnprocessableEntity = 422
    case http423Locked = 423
    case http424FailedDependency = 424
    case http425UnorderedCollection = 425
    case http426UpgradeRequired = 426
    case http428PreconditionRequired = 428
    case http429TooManyRequests = 429
    case http431RequestHeaderFieldsTooLarge = 431
    case http451UnavailableForLegalReasons = 451
    case http500InternalServerError = 500
    case http501NotImplemented = 501
    case http502BadGateway = 502
    case http503ServiceUnavailable = 503
    case http504GatewayTimeout = 504
    case http505HttpVersionNotSupported = 505
    case http506VariantAlsoNegotiates = 506
    case http507InsufficientStorage = 507
    case http508LoopDetected = 508
    case http510NotExtended = 510
    case http511NetworkAuthenticationRequired = 511
}
