import Vapor
import Meta
import NStack

let drop = Droplet()

drop.middleware.append(MetaMiddleware(drop: drop))
drop.nstack = try NStack(drop: drop)

//try print(drop.nstack?.application.translate.get(platform: "backend", language: "en-UK", section: "default", key: "ok", replace: [:]))

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
