{ fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication {
  pname = "paperless-concierge";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "mitchins";
    repo = "paperless-concierge";
    rev = "df87df738281fbea7267bf9c28856a23f7bff347";
    hash = "sha256-10UR+1OniiyQwyHf195Pt9nLtEhlmEL+v2wCFdy5JxY=";
  };

  pyproject = true;
  build-system = with python3Packages; [ setuptools setuptools-scm ];

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="0.1.0"
  '';

  dependencies = with python3Packages; [
    requests
    python-telegram-bot
    pyyaml
    python-dotenv
    aiofiles
    python-dateutil
    diskcache
  ];

  doCheck = false;

  meta = {
    description = "Telegram bot for Paperless-ngx";
    homepage = "https://github.com/mitchins/paperless-concierge";
    mainProgram = "paperless-concierge";
  };
}
