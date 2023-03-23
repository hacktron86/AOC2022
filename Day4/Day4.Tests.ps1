BeforeAll {
        . $PSScriptRoot/Day4.ps1
}

Describe 'Day 4 Tests' {
    It 'Answer should be 2' {
        $sum = Get-AssignmentPairCount -file "testinput.txt"
            $sum | should -be 2
    }
}
