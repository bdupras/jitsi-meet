admins = { ("focus@auth." .. os.getenv("JITSI_DOMAIN")) }
daemonize = true
cross_domain_bosh = true;
storage = {archive2 = "sql2"}
sql = { driver = "SQLite3", database = "prosody.sqlite" }
default_archive_policy = "roster"
component_ports = { 5347 }

modules_enabled = {
    "roster"; 
    "saslauth"; 
    "tls"; 
    "dialback"; 
    "disco"; 
    "posix"; 
    "private"; 
    "vcard"; 
    "compression"; 
    "version"; 
    "uptime"; 
    "time"; 
    "ping"; 
    "pep"; 
    "register"; 
    "admin_adhoc"; 
    "bosh"; 
    "smacks";
    "carbons";
    "mam";
    "lastactivity";
    "offline";
    "pubsub";
    "adhoc";
    "websocket";
    "http_altconnect";
}

modules_disabled = {}
allow_registration = false

ssl = {
    key = "/etc/prosody/certs/localhost.key";
    certificate = "/etc/prosody/certs/localhost.crt";
}

pidfile = "/var/run/prosody/prosody.pid"
authentication = "internal_hashed"

log = {
  info = "/var/log/prosody/prosody.log"; 
  error = "/var/log/prosody/prosody.err";
  "*syslog";
}

http_default_host = (os.getenv("JITSI_DOMAIN"))

VirtualHost (os.getenv("JITSI_DOMAIN"))
  authentication = "anonymous"
  ssl = {
    key = ("/certs/" .. os.getenv("JITSI_DOMAIN") .. ".key");
    certificate = ("/certs/" .. os.getenv("JITSI_DOMAIN") .. ".crt");
  }

VirtualHost ("auth." .. os.getenv("JITSI_DOMAIN") )
  authentication = "internal_plain"
  ssl = {
    key = ("/certs/" .. os.getenv("JITSI_DOMAIN") .. ".key");
    certificate = ("/certs/" .. os.getenv("JITSI_DOMAIN") .. ".crt");
  }

Component ("conference." .. os.getenv("JITSI_DOMAIN")) "muc"

Component ("jitsi-videobridge." .. os.getenv("JITSI_DOMAIN"))
    component_secret = os.getenv("VIDEOBRIDGE_SECRET")

Component ("focus." .. os.getenv("JITSI_DOMAIN"))
    component_secret = os.getenv("DOMAIN_SECRET")