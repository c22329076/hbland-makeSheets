$now = (Get-Date).ToUniversalTime().AddHours(8)

if ($now.DayOfWeek -eq 'Monday') {
    $target = $now.AddDays(-3)
} else {
    $target = $now.AddDays(-1)
}

$rocYear = $target.Year - 1911
$month = "{0:D2}" -f $target.Month
$day = "{0:D2}" -f $target.Day
$roc = "{0}{1}{2}" -f $rocYear.ToString("000"), $month, $day

Write-Output $roc
