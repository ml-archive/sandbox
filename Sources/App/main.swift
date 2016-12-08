import Vapor
import Meta
import NStack
import SwiftyBeaverVapor
import SwiftyBeaver
import Foundation
import VaporRedis
import Bugsnag
//import Error
import Admin
import VaporMySQL
import Auth
import Sessions

let drop = Droplet()

drop.view = LeafRenderer(
    viewsDir: Droplet().workDir + "Sources/Admin/Resources/Views"
)

try drop.addProvider(VaporMySQL.Provider.self)
try drop.addProvider(VaporRedis.Provider(config: drop.config))

// Backend
let protect = Admin.AuthRedirectMiddleware()
drop.grouped("/").collection(Admin.LoginRoutes(droplet: drop))
drop.grouped("/admin/dashboard").collection(Admin.DashboardRoutes(droplet: drop))
drop.grouped("/admin/users").collection(Admin.BackendUsersRoutes(droplet: drop))
drop.grouped("/admin/users/roles").collection(Admin.BackendUserRolesRoutes(droplet: drop))



drop.preparations = [
    Admin.BackendUserRole.self,
    Admin.BackendUser.self,
]


drop.middleware.append(AuthMiddleware<BackendUser>())

let memory = MemorySessions()
let sessions = SessionsMiddleware(sessions: memory)

//drop.middleware.append

/*
 view: LeafRenderer(
 viewsDir: Droplet().workDir + "VaporBackend/Resources/Views"
 ),
 */

//drop.middleware.append(ErrorMiddleware())
//try drop.middleware.append(BugsnagMiddleware(drop: drop))

//try drop.middleware.append(MetaMiddleware(drop: drop))

//try drop.addProvider(NStackProvider(drop: drop))
//try drop.addProvider(VaporRedis.Provider(config: drop.config))

/*
try drop.cache.set("test", Node("test"))
print(try drop.cache.get("test"))
*/

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

//try print(drop.nstack?.application.translate.get(platform: .backend, section: "default", key: "saveSuccess", replace: ["model": "test"]))
//try print(drop.nstack?.application.translate.get(platform: "backend2", language: "en-UK", section: "default", key: "saveSuccess", replace: ["model": "test"]))
//try print(drop.nstack?.application.translate.get(platform: "backend2", language: "en-UK", section: "default", key: "saveSuccess", replace: ["model": "test"]))
//try print(drop.nstack?.application.translate.get(platform: "backend2", language: "en-UK", section: "default", key: "saveSuccess", replace: ["model": "test"]))

let translate = drop.nstack?.application.translate.self

if drop.config["app"] == nil {
    throw Abort.custom(status: .internalServerError, message: "Config was not loaded, might have an error")
}

drop.get("seeder") { request in
    try Seeder(console: drop.console).run(arguments: [])
    return "seeded"
}
drop.run()



