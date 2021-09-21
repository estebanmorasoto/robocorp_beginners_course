from RPA.Robocloud.Secrets import Secrets

_secret = Secrets().get_secret("robotsparebinindustries")
USER_NAME = _secret["username"]
PASSWORD = _secret["password"]