# Basic settings
docker-compose exec app mattermost config set ServiceSettings.SiteURL "https://localhost/chat"
docker-compose exec app mattermost config set ServiceSettings.AllowedUntrustedInternalConnections "localhost, danvers" # (dev) localhost for access to dialogue manager via port, (single host) docker-compose assigned address of single proxy or (multiple host) address of message-passer (attributed to trusted cert).
docker-compose exec app mattermost config set TeamSettings.SiteName "CONSULT"
docker-compose exec app mattermost config set TeamSettings.MaxNotificationsPerChannel 1
docker-compose exec app mattermost config set TeamSettings.RestrictDirectMessage "team"
docker-compose exec app mattermost config set EmailSettings.EnablePreviewModeBanner false
docker-compose exec app mattermost config set ServiceSettings.EnablePostUsernameOverride true
docker-compose exec app mattermost config set ServiceSettings.EnablePostIconOverride true

docker-compose exec app mattermost config set PrivacySettings.ShowEmailAddress false
docker-compose exec app mattermost config set PrivacySettings.ShowFullName false

# docker-compose exec app mattermost config set ServiceSettings.EnableUserAccessTokens true

# User and team creation
docker-compose exec app mattermost user create --firstname connie --system_admin --email connie@consult.kcl.ac.uk --username connie --password 12345
docker-compose exec app mattermost roles system_admin connie
docker-compose exec app mattermost team create --name patient --display_name "Patient Chat"
docker-compose exec app mattermost team add patient connie

## Restrict after first team creation
docker-compose exec app mattermost config set TeamSettings.MaxChannelsPerTeam 1
docker-compose exec app mattermost config set TeamSettings.EnableTeamCreation false

## Sample user
docker-compose exec app mattermost user create --firstname user --email user@consult.kcl.ac.uk --username user --password 12345
docker-compose exec app mattermost team add patient user

# Hooks
docker-compose exec app mattermost webhook create-incoming --channel patient:off-topic --user connie --display-name connie
docker-compose exec app mattermost command create patient --title start --description "start" --trigger-word start --url https://danvers/dialogue/response --creator connie --response-username connie --autocomplete --post # Supply localhost to reference single proxy if in dev, otherwise reference allocated proxy hostname under single docker machine (host) (e.g. device-integration_nokia_proxy_1) or machine address (attributed to added trusted cert.) if using multiple docker machines (host). Avoid hard-coding ports to enable possible service discovery.

# Restart everything
docker-compose down;
docker-compose up -d;
