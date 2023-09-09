{lib,stdenv,fetchFromGitHub}:
stdenv.mkDerivation rec{
    pname="tfenv";
    version="3.0.0";
    src = fetchFromGitHub{
        owner = "tfutils";
        repo=pname;
        rev="v${version}";
        sha256="0jvs7bk2gaspanb4qpxzd4m2ya5pz3d1izam6k7lw30hyn7mlnnq";
    };

    runCommand
}
