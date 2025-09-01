{
}:
final: prev: rec {
  bugwarrior-dev = prev.python312Packages.bugwarrior.overrideAttrs (
    finalAttrs: prevAttrs: {
      version = "develop";

      # Fetching from repository instead of published version in pypi.
      src = final.fetchFromGitHub {
        owner = "GothenburgBitFactory";
        repo = "bugwarrior";
        rev = "7ea84aebf3fb8dba5ad09608c02ef600fded5119";
        sha256 = "sha256-MaZAG+vp++Wfhj3SW3S4q7tcmR4ZtM5FOJ+/2Wz0zDk=";
      };

      # Adding dependencies that were added in new versions.
      propagatedBuildInputs =
        prevAttrs.propagatedBuildInputs ++ (with prev; [ python312Packages.pydantic ]);
    }
  );

}
