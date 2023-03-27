class Directory {
    [string] $Name
        [int] $Size
            [bool] $IsDirectory
                [Directory[]] $Children
                    [Directory] $Parent
                        [int] $directorySize

                            Directory($name, $size, $isDirectory, $parent) {
                                $this.Name = $name
                                    $this.Size = $size
                                    $this.IsDirectory = $isDirectory
                                    $this.Children = @()
                                    $this.Parent = $parent
                            }

    [void] AddChild([Directory]$child) {
        $this.Children += $child
    }

    [int] GetTotalSize() {
        $totalSize = $this.Size
            foreach ($child in $this.Children) {
                if ($child.IsDirectory) {
                    $totalSize += $child.GetTotalSize()
                } else {
                    $totalSize += $child.Size
                }
            }
        $this.directorySize = $totalSize
            return $totalSize
    }

    [PSCustomObject[]] GetAllDirectorySizes() {
        $directorySizes = @()
            $directorySizes += 
            [PSCustomObject]@{
                Size = $this.directorySize
                    Difference = 29641087 - $this.directorySize
            }
        foreach ($child in ($this.Children | Where-Object { $_.isDirectory}) ) {
            $directorySizes += $child.GetAllDirectorySizes()
        }
        return $directorySizes
    }

    [int] GetPartTwo() {
        $res = $this.GetAllDirectorySizes() 
            $max = 
            $res | 
            Where-Object { $_.Difference -lt 0 } | 
            Measure-Object -Property Difference -Maximum |
            Select-Object -ExpandProperty Maximum
            return ($res | Where-Object { $_.Difference -eq $max }).Size
    }

    [int] GetPartOne() {
        $partOneSum = if($this.directorySize -gt 100000) {0} else {$this.directorySize}
            foreach ($child in $this.Children) {
                if ($child.IsDirectory) {
                    $partOneSum += $child.GetPartOne()
                } else {
                    $totalSize += $child.directorySize
                }
            }
        return $partOneSum
    }

    [void] UpdateDirectorySize() {
        $this.directorySize = $this.GetTotalSize()
    }
}

function Build-Directory {

    $lineInput = Convert-InputToArray -filename "input.txt"
        $root = [Directory]::new("/", 0, $true, $null)
        $cur = $root

        $null = foreach ($line in $lineInput) {
            switch -regex ($line) {
                '\$\scd\s(?<Name>\/|[a-z]+)' { 
                    "Create directory $($matches.Name)" 
                        $dir = New-Directory -Name $matches.Name -Parent $cur
                        $cur.AddChild($dir)
                        $cur = $dir
                }
                '(?<Size>\d+)\s(?<Name>\w+\.\w+|\w+)' { 
                    "Create file $($matches.Name)" 
                        $file = New-File -Name $matches.Name -Size $matches.Size -Parent $cur
                        $cur.AddChild($file)
                }
                '\$\scd\s\.\.' { 
                    "Go up a directory" 
                        $cur = $cur.Parent
                }
            }
        }

    $null = $root.GetTotalSize()


    return $root

}

function New-Directory([string]$name,[Directory]$parent) {
    return [Directory]::new($name, 0, $true, $parent)
}

function New-File([string]$name,[int]$size,[Directory]$parent) {
    return [Directory]::new($name, $size, $false, $parent) 
}

function Convert-InputToArray([string]$filename) {
    $lineInput = (Get-Content $filename) -split "`n"
        return $lineInput[1..($lineInput.count - 1)]
}
