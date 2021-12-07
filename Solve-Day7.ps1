function Solve-Day7Part1 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $Current
    )
    begin {
        $positions = [System.Collections.Generic.List[int]]::new()
    }
    process {
        $positions.AddRange([int[]]($Current -split ","))
    }
    end {
        $median = if ($positions.Count -band 1) {
            ($positions | Sort-Object)[[Math]::Floor($positions.Count / 2)]
        } else {
            (
                ($positions | Sort-Object)[($positions.Count / 2 - 1), ($positions.Count / 2)] `
                | Measure-Object -Average
            ).Average
        }

        ($positions | ForEach-Object { [Math]::Abs($_ - $median) } | Measure-Object -Sum).Sum
    }
}

function Solve-Day7Part2 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $Current
    )
    begin {
        $positions = [System.Collections.Generic.List[int]]::new()
    }
    process {
        $positions.AddRange([int[]]($Current -split ","))
    }
    end {
        $average = ($positions | Measure-Object -Average).Average
        $averageFloor = [Math]::Floor($average)
        $averageCeil = [Math]::Ceiling($average)

        $sumFloor = ($positions | ForEach-Object {
            $n = [Math]::Abs($_ - $averageFloor)

            $n * ($n + 1) / 2
        } | Measure-Object -Sum).Sum
        $sumCeil = ($positions | ForEach-Object {
            $n = [Math]::Abs($_ - $averageCeil)

            $n * ($n + 1) / 2
        } | Measure-Object -Sum).Sum

        ($sumFloor, $sumCeil | Measure-Object -Minimum).Minimum
    }
}
