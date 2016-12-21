import Vapor
import Meta
import NStack
import SwiftyBeaverVapor
import SwiftyBeaver
import Foundation
import VaporRedis
import Bugsnag
//import Error
import AdminPanel
import VaporMySQL
import Auth
import Sessions

let drop = Droplet()

drop.view = LeafRenderer(
    viewsDir: Droplet().workDir + "/Packages/AdminPanel-0.1.1/Sources/AdminPanel/Resources/Views"
)

try drop.addProvider(VaporMySQL.Provider.self)
//try drop.addProvider(AdminPanel.Provider.self)
try drop.addProvider(AdminPanel.Provider(drop: drop))

try drop.addProvider(VaporRedis.Provider(config: drop.config))

//drop.middleware.append(SessionsMiddleware(sessions: CacheSessions(cache: drop.cache)))
drop.middleware.append(SessionsMiddleware(sessions: MemorySessions()))

//API
/*
drop.group(AuthMiddleware<User>()) { auth in
    auth.group("api") { api in
        
        let usersController = UsersController()
        
        /*
         * Registration
         * Create a new Username and Password to receive an authorization token and account
         */
        api.post("register", handler: usersController.register)
        
        /*
         * Log In
         * Pass the Username and Password to receive a new token
         */
        api.post("login", handler: usersController.login)
        
        
        /*
         * Secured Endpoints
         * Anything in here requires the Authorication header:
         * Example: "Authorization: Bearer TOKEN"
         */
        api.group(BearerAuthMiddleware(), ProtectMiddleware(error: Abort.custom(status: .unauthorized, message: "Unauthorized"))) { secured in
            
            let users = secured.grouped("users")
            /*
             * Validation: I use this to check on the token periodically to see
             * if I need a new token while the user is using the app.
             */
            users.post("validate", handler: usersController.validateAccessToken)
            
            /*
             * Me
             * Get the current users info
             */
            users.get("me", handler: usersController.me)
            
            /*
             * Log out
             */
            users.post("logout", handler: usersController.logout)
        }
    }
}
*/


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

drop.get("seeder") { request in
    try AdminPanel.Seeder(console: drop.console).run(arguments: [])
    return "seeded"
}


drop.run()



