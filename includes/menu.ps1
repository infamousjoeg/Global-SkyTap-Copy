Add-Type -AssemblyName System.Windows.Forms

$frmMenu = New-Object system.Windows.Forms.Form
$frmMenu.Text = "Global SkyTap Copy v1.0.1"
$frmMenu.TopMost = $true
$frmMenu.Icon = New-Object system.drawing.icon("gsc.ico")
$frmMenu.Width = 344
$frmMenu.Height = 195

$chkUS = New-Object system.windows.Forms.CheckBox
$chkUS.Text = "US"
$chkUS.AutoSize = $true
$chkUS.Width = 95
$chkUS.Height = 20
$chkUS.Add_Click({
#add here code triggered by the event
})
$chkUS.location = new-object system.drawing.point(10,30)
$chkUS.Font = "Segoe UI,12"
$frmMenu.controls.Add($chkUS)

$chkEMEA = New-Object system.windows.Forms.CheckBox
$chkEMEA.Text = "EMEA"
$chkEMEA.AutoSize = $true
$chkEMEA.Width = 95
$chkEMEA.Height = 20
$chkEMEA.Add_Click({
#add here code triggered by the event
})
$chkEMEA.location = new-object system.drawing.point(10,55)
$chkEMEA.Font = "Segoe UI,12"
$frmMenu.controls.Add($chkEMEA)

$chkAPAC = New-Object system.windows.Forms.CheckBox
$chkAPAC.Text = "APAC"
$chkAPAC.AutoSize = $true
$chkAPAC.Width = 95
$chkAPAC.Height = 20
$chkAPAC.Add_Click({
#add here code triggered by the event
})
$chkAPAC.location = new-object system.drawing.point(10,80)
$chkAPAC.Font = "Segoe UI,12"
$frmMenu.controls.Add($chkAPAC)

$lblRegions = New-Object system.windows.Forms.Label
$lblRegions.Text = "Copy To:"
$lblRegions.AutoSize = $true
$lblRegions.Width = 25
$lblRegions.Height = 10
$lblRegions.location = new-object system.drawing.point(5,5)
$lblRegions.Font = "Segoe UI,14,style=Bold"
$frmMenu.controls.Add($lblRegions)

$lblEnvironments = New-Object system.windows.Forms.Label
$lblEnvironments.Text = "Environment:"
$lblEnvironments.AutoSize = $true
$lblEnvironments.Width = 25
$lblEnvironments.Height = 10
$lblEnvironments.location = new-object system.drawing.point(100,5)
$lblEnvironments.Font = "Segoe UI,14,style=Bold"
$frmMenu.controls.Add($lblEnvironments)

$chkDEV = New-Object system.windows.Forms.CheckBox
$chkDEV.Text = "DEV"
$chkDEV.AutoSize = $true
$chkDEV.Width = 95
$chkDEV.Height = 20
$chkDEV.Add_Click({
#add here code triggered by the event
})
$chkDEV.location = new-object system.drawing.point(100,30)
$chkDEV.Font = "Segoe UI,12"
$frmMenu.controls.Add($chkDEV)

$chkQA = New-Object system.windows.Forms.CheckBox
$chkQA.Text = "QA"
$chkQA.AutoSize = $true
$chkQA.Width = 95
$chkQA.Height = 20
$chkQA.Add_Click({
#add here code triggered by the event
})
$chkQA.location = new-object system.drawing.point(100,55)
$chkQA.Font = "Segoe UI,12"
$frmMenu.controls.Add($chkQA)

$chkGA = New-Object system.windows.Forms.CheckBox
$chkGA.Text = "GA"
$chkGA.AutoSize = $true
$chkGA.Width = 95
$chkGA.Height = 20
$chkGA.Add_Click({
#add here code triggered by the event
})
$chkGA.location = new-object system.drawing.point(100,80)
$chkGA.Font = "Segoe UI,12"
$frmMenu.controls.Add($chkGA)

$btnStart = New-Object system.windows.Forms.Button
$btnStart.Text = "Start"
$btnStart.Width = 60
$btnStart.Height = 30
$btnStart.Add_Click({
#add here code triggered by the event
})
$btnStart.location = new-object system.drawing.point(253,44)
$btnStart.Font = "Segoe UI,12"
$frmMenu.controls.Add($btnStart)

$txtStatus = New-Object system.windows.Forms.TextBox
$txtStatus.Text = "Status: Collecting User Input"
$txtStatus.Width = 228
$txtStatus.Height = 20
$txtStatus.enabled = $false
$txtStatus.location = new-object system.drawing.point(10,120)
$txtStatus.Font = "Segoe UI,10"
$frmMenu.controls.Add($txtStatus)

[void]$frmMenu.ShowDialog()
$frmMenu.Dispose()