import Vapor
import Meta
import NStack
import SwiftyBeaverVapor
import SwiftyBeaver
import Foundation
import VaporRedis

let drop = Droplet()

drop.middleware.append(MetaMiddleware(drop: drop))
try drop.addProvider(NStackProvider(drop: drop))
try drop.addProvider(VaporRedis.Provider(config: drop.config))

/*

// Log
// set-up SwiftyBeaver logging destinations (console, file, cloud, ...)
// learn more at http://bit.ly/2ci4mMX
let console = ConsoleDestination()  // log to Xcode Console in color
let file = FileDestination()  // log to file in color
file.logFileURL = URL(fileURLWithPath: "/tmp/VaporLogs.log") // set log file
let sbProvider = SwiftyBeaverProvider(destinations: [console, file])

drop.addProvider(sbProvider)

// shortcut to avoid writing app.log all the time
let log = drop.log.self

*/


try print(drop.nstack?.application.translate.get(platform: "backend", language: "en-UK", section: "default", key: "saveSuccess", replace: ["model": "test"]))


drop.post { req in
    if req.accept.prefers("html") {
        return try drop.view.make("welcome", [
            "message": drop.localization[req.lang, "welcome", "title"]
            ])
    } else {
        return JSON(["json"])
    }
}

drop.get { req in
    if req.accept.prefers("html") {
        return try drop.view.make("welcome", [
            "message": drop.localization[req.lang, "welcome", "title"]
            ])
    } else {
        return JSON(["json"])
    }
}

drop.get("test/api") { req in
    return JSON(req.meta?.toNode() ?? [])
}

drop.resource("posts", PostController())

if drop.config["app"] == nil {
    throw Abort.custom(status: .internalServerError, message: "Config was not loaded, might have an error")
}

drop.run()


