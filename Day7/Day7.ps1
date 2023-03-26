class Directory {
    [string] $Name
        [int] $Size
            [bool] $IsDirectory
                [Directory[]] $Children
                    [Directory] $Parent

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
        return $totalSize
    }
}

function Build-Directory {

    $lineInput = Convert-InputToArray -filename "testinput.txt"
        $lineInput = $lineInput[1..($lineInput.count - 1)]

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

    return $root

   # $root = [Directory]::new("root", 0, $true)
   #     $subdir1 = [Directory]::new("subdir1", 0, $true)
   #     $subdir2 = [Directory]::new("subdir2", 0, $true)
   #     $file1 = [Directory]::new("file1", 50, $false)
   #     $file2 = [Directory]::new("file2", 75, $false)

   #     $root.AddChild($subdir1)
   #     $root.AddChild($subdir2)
   #     $subdir1.AddChild($file1)
   #     $subdir2.AddChild($file2)

   #     $root.GetTotalSize()


}

function New-Directory([string]$name,[Directory]$parent) {
    return [Directory]::new($name, 0, $true, $parent)
}

function New-File([string]$name,[int]$size,[Directory]$parent) {
    return [Directory]::new($name, $size, $false, $parent) 
}

function Convert-InputToArray([string]$filename) {

    return (Get-Content $filename) -split "`n"

}
