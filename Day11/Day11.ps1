class Monkey {
    [string]$name
    [System.Collections.Queue]$StartingItems
    [string]$Operator
    [string]$Operand
    [int]$Test
    [int]$IfTrue
    [int]$IfFalse
    [int]$inspectCount

    Monkey() {
        $this.StartingItems = [System.Collections.Queue]::new()
    }

    #add starting item
    [void]AddStartingItem([int]$item) {
        $this.StartingItems.Enqueue($item)
    }

    #remove starting item
    [int]RemoveStartingItem() {
        return $this.StartingItems.Dequeue()
    }

    #update starting item
    [void]UpdateStartingItem([int]$item, [int]$newItem) {
        $index = $this.StartingItems.IndexOf($item)
        if ($index -ge 0) {
            $this.StartingItems[$index] = $newItem
        }
    }

}

#
# Part One
#

$monkeyList = @()

$textinput = Get-Content -Path "./input.txt" -Raw

$monkeyTexts = $textInput -split "Monkey \d+:" | Select-Object -Skip 1

$count = 0

foreach ($monkeyText in $monkeyTexts) {
    
    if ($monkeyText -match "Starting items: (.+)") {
        $startingItems = [System.Collections.Queue]::new()
        $matches[1] -split ", " | ForEach-Object { $startingItems.Enqueue([int]$_) }
    }

    if ($monkeyText -match "Operation: new = (.+)") {
        $operation = $matches[1] -split " "
        $operator = $operation[1]
        $operand = $operation[2]
    }

    if ($monkeyText -match "Test: divisible by (\d+)") {
        $test = [int]$matches[1]
    }

    if ($monkeyText -match "If true: throw to monkey (\d+)") {
        $ifTrue = [int]$matches[1]
    }

    if ($monkeyText -match "If false: throw to monkey (\d+)") {
        $ifFalse = [int]$matches[1]
    }

    $monkey = [Monkey]::new()
    $monkey.name = "Monkey $count"
    $monkey.StartingItems = $startingItems
    $monkey.Operator = $operator
    $monkey.Operand = $operand
    $monkey.Test = $test
    $monkey.IfTrue = $ifTrue
    $monkey.IfFalse = $ifFalse

    $monkeyList += $monkey

    $count++
}

for ($i = 0; $i -lt 20; $i++) {
    foreach ($monkey in $monkeyList) {
        while ($monkey.StartingItems.Count -gt 0) {
            $item = $monkey.RemoveStartingItem()
            $monkey.inspectCount++
            if ($monkey.Operand -eq "old") {
                $newItem = switch ($monkey.Operator) {
                    "+" { [Math]::Floor(($item + $item) / 3) }
                    "*" { [Math]::Floor(($item * $item) / 3) }
                }
            } else {
                $newItem = switch ($monkey.Operator) {
                    "+" { [Math]::Floor(($item + [Int]$monkey.Operand) / 3) }
                    "*" { [Math]::Floor(($item * [Int]$monkey.Operand) / 3) }
                }
            }
            if ($newItem % $monkey.Test -eq 0) {
                $monkeyList[$monkey.IfTrue].AddStartingItem($newItem)
            } else {
                $monkeyList[$monkey.IfFalse].AddStartingItem($newItem)
            }
        }
    }
}

# return the top two inspect counts in the monkey list
$topInspectCounts = $monkeyList | Sort-Object -Property inspectCount -Descending | Select-Object -First 2 | ForEach-Object { $_.inspectCount}

Write-Host "Part One: $($topInspectCounts[0] * $topInspectCounts[1])"

#
# Part Two
#

$monkeyList = @()

$textinput = Get-Content -Path "./input.txt" -Raw

$monkeyTexts = $textInput -split "Monkey \d+:" | Select-Object -Skip 1

$count = 0

foreach ($monkeyText in $monkeyTexts) {
    
    if ($monkeyText -match "Starting items: (.+)") {
        $startingItems = [System.Collections.Queue]::new()
        $matches[1] -split ", " | ForEach-Object { $startingItems.Enqueue([int]$_) }
    }

    if ($monkeyText -match "Operation: new = (.+)") {
        $operation = $matches[1] -split " "
        $operator = $operation[1]
        $operand = $operation[2]
    }

    if ($monkeyText -match "Test: divisible by (\d+)") {
        $test = [int]$matches[1]
    }

    if ($monkeyText -match "If true: throw to monkey (\d+)") {
        $ifTrue = [int]$matches[1]
    }

    if ($monkeyText -match "If false: throw to monkey (\d+)") {
        $ifFalse = [int]$matches[1]
    }

    $monkey = [Monkey]::new()
    $monkey.name = "Monkey $count"
    $monkey.StartingItems = $startingItems
    $monkey.Operator = $operator
    $monkey.Operand = $operand
    $monkey.Test = $test
    $monkey.IfTrue = $ifTrue
    $monkey.IfFalse = $ifFalse

    $monkeyList += $monkey

    $count++
}

$Mod = $monkeyList[0].Test

foreach ($monkey in $monkeyList[1..$monkeyList.Count]) {
    $Mod *= $monkey.Test
}

for ($i = 0; $i -lt 10000; $i++) {
    foreach ($monkey in $monkeyList) {
        while ($monkey.StartingItems.Count -gt 0) {
            $item = $monkey.RemoveStartingItem()
            $monkey.inspectCount++
            if ($monkey.Operand -eq "old") {
                $operand = $item
            } else {
                $operand = [Int]$monkey.Operand
            }
            $newItem = switch ($monkey.Operator) {
                "+" { $item + $operand }
                "*" { $item * $operand }
            }
            $newItem = $newItem % $Mod
            if ($newItem % $monkey.Test -eq 0) {
                $monkeyList[$monkey.IfTrue].AddStartingItem($newItem)
            } else {
                $monkeyList[$monkey.IfFalse].AddStartingItem($newItem)
            }
        }
    }
}

# return the top two inspect counts in the monkey list
$topInspectCounts = $monkeyList | Sort-Object -Property inspectCount -Descending | Select-Object -First 2 | ForEach-Object { $_.inspectCount}

Write-Host "Part Two: $($topInspectCounts[0] * $topInspectCounts[1])"