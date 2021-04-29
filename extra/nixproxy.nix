{
	pkgs ? import <nixpkgs> {},
	repldir,
	replit ? import (repldir + "/replit.nix") {},
}:
pkgs.mkShell {
	buildInputs = replit.deps;
}
