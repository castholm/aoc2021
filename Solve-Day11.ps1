function Solve-Day11Part1 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $Current
    )
    begin {
        $rows = @()
    }
    process {
        $rows += , [int[]][string[]]$Current.ToCharArray()
    }
    end {
        $script:flashes = 0
        for ($step = 0; $step -lt 100; $step++) {
            Iterate-2D $rows 0 10 0 10 {
                Increment-SelfAndAdjacent $rows $x $y
            }
            Iterate-2D $rows 0 10 0 10 {
                if ($row[$x] -gt 9) {
                    $script:flashes++
                    $row[$x] = 0
                }
            }
        }

        $flashes
    }
}

function Solve-Day11Part2 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $Current
    )
    begin {
        $rows = @()
    }
    process {
        $rows += , [int[]][string[]]$Current.ToCharArray()
    }
    end {
        $cellCount = ($rows | ForEach-Object { $_.Count } | Measure-Object -Sum).Sum
        $script:flashes = 0
        $step = 0
        while ($flashes -ne $cellCount) {
            $script:flashes = 0
            Iterate-2D $rows 0 10 0 10 {
                Increment-SelfAndAdjacent $rows $x $y
            }
            Iterate-2D $rows 0 10 0 10 {
                if ($row[$x] -gt 9) {
                    $script:flashes++
                    $row[$x] = 0
                }
            }
            $step++
        }

        $step
    }
}

function Iterate-2D($rows, $xStart, $xEnd, $yStart, $yEnd, $scriptBlock) {
    for ($y = [Math]::Max($yStart, 0); $y -lt [Math]::Min($yEnd, $rows.Count); $y++) {
        $row = $rows[$y]
        for ($x = [Math]::Max($xStart, 0); $x -lt [Math]::Min($xEnd, $row.Count); $x++) {
            & $scriptBlock
        }
    }
}

function Increment-SelfAndAdjacent($rows, $x, $y) {
    $rows[$y][$x]++
    if ($rows[$y][$x] -ne 10) {
        return
    }

    $x_ = $x
    $y_ = $y
    Iterate-2D $rows ($x - 1) ($x + 2) ($y - 1) ($y + 2) {
        if ($x -eq $x_ -and $y -eq $y_) {
            continue
        }
        Increment-SelfAndAdjacent $rows $x $y
    }
}
