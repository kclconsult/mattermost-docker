# Basic settings
if [ "$1" = "dev" ]; then
  docker-compose exec app mattermost config set ServiceSettings.SiteURL "http://localhost"
elif [ "$1" = "demo" ]; then
  docker-compose exec app mattermost config set ServiceSettings.SiteURL "https://localhost/consult/chat"
else
  docker-compose exec app mattermost config set ServiceSettings.SiteURL "https://localhost/chat"
fi

sleep 5

# Admin
docker-compose exec app mattermost user create --firstname connie --system_admin --email connie@consult.kcl.ac.uk --username connie --password 12345
sleep 5
docker-compose exec app mattermost roles system_admin connie
sleep 5

# (dev) localhost for access to dialogue manager via port, (single host) docker-compose assigned address of single proxy or (multiple host) address of message-passer (attributed to trusted cert).
docker-compose exec app mattermost config set ServiceSettings.AllowedUntrustedInternalConnections "localhost danvers"
docker-compose exec app mattermost config set TeamSettings.SiteName "CONSULT"
docker-compose exec app mattermost config set TeamSettings.MaxNotificationsPerChannel 1
docker-compose exec app mattermost config set TeamSettings.MaxUsersPerTeam 1
docker-compose exec app mattermost config set TeamSettings.RestrictDirectMessage "team"
docker-compose exec app mattermost config set EmailSettings.EnablePreviewModeBanner false
docker-compose exec app mattermost config set ServiceSettings.EnablePostUsernameOverride true
docker-compose exec app mattermost config set ServiceSettings.EnablePostIconOverride true
docker-compose exec app mattermost config set PrivacySettings.ShowEmailAddress false
docker-compose exec app mattermost config set PrivacySettings.ShowFullName false
sleep 5

if [ "$1" = "dev" ]; then
  docker-compose -f docker-compose.dev.yml down;
elif [ "$1" = "demo" ]; then
  docker-compose -f docker-compose.demo.yml down;
else
  docker-compose down;
fi

sleep 5

if [ "$1" = "dev" ]; then
  docker-compose -f docker-compose.dev.yml up -d;
elif [ "$1" = "demo" ]; then
  docker-compose -f docker-compose.demo.yml up -d;
else
  docker-compose up -d;
fi
