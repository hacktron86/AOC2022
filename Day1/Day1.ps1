class Elf {
    [System.Collections.ArrayList]$mealCalories = @()
        [int]$totalCalories

            [void]AddMeal([string]$calories) {
                $this.mealCalories.Add([System.Convert]::ToInt32($calories))
            }
}

function Get-CalorieCount {
    param (
            $list
          )
        process {
            $arr = $list -split "\r"
                $elves = [System.Collections.ArrayList]@()
                $elves.Add([Elf]::new()) | Out-Null
                $index = 0
                for ($i = 0; $i -lt $arr.Length; $i++) {
                    if ( "" -eq $arr[$i] ) {
                        $elves.Add([Elf]::new()) | Out-Null
                            $index = $index + 1
                    } else {
                        $elves[$index].AddMeal($arr[$i]) | Out-Null
                    }
                }

            $es = $elves.ToArray()
                foreach ($elf in $es) {
                    $mc = $elf.mealCalories.ToArray()
                        $total = 0
                        foreach ($meal in $mc) {
                            $total = $total + $meal
                        }
                    $elf.totalCalories = $total
                }

            $res = $elves | 
            Select-Object -ExpandProperty totalCalories |
            Sort-Object |
            Select-Object -Last 3 
                return $res | Measure-Object -Sum | Select-Object -ExpandProperty Sum
        }
}

Get-CalorieCount -list (Get-Content "input.txt")
