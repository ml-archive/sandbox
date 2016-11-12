import Vapor

let drop = Droplet()
print(drop.config["mysql"])
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

drop.run()
