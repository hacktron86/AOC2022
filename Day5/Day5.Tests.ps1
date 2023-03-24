BeforeAll {
        . $PSScriptRoot/Day5.ps1
}

Describe 'Day 5 Tests' {
    It 'Validate Final Crates of Each Stack' {
        $crates = Get-FinalCrates -file "testinput.txt"
            $crates[0] | should -be "C"
            $crates[1] | should -be "M"
            $crates[2] | should -be "Z"
    }
}
