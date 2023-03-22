BeforeAll {
        . $PSScriptRoot/Day3.ps1
}

Describe 'Day 3 Tests' {
    It 'Answer should be 157' {
        $sum = Get-SumOfPriorities -file "testinput.txt"
            $sum | should -be 157
    }
    It 'Answer should be 70' {
        $sum = Get-SumOfBadgePriorities -file "testinput.txt"
            $sum | should -be 70
    }
}
