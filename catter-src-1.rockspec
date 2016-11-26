package = "catter"
version = "src-1"
source = {
   url = "*** please add URL for source tarball, zip or repository here ***"
}
description = {
   homepage = "*** please enter a project homepage ***",
   license = "*** please specify a license ***"
}
dependencies = {
	"fun"
}
build = {
   type = "builtin",
   modules = {
      main = "main.lua",
      player = "player.lua"
   }
}
