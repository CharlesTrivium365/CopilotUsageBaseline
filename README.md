# CopilotUsageBaseline

CopilotUsageBaseline est un module PowerShell en lecture seule. Il récupère le détail d'utilisation de Microsoft Copilot sur 30 jours puis renvoie un objet PowerShell par utilisateur. Le but est de situer le bassin déjà actif avant de lancer une vague d'adoption Agent Builder.

## À quoi sert cet outil et pourquoi maintenant

Microsoft a publié le 28 septembre 2026 un billet sur la gestion du changement autour d'Agent Builder, l'outil de création d'agents inclus dans Microsoft 365 Copilot. Le constat tient en une phrase. La technologie est prête mais l'adoption ne suit pas automatiquement. Avant d'inviter une équipe, il est utile de voir qui touche déjà Microsoft Copilot.

Microsoft Copilot est le nouveau nom de Microsoft 365 Copilot. Ce module interroge le rapport d'utilisation de Microsoft Copilot sur Microsoft Graph puis renvoie une ligne par personne. Vous obtenez une photo du bassin déjà actif. Les personnes qui figurent dans ce rapport sont vos premières candidates aux sessions de co-construction.

## Prérequis

- PowerShell 5.1 ou une version plus récente.
- Le module Microsoft.Graph installé avec `Install-Module`. Au minimum le sous-module Microsoft.Graph.Authentication fournit les commandes utilisées.
- La permission Microsoft Graph déléguée Reports.Read.All consentie pour le compte qui lance l'outil.
- Un compte administrateur capable d'accorder le consentement à cette permission si elle n'est pas déjà accordée dans le locataire.

## Installation

```powershell
Install-Module Microsoft.Graph -Scope CurrentUser
Import-Module ./CopilotUsageBaseline/CopilotUsageBaseline.psd1
```

## Exemples d'utilisation

Lecture avec une session Microsoft Graph déjà ouverte.

```powershell
Connect-MgGraph -Scopes 'Reports.Read.All'
Get-CopilotUsageBaseline
```

Ouverture et fermeture de la session par l'outil.

```powershell
Get-CopilotUsageBaseline -Connect -Disconnect
```

Production d'un rapport HTML local.

```powershell
Get-CopilotUsageBaseline -HtmlReportPath './bassin-copilot.html'
```

Comptage rapide du bassin actif.

```powershell
$bassin = Get-CopilotUsageBaseline
$bassin.Count
```

## Exemple de sortie

Les valeurs ci-dessous sont fictives. Elles servent seulement d'illustration. Les colonnes réelles sont définies par Microsoft Graph dans le rapport getMicrosoft365CopilotUsageUserDetail.

```
ReportRefreshDate UserPrincipalName             DisplayName   LastActivityDate
----------------- -----------------             -----------   ----------------
2026-11-02        alex.tremblay@contoso.example Alex Tremblay 2026-10-30
2026-11-02        sam.gagnon@contoso.example    Sam Gagnon    2026-10-28
2026-11-02        jo.roy@contoso.example        Jo Roy        2026-10-15
```

## Limites connues

- Le point de terminaison getMicrosoft365CopilotUsageUserDetail est en préversion. À valider avant un usage en production.
- Ce rapport ne distingue pas les créateurs d'agents des utilisateurs d'agents. La métrique Users by creator type se trouve dans le Microsoft 365 Copilot Agents Usage Report du centre d'administration Microsoft 365.
- La période couverte est fixée à 30 jours (valeur D30).
- L'outil est en lecture seule. Il n'écrit rien dans le locataire. Le rapport HTML est produit sur le disque local.

## Article et sources

- Article : https://trivium365.com/blog/agent-builder-mesurer-createurs-utilisateurs-adoption/
- Billet Microsoft Copilot Blog : https://techcommunity.microsoft.com/blog/microsoft-copilot-blog/change-management-best-practices-to-drive-value-with-agent-builder/4559753
