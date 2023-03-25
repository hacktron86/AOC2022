BeforeAll {
    . $PSScriptRoot/Day5.ps1
}

Describe 'Day 5 Tests' {
    It 'Validate Part One' {
        $crates = Get-FinalCratesPartOne -file "testinput.txt"
            $crates | should -be "CMZ"
    }

    It 'Validate Part Two' {
        $crates = Get-FinalCratesPartTwo -file "testinput.txt"
            $crates | should -be "MCD"
    }
}
