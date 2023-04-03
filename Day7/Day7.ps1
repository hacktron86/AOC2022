class Directory
{
    [string] $Name
    [int] $Size
    [bool] $IsDirectory
    [Directory[]] $Children
    [Directory] $Parent
    [int] $directorySize

    Directory($name, $size, $isDirectory, $parent)
    {
        $this.Name = $name
        $this.Size = $size
        $this.IsDirectory = $isDirectory
        $this.Children = @()
        $this.Parent = $parent
    }

    [int] SubDirectoryCount()
    {
        $totalCount = if ($this.IsDirectory)
        {1
        } else
        {0
        }
        foreach ($child in $this.Children)
        {
            if ($child.IsDirectory)
            {
                $totalCount += $child.SubDirectoryCount()
            }
        }
        return $totalCount
    }

    [int] FileCount()
    {
        $totalCount = 0
        foreach ($child in $this.Children)
        {
            if ($child.IsDirectory)
            {
                $totalCount += $child.FileCount()
            } else
            {
                $totalCount += 1
            }
        }
        return $totalCount
    }

    [void] AddChild([Directory]$child)
    {
        $this.Children += $child
    }

    [int] GetTotalSize()
    {
        $totalSize = $this.Size
        foreach ($child in $this.Children)
        {
            if ($child.IsDirectory)
            {
                $totalSize += $child.GetTotalSize()
            } else
            {
                $totalSize += $child.Size
            }
        }
        $this.directorySize = $totalSize
        return $totalSize
    }

    [PSCustomObject[]] GetAllDirectorySizes()
    {
        $directorySizes = @()
        $directorySizes += 
        [PSCustomObject]@{
            Size = $this.directorySize
            Difference = 29641087 - $this.directorySize
        }
        foreach ($child in ($this.Children | Where-Object { $_.isDirectory}) )
        {
            $directorySizes += $child.GetAllDirectorySizes()
        }
        return $directorySizes
    }

    [int] GetPartTwo()
    {
        $res = $this.GetAllDirectorySizes() 
        $max = 
        $res | 
            Where-Object { $_.Difference -lt 0 } | 
            Measure-Object -Property Difference -Maximum |
            Select-Object -ExpandProperty Maximum
        return ($res | Where-Object { $_.Difference -eq $max }).Size
    }

    [int] GetPartOne()
    {
        $partOneSum = if($this.directorySize -gt 100000)
        {0
        } else
        {$this.directorySize
        }
        foreach ($child in $this.Children)
        {
            if ($child.IsDirectory)
            {
                $partOneSum += $child.GetPartOne()
            } else
            {
                $totalSize += $child.directorySize
            }
        }
        return $partOneSum
    }

    [void] UpdateDirectorySize()
    {
        $this.directorySize = $this.GetTotalSize()
    }
}

function Build-Directory
{

    $lineInput = Convert-InputToArray -filename "input.txt"
    $root = [Directory]::new("/", 0, $true, $null)
    $cur = $root
    $directoryCount = 0
    $fileCount = 0

    $null = foreach ($line in $lineInput)
    {
        switch -regex ($line)
        {
            '\$\scd\s(?<Name>\/|[a-z]+)'
            { 
                "Create directory $($matches.Name)" 
                $directoryCount++
                $dir = New-Directory -Name $matches.Name -Parent $cur
                $cur.AddChild($dir)
                $cur = $dir
            }
            '(?<Size>\d+)\s(?<Name>\w+\.\w+|\w+)'
            { 
                "Create file $($matches.Name)" 
                $fileCount++
                $file = New-File -Name $matches.Name -Size $matches.Size -Parent $cur
                $cur.AddChild($file)
            }
            '\$\scd\s\.\.'
            { 
                "Go up a directory" 
                $cur = $cur.Parent
            }
        }
    }

    $null = $root.GetTotalSize()

    Write-Information "Directory Count: $directoryCount" -InformationAction Continue
    Write-Information "File Count: $fileCount" -InformationAction Continue

    return $root

}

function New-Directory([string]$name,[Directory]$parent)
{
    return [Directory]::new($name, 0, $true, $parent)
}

function New-File([string]$name,[int]$size,[Directory]$parent)
{
    return [Directory]::new($name, $size, $false, $parent) 
}

function Convert-InputToArray([string]$filename)
{
    $lineInput = (Get-Content $filename) -split "`n"
    return $lineInput[1..($lineInput.count - 1)]
}
