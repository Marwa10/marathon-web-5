library(r2d3)
r2d3(data = jsonlite::read_json("archives/flare.json"), d3_version = 4, script = "archives/treemap.js")
