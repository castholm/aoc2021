function Solve-Day9Part1 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $Current
    )
    begin {
        $rows = [System.Collections.Generic.List[int[]]]::new()
    }
    process {
        $rows.Add([int[]][string[]]$Current.ToCharArray())
    }
    end {
        $riskLevelSum = 0
        for ($y = 0; $y -lt $rows.Count; $y++) {
            $row = $rows[$y]
            for ($x = 0; $x -lt $row.Count; $x++) {
                $cell = $row[$x]
                if (
                    ($x -eq 0 -or $cell -lt $row[$x - 1]) `
                    -and ($x -eq $row.Count - 1 -or $cell -lt $row[$x + 1]) `
                    -and ($y -eq 0 -or $cell -lt $rows[$y - 1][$x]) `
                    -and ($y -eq $rows.Count - 1 -or $cell -lt $rows[$y + 1][$x])
                ) {
                    $riskLevelSum += $cell + 1
                }
            }
        }

        $riskLevelSum
    }
}

function Solve-Day9Part2 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $Current
    )
    begin {
        $rows = [System.Collections.Generic.List[int[]]]::new()

        function MarkAndCount-Neighbors($rows, $x, $y) {
            $row = $rows[$y]
            $row[$x] = $row[$x] + 9

            $size = 1
            if ($x -ne 0 -and $row[$x - 1] -lt 9) {
                $size += MarkAndCount-Neighbors $rows ($x - 1) $y
            }
            if ($x -ne $row.Count - 1 -and $row[$x + 1] -lt 9) {
                $size += MarkAndCount-Neighbors $rows ($x + 1) $y
            }
            if ($y -ne 0 -and $rows[$y - 1][$x] -lt 9) {
                $size += MarkAndCount-Neighbors $rows $x ($y - 1)
            }
            if ($y -ne $rows.Count - 1 -and $rows[$y + 1][$x] -lt 9) {
                $size += MarkAndCount-Neighbors $rows $x ($y + 1)
            }

            $size
        }
    }
    process {
        $rows.Add([int[]][string[]]$Current.ToCharArray())
    }
    end {
        $basinSizes = [System.Collections.Generic.List[int]]::new()
        for ($y = 0; $y -lt $rows.Count; $y++) {
            $row = $rows[$y]
            for ($x = 0; $x -lt $row.Count; $x++) {
                if ($row[$x] -lt 9) {
                    $basinSizes.Add((MarkAndCount-Neighbors $rows $x $y))
                }
            }
        }
        $a, $b, $c = ($basinSizes | Sort-Object -Descending)[0..2]

        $a * $b * $c
    }
}
