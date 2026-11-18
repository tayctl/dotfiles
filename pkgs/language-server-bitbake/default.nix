# Official Yocto BitBake language server (from yoctoproject/vscode-bitbake),
# packaged from the prebuilt npm tarball.
#
# The npm tarball has no lockfile, so package-lock.json was generated with:
#   npm install --package-lock-only --omit=dev --ignore-scripts
#
{
  lib,
  buildNpmPackage,
  fetchurl,
}:
buildNpmPackage rec {
  pname = "language-server-bitbake";
  version = "2.10.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/language-server-bitbake/-/language-server-bitbake-${version}.tgz";
    hash = "sha256-Qg3WzG/6OoH7ayIdLQ5/DnB92rKPKfsHJhqH7XL2rwo=";
  };

  npmDepsHash = "sha256-2HxOd/wTRnRK0Lg3O9J+3dU/kXKv2TblQdp4TVj+8J8=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
    # prepack tries to compile the monorepo; the tarball is already built
    sed -i '/"prepack"/d' package.json
  '';

  dontNpmBuild = true;
  npmPackFlags = [ "--ignore-scripts" ];

  meta = {
    description = "BitBake language server from the Yocto Project";
    homepage = "https://github.com/yoctoproject/vscode-bitbake";
    license = lib.licenses.mit;
    mainProgram = "language-server-bitbake";
  };
}
