# sjekk.ps1 – den lokale feedback-løkken. Kjøres fra rota av repoet:
#   pwsh ./sjekk.ps1                   (sjekker modules/network)
#   pwsh ./sjekk.ps1 -Mappe modul8     (sjekker en annen mappe)
param([string]$Mappe = "modules/network")

$steg = [ordered]@{
  "fmt"      = { terraform fmt -check -diff -recursive }
  "init"     = { terraform init -backend=false -input=false > $null }
  "validate" = { terraform validate }
  "tflint"   = { tflint --init > $null; tflint }
  "checkov"  = { checkov -d . }
  "test"     = { terraform test }
}

Push-Location $Mappe
try {
  foreach ($navn in $steg.Keys) {
    Write-Host "`n== $navn ==" -ForegroundColor Cyan
    & $steg[$navn]
    if ($LASTEXITCODE -ne 0) {
      Write-Host "`n✗ Stoppet på $navn" -ForegroundColor Red
      exit 1
    }
  }
  Write-Host "`n✓ Alle sjekkene er grønne" -ForegroundColor Green
}
finally {
  Pop-Location
}