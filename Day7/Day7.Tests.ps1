BeforeAll {
    . $PSScriptRoot/Day6.ps1
}

Describe 'Day 6 Tests' {
    It 'Validate Part One' {
        Start-PartOne -fileName "testinput.txt" | should -be 7
    }
}
