@{
    RootModule        = 'CopilotUsageBaseline.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '7c9f2e14-3b5a-4d26-9f1e-8a0c6b2d4f31'
    Author            = 'Charles Jenkins'
    CompanyName       = 'Charles Jenkins'
    Copyright         = 'Copyright (c) 2026 Charles Jenkins. Distribue sous licence MIT.'
    Description       = 'Module PowerShell en lecture seule qui recense le bassin actif sur Microsoft Copilot via Microsoft Graph avant une vague d''adoption Agent Builder.'
    PowerShellVersion = '5.1'
    RequiredModules   = @('Microsoft.Graph.Authentication')
    FunctionsToExport = @('Get-CopilotUsageBaseline')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
    PrivateData = @{
        PSData = @{
            Tags         = @('Microsoft365', 'Copilot', 'Graph', 'Adoption', 'AgentBuilder', 'ReadOnly')
            ReleaseNotes = 'Version initiale. Lecture du rapport getMicrosoft365CopilotUsageUserDetail en periode D30.'
        }
    }
}
