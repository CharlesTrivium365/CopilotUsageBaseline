Set-StrictMode -Version Latest

function Get-CopilotUsageBaseline {
    <#
    .SYNOPSIS
        Recupere en lecture seule le detail d'utilisation de Microsoft Copilot sur 30 jours.

    .DESCRIPTION
        Get-CopilotUsageBaseline interroge le rapport getMicrosoft365CopilotUsageUserDetail
        de Microsoft Graph pour la periode D30 puis renvoie un objet PowerShell par
        enregistrement. Le but est de situer le bassin deja actif sur Microsoft Copilot
        avant de lancer une vague d'adoption Agent Builder.

        La fonction ne modifie rien dans le locataire. Elle lit le rapport d'utilisation
        et, au besoin, produit un rapport HTML sur le disque local.

        La permission Microsoft Graph requise est Reports.Read.All.

        Le point de terminaison utilise est en preversion. A valider avant un usage en
        production.

    .PARAMETER Connect
        Ouvre une session Microsoft Graph avec la portee Reports.Read.All avant la lecture.
        Sans ce commutateur, la fonction reutilise la session Microsoft Graph deja ouverte.

    .PARAMETER Disconnect
        Ferme la session Microsoft Graph une fois la lecture terminee.

    .PARAMETER HtmlReportPath
        Chemin d'un fichier HTML a produire a partir des enregistrements lus. Le fichier
        est ecrit sur le disque local. Aucune donnee n'est renvoyee au locataire.

    .EXAMPLE
        Connect-MgGraph -Scopes 'Reports.Read.All'
        Get-CopilotUsageBaseline

        Lit le rapport avec une session Microsoft Graph deja ouverte puis renvoie les objets.

    .EXAMPLE
        Get-CopilotUsageBaseline -Connect -Disconnect

        Ouvre une session, lit le rapport puis ferme la session.

    .EXAMPLE
        Get-CopilotUsageBaseline -HtmlReportPath './bassin-copilot.html'

        Lit le rapport, renvoie les objets puis produit un rapport HTML local.

    .INPUTS
        Aucune. La fonction n'accepte pas d'entree par le pipeline.

    .OUTPUTS
        System.Management.Automation.PSCustomObject. Un objet par ligne du rapport CSV.

    .NOTES
        Point de terminaison : GET /beta/reports/getMicrosoft365CopilotUsageUserDetail(period='D30').
        Ce point de terminaison est en preversion.
        Ce rapport ne distingue pas les createurs d'agents des utilisateurs d'agents.
        La metrique Users by creator type se trouve dans le Microsoft 365 Copilot Agents
        Usage Report du centre d'administration Microsoft 365.
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter()]
        [switch]$Connect,

        [Parameter()]
        [switch]$Disconnect,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$HtmlReportPath
    )

    if ($Connect) {
        Write-Verbose 'Ouverture d''une session Microsoft Graph avec la portee Reports.Read.All.'
        Connect-MgGraph -Scopes 'Reports.Read.All'
    }

    $uri = "https://graph.microsoft.com/beta/reports/getMicrosoft365CopilotUsageUserDetail(period='D30')"
    Write-Verbose "Lecture du rapport Microsoft Copilot : $uri"

    $response = Invoke-MgGraphRequest -Method GET -Uri $uri -OutputType HttpResponseMessage
    $content = $response.Content.ReadAsStringAsync().Result
    $records = @($content | ConvertFrom-Csv)

    Write-Verbose "Nombre d'enregistrements lus : $($records.Count)"

    if ($PSBoundParameters.ContainsKey('HtmlReportPath')) {
        $title = 'Bassin Microsoft Copilot actif sur 30 jours'
        $preContent = "<h1>$title</h1><p>Nombre d'enregistrements : $($records.Count)</p>"
        $records | ConvertTo-Html -Title $title -PreContent $preContent | Out-File -FilePath $HtmlReportPath -Encoding utf8
        Write-Verbose "Rapport HTML ecrit sur le disque local : $HtmlReportPath"
    }

    if ($Disconnect) {
        Write-Verbose 'Fermeture de la session Microsoft Graph.'
        $null = Disconnect-MgGraph
    }

    $records
}

Export-ModuleMember -Function 'Get-CopilotUsageBaseline'
