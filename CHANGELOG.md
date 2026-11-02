# Journal des modifications

Le format suit Keep a Changelog et le versionnage sémantique.

## [1.0.0] - 2026-11-02

### Ajouté

- Fonction `Get-CopilotUsageBaseline` qui lit le rapport getMicrosoft365CopilotUsageUserDetail (période D30) en lecture seule puis renvoie un objet par enregistrement.
- Paramètre `-HtmlReportPath` pour produire un rapport HTML sur le disque local.
- Commutateurs `-Connect` et `-Disconnect` pour gérer la session Microsoft Graph.
- Aide basée sur les commentaires, manifeste de module et documentation en français.
