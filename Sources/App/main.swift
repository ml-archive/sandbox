import Vapor

let drop = Droplet()

drop.middleware.append(NMetaMiddleware())

drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

drop.get("test") { req in
    return "test"
}

drop.resource("posts", PostController())


if(drop.config["app"] == nil) {
    throw Abort.custom(status: .internalServerError, message: "Config was not loaded, might have an error")
}
drop.run()
