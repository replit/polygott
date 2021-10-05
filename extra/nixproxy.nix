{
	pkgs ? import <nixpkgs> {},
	repldir,
	replit ? import (repldir + "/replit.nix") { inherit pkgs; },
}:
pkgs.mkShell {
	buildInputs = replit.deps;
}
