{ config, ... }:

{
  age.secrets.paperless-password = {
    file = ../../secrets/paperless-password.age;
    owner = config.services.paperless.user;
    group = config.services.paperless.user;
  };

  services.paperless = {
    enable = true;
    address = "0.0.0.0";
    passwordFile = config.age.secrets.paperless-password.path;
    settings = {
      PAPERLESS_ADMIN_USER = "vitalya";
      PAPERLESS_OCR_LANGUAGE = "rus+eng+kaz";
    };
  };
}
