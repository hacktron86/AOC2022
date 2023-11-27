Import-Module PSGraph
function Show-PSGraph ([ValidateSet('dot', 'circular', 'Hierarchical', 'Radial', 'fdp', 'neato', 'sfdp', 'SpringModelLarge', 'SpringModelSmall', 'SpringModelMedium', 'twopi')]$LayoutEngine = 'circular') {
    $all = @($Input)
    $tempPath = [System.IO.Path]::GetTempFileName()
    $all | Out-File $tempPath
    $new = Get-Content $tempPath -raw | ForEach-Object { $_ -replace "`r", "" }
    $new | Set-Content -NoNewline $tempPath
    Export-PSGraph -Source $tempPath -ShowGraph -LayoutEngine $LayoutEngine
    Invoke-Item ($tempPath + '.png')
    Remove-Item $tempPath
}

function New-Edge ($From, $To, $Attributes, [switch]$AsObject) {
    $null = $PSBoundParameters.Remove('AsObject')
    $ht = [Hashtable]$PSBoundParameters
    if ($AsObject) {
        return [PSCustomObject]$ht
    }
    return $ht
}

function New-Node ($Name, $Attributes) {
    [Hashtable]$PSBoundParameters
}

function Get-GraphVisual ($Name, $Nodes, $Edges, [switch]$Undirected) {
    $sb = {
        if ($Undirected) { inline 'edge [arrowsize=0]' }
        foreach ($node in $Nodes) {
            node @node
        }
        foreach ($edge in $Edges) {
            edge @edge
        }
    }
    graph $sb
}

$edges = & {
    New-Edge Alice Bob
    New-Edge Alice Chuck
    New-Edge Bob Alice
    New-Edge Bob Chuck
}

Get-GraphVisual Friends -Edges $edges | Show-PSGraph