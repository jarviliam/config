{
  ...
}:
{
  services.paperless = {
    enable = true;
    port = 2891;
    address = "10.32.1.100";

    mediaDir = "/var/lib/paperless/media";
    consumptionDir = "/var/lib/paperless/consume";

    database = {
      createLocally = true;
    };
    settings = {
      PAPERLESS_URL = "http://10.32.1.100";
      PAPERLESS_OCR_LANGUAGE = "eng";
      PAPERLESS_OCR_LANGUAGES = "eng jpn";
      PAPERLESS_TIME_ZONE = "America/New_York";

      PAPERLESS_DBHOST = "/run/postgresql";
      PAPERLESS_DBNAME = "paperless";
      PAPERLESS_DBUSER = "paperless";

      PAPERLESS_CONSUMER_POLLING = 60;
      PAPERLESS_SCRATCH_DIR = "/var/lib/paperless/scratch";

      # Store files in dated folders (added date) with created-date-prefixed title filenames
      PAPERLESS_FILENAME_FORMAT = "{{ added_year }}-{{ added_month }}-{{ added_day }}/{{ created_year }}-{{ created_month }}-{{ created_day }}_{{ title }}";
    };
  };
}
