# $container = New-PesterContainer -Path 'Day1.Tests.ps1' -Data @{ File = "testinput.txt" }

param (
        [Parameter(Mandatory)]
        [string] $file
      )

BeforeAll {
    . $PSScriptRoot/Day1.ps1
      $content = Get-Content $file
}

Describe 'Get Largest Calories' {
    It 'Largest calorie count in test file is 24000' {
        $largestcalories = Get-CalorieCount -list $content
            $largestcalories | should -be 24000
    }
}
