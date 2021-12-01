function Get-Input {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateRange(1, 25)]
        [int]
        $Day,

        [Parameter(Position = 1, Mandatory = $false)]
        [ValidatePattern('^[0-9a-f]{96}', Options = "None")]
        [string]
        $Session
    )

    $SessionFilePath = "$PSScriptRoot\cache\session"
    if (-not $Session) {
        if (-not (Test-Path -LiteralPath $SessionFilePath -PathType Leaf)) {
            throw "No session was specified and no previously cached session could be found."
        }
        $Session = Get-Content -LiteralPath $SessionFilePath -TotalCount 1
    } else {
        New-Item (Split-Path $SessionFilePath -Parent) -ItemType Directory -Force | Out-Null
        Set-Content $SessionFilePath $Session
    }

    $InputFilePath = "$PSScriptRoot\cache\input-day$Day"
    if (-not (Test-Path -LiteralPath $InputFilePath -PathType Leaf)) {
        $WebRequestSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
        $Cookie = New-Object System.Net.Cookie "session", $session, "/", ".adventofcode.com"
        $WebRequestSession.Cookies.Add($Cookie)

        $Input = (
            Invoke-WebRequest `
            "https://adventofcode.com/2021/day/$Day/input" `
            -WebSession $WebRequestSession `
            -OutFile $InputFilePath `
            -PassThru
        ).Content
    } else {
        $Input = Get-Content -LiteralPath $InputFilePath
    }

    $Input
}
