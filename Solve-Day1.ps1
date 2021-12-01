function Solve-Day1Part1 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [int]
        $CurrentMeasurement
    )
    begin {
        $PreviousMeasurement = $null
        $Increments = 0
    }
    process {
        if ($PreviousMeasurement -ne $null -and $CurrentMeasurement -gt $PreviousMeasurement) {
            $Increments++
        }
        $PreviousMeasurement = $CurrentMeasurement
    }
    end {
        $Increments
    }
}

function Solve-Day1Part2 {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [int]
        $CurrentMeasurement
    )
    begin {
        $CurrentWindow = @()
        $PreviousSum = $null
        $Increments = 0
    }
    process {
        $CurrentWindow = $CurrentWindow[-2..-1] + $CurrentMeasurement
        if ($CurrentWindow.Length -ge 3) {
            $CurrentSum = ($CurrentWindow | Measure-Object -Sum).Sum
            if ($PreviousSum -ne $null -and $CurrentSum -gt $PreviousSum) {
                $Increments++
            }
            $PreviousSum = $CurrentSum
        }
    }
    end {
        $Increments
    }
}
