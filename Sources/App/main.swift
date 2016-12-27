import Vapor
import Meta
import NStack
import SwiftyBeaverVapor
import SwiftyBeaver
//import Foundation
import VaporRedis
import Bugsnag
//import Error
import AdminPanel
import VaporMySQL
import Auth
import Sessions
import Storage
import SMTP
import Slugify
import Transport
//import SMTP

let drop = Droplet()

drop.view = LeafRenderer(
    viewsDir: Droplet().workDir + "/Packages/AdminPanel-0.1.5/Sources/AdminPanel/Resources/Views"
)

try drop.addProvider(VaporMySQL.Provider.self)
try drop.addProvider(AdminPanel.Provider(drop: drop))

try drop.addProvider(VaporRedis.Provider(config: drop.config))
try drop.addProvider(StorageProvider.self)

//drop.middleware.append(SessionsMiddleware(sessions: CacheSessions(cache: drop.cache)))
drop.middleware.append(SessionsMiddleware(sessions: MemorySessions()))

BackendUser.database = drop.database
//  print(try BackendUser.query().filter("id", .greaterThanOrEquals, "").all())

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
    //try AdminPanel.Seeder(drop: drop).run(arguments: [])
    return "seeded"
}


drop.get("slug",":slug") { request in
    guard let slug: String = request.parameters["slug"]?.string else {
        throw Abort.badRequest
    }
    return slug.slugify()
}



drop.get("test") { request in
    
    
    let credentials = SMTPCredentials(
        user: drop.config["mail", "user"]?.string ?? "",
        pass: drop.config["mail", "password"]?.string ?? ""
    )
    
    let from = EmailAddress(name: drop.config["mail", "fromName"]?.string ?? "Default name",
                            address: drop.config["mail", "fromEmail"]?.string ?? "Default email")
    let to = "cr@nodes.dk"
    
    let a = try drop.view.make("Login/login").data.string()
    
    let email: SMTP.Email = Email(from: from,
                             to: to,
                             subject: "Vapor SMTP - Simple",
                             body: EmailBody(type: .html, content: a))
    
    
    let client = try SMTPClient<TCPClientStream>(host: "smtp.mailgun.org", port: 465, securityLayer: SecurityLayer.tls(nil))

    try client.send(email, using: credentials)
    
    
    return ""
}


drop.run()



