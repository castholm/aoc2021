$MaxCoordinate = 1000

function Solve-Day5Part1 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $CurrentLine
    )
    begin {
        $points = [byte[]]::new($MaxCoordinate * $MaxCoordinate)
    }
    process {
        $coordinates = Parse-Line $CurrentLine
        Mark-Points $points @coordinates
    }
    end {
        Count-Intersections $points
    }
}

function Solve-Day5Part2 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]
        $CurrentLine
    )
    begin {
        $points = [byte[]]::new($MaxCoordinate * $MaxCoordinate)
    }
    process {
        $coordinates = Parse-Line $CurrentLine
        Mark-Points $points @coordinates -IncludeDiagonals
    }
    end {
        Count-Intersections $points
    }
}

function Parse-Line($Line) {
    $null = $Line -cmatch '^([0-9]{1,3}),([0-9]{1,3}) -> ([0-9]{1,3}),([0-9]{1,3})$'

    [int[]]$Matches[1, 2, 3, 4]
}

function Mark-Points($Points, $X1, $Y1, $X2, $Y2, [switch] $IncludeDiagonals) {
    if ($X1 -eq $X2) {
        $start = [System.Math]::Min($Y1, $Y2)
        $end = [System.Math]::Max($Y1, $Y2)
        for ($y = $start; $y -le $end; $y++) {
            $Points[$X1 + $MaxCoordinate * $y]++
        }
    } elseif ($Y1 -eq $Y2) {
        $start = [System.Math]::Min($X1, $X2)
        $end = [System.Math]::Max($X1, $X2)
        for ($x = $start; $x -le $end; $x++) {
            $Points[$x + $MaxCoordinate * $Y1]++
        }
    } elseif ($IncludeDiagonals) {
        $distance = [System.Math]::Abs($X2 - $X1)
        # No need to compute the distance for Y separately as '$x2 - $x1' is guaranteed to be equal to '$y2 - $y1'.
        $signX = [System.Math]::Sign($X2 - $X1)
        $signY = [System.Math]::Sign($Y2 - $Y1)
        for ($i = 0; $i -le $distance; $i++) {
            $Points[$X1 + $signX * $i + $MaxCoordinate * ($Y1 + $signY * $i)]++
        }
    }
}

function Count-Intersections($Points) {
    # '($Points | Where-Object { $_ -gt 1 }).Count' is ridiculously slow compared to this plain for loop.
    $intersections = 0
    for ($i = 0; $i -lt $Points.Length; $i++) {
        if ($Points[$i] -gt 1) {
            $intersections++
        }
    }

    $intersections
}
