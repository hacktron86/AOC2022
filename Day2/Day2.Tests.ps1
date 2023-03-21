# $container = New-PesterContainer -Path 'Day1.Tests.ps1' -Data @{ File = "testinput.txt" }

param (
        [Parameter(Mandatory)]
        [string] $file
      )

BeforeAll {
    #. $PSScriptRoot/Day2.ps1
        . $PSScriptRoot/Day2b.ps1
        $content = Get-Content $file
}

Describe 'Day 2 Tests' {
    #It 'Part one should be 15' {
    #    $score = Get-RockPaperScissorsScore -file $content
    #        $score | should -be 15
    #}
    It 'Part two should be 12' {
        $score = Get-RockPaperScissorsScoreB -file $content
            $score | should -be 12
    }
}
