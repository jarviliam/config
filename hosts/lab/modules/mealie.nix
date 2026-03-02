{
  config,
  ...
}:
{
  sops.secrets.mealie_ai_key = { };
  sops.templates."mealie.env" = {
    content = ''
      OPENAI_API_KEY=${config.sops.placeholder.mealie_ai_key}
    '';
  };
  services.mealie = {
    enable = true;
    port = 9000;
    listenAddress = "0.0.0.0";
    database.createLocally = true;
    credentialsFile = config.sops.templates."mealie.env".path;
    settings = {
      OPENAI_BASE_URL = "https://generativelanguage.googleapis.com/v1beta/openai/";
      OPENAI_MODEL = "gemini-2.5-flash-lite";
    };
  };

}
