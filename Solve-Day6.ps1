function Solve-Day6Part1 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $Current
    )
    begin {
        $timers = [int[]]::new(9)
    }
    process {
        foreach ($timer in $Current -split ",") {
            $timers[$timer]++
        }
    }
    end {
        for ($i = 0; $i -lt 80; $i++) {
            $timers = $timers[1, 2, 3, 4, 5, 6, 7, 8, 0]
            $timers[6] += $timers[8]
        }

        ($timers | Measure-Object -Sum).Sum
    }
}

function Solve-Day6Part2 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $Current
    )
    begin {
        $timers = [int[]]::new(9)
    }
    process {
        foreach ($timer in $Current -split ",") {
            $timers[$timer]++
        }
    }
    end {
        for ($i = 0; $i -lt 256; $i++) {
            $timers = $timers[1, 2, 3, 4, 5, 6, 7, 8, 0]
            $timers[6] += $timers[8]
        }

        ($timers | Measure-Object -Sum).Sum
    }
}
