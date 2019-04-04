# Basic settings
if [ "$1" = "dev" ]; then
  docker-compose exec app mattermost config set ServiceSettings.SiteURL "http://localhost"
else
  docker-compose exec app mattermost config set ServiceSettings.SiteURL "https://localhost/chat"
fi

sleep 5

# User and team creation
docker-compose exec app mattermost team create --name patient --display_name "Patient Chat"
sleep 5
docker-compose exec app mattermost user create --firstname connie --system_admin --email connie@consult.kcl.ac.uk --username connie --password 12345
sleep 5
docker-compose exec app mattermost team add patient connie
sleep 5
docker-compose exec app mattermost roles system_admin connie
sleep 5

# (dev) localhost for access to dialogue manager via port, (single host) docker-compose assigned address of single proxy or (multiple host) address of message-passer (attributed to trusted cert).
docker-compose exec app mattermost config set ServiceSettings.AllowedUntrustedInternalConnections "localhost danvers"
docker-compose exec app mattermost config set TeamSettings.SiteName "CONSULT"
docker-compose exec app mattermost config set TeamSettings.MaxNotificationsPerChannel 1
docker-compose exec app mattermost config set TeamSettings.RestrictDirectMessage "team"
docker-compose exec app mattermost config set EmailSettings.EnablePreviewModeBanner false
docker-compose exec app mattermost config set ServiceSettings.EnablePostUsernameOverride true
docker-compose exec app mattermost config set ServiceSettings.EnablePostIconOverride true
docker-compose exec app mattermost config set PrivacySettings.ShowEmailAddress false
docker-compose exec app mattermost config set PrivacySettings.ShowFullName false
sleep 5

# Restrict after first team creation
docker-compose exec app mattermost config set TeamSettings.MaxChannelsPerTeam 1
docker-compose exec app mattermost config set TeamSettings.EnableTeamCreation false
sleep 5

# Sample user
docker-compose exec app mattermost user create --firstname user --email user@consult.kcl.ac.uk --username user --password 12345
sleep 5
docker-compose exec app mattermost team add patient user
sleep 5

# Hooks
docker-compose exec app mattermost webhook create-incoming --channel patient:off-topic --user connie --display-name connie
sleep 5

# Supply localhost to reference single proxy if in dev, otherwise reference allocated proxy hostname under single docker machine (host) (e.g. 'device-integration_nokia_proxy_1') or machine address (attributed to added trusted cert., e.g. 'danvers') if using multiple docker machines (host). Avoid hard-coding ports to enable possible service discovery.
if [ "$1" = "dev" ]; then
  docker-compose exec app mattermost command create patient --title start --description "start" --trigger-word start --url http://localhost:3007/dialogue/response --creator connie --response-username connie --autocomplete --post
  sleep 5
else
  docker-compose exec app mattermost command create patient --title start --description "start" --trigger-word start --url https://danvers/dialogue/response --creator connie --response-username connie --autocomplete --post
  sleep 5
fi

if [ "$1" = "dev" ]; then
  docker-compose -f docker-compose.dev.yml down;
else
  docker-compose down;
fi

sleep 5

if [ "$1" = "dev" ]; then
  docker-compose -f docker-compose.dev.yml up -d;
else
  docker-compose up -d;
fi
