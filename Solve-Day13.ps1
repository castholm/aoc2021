$GridSide = 2000

function Solve-Day13Part1 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $Current
    )
    begin {
        $grid = [System.Collections.BitArray[]]::new($GridSide)
        for ($i = 0; $i -lt $GridSide; $i++) {
            $grid[$i] = [System.Collections.BitArray]::new($GridSide)
        }
        $foldInstructions = [System.Collections.Generic.List[string]]::new()
    }
    process {
        if ($Current -cmatch '^(\d+),(\d+)$') {
            $grid[$Matches[2]][$Matches[1]] = $true
        } elseif ($Current -cmatch '^fold along ([xy]=\d+)$') {
            $foldInstructions.Add($Matches[1])
        }
    }
    end {
        $endX = $GridSide
        $endY = $GridSide
        $instruction = $foldInstructions[0]
        $axis, [int] $position = $instruction -split "="
        if ($axis -ceq "x") {
            for ($y = 0; $y -lt $endY; $y++) {
                for ($x = 1; $x -le $position; $x++) {
                    $grid[$y][$position - $x] = $grid[$y][$position - $x] -or $grid[$y][$position + $x]
                }
            }
            $endX = $position
        } else {
            for ($y = 1; $y -le $position; $y++) {
                for ($x = 0; $x -lt $endX; $x++) {
                    $grid[$position - $y][$x] = $grid[$position - $y][$x] -or $grid[$position + $y][$x]
                }
            }
            $endY = $position
        }

        $count = 0
        for ($y = 0; $y -lt $endY; $y++) {
            for ($x = 0; $x -lt $endX; $x++) {
                if ($grid[$y][$x]) {
                    $count++
                }
            }
        }

        $count
    }
}

function Solve-Day13Part2 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $Current
    )
    begin {
        $grid = [System.Collections.BitArray[]]::new($GridSide)
        for ($i = 0; $i -lt $GridSide; $i++) {
            $grid[$i] = [System.Collections.BitArray]::new($GridSide)
        }
        $foldInstructions = [System.Collections.Generic.List[string]]::new()
    }
    process {
        if ($Current -cmatch '^(\d+),(\d+)$') {
            $grid[$Matches[2]][$Matches[1]] = $true
        } elseif ($Current -cmatch '^fold along ([xy]=\d+)$') {
            $foldInstructions.Add($Matches[1])
        }
    }
    end {
        $endX = $GridSide
        $endY = $GridSide
        foreach ($instruction in $foldInstructions) {
            $axis, [int] $position = $instruction -split "="
            if ($axis -ceq "x") {
                for ($y = 0; $y -lt $endY; $y++) {
                    for ($x = 1; $x -le $position; $x++) {
                        $grid[$y][$position - $x] = $grid[$y][$position - $x] -or $grid[$y][$position + $x]
                    }
                }
                $endX = $position
            } else {
                for ($y = 1; $y -le $position; $y++) {
                    for ($x = 0; $x -lt $endX; $x++) {
                        $grid[$position - $y][$x] = $grid[$position - $y][$x] -or $grid[$position + $y][$x]
                    }
                }
                $endY = $position
            }
        }

        $grid | ForEach-Object {
            -join ($_ | ForEach-Object { if ($_) { "█" } else { " " } } | Select-Object -First $endX)
        } | Select-Object -First $endY
    }
}
