@echo off
echo Starting local web server to serve files through HTTP...
echo This will allow you to download the MSI file from your browser properly.
echo.
echo Once the server starts, open your browser and go to: http://localhost:8000
echo.
echo Press Ctrl+C to stop the server when you're done.
echo.

:: Check if Python is available and start the server
python --version >nul 2>&1
if %errorlevel% equ 0 (
    python -m http.server 8000
    goto end
)

:: If Python not found, try PowerShell's built-in web server
pwsh --version >nul 2>&1
if %errorlevel% equ 0 (
    powershell -Command "$listener = New-Object System.Net.HttpListener; $listener.Prefixes.Add('http://localhost:8000/'); $listener.Start(); Write-Host('Server running at http://localhost:8000/'); while ($listener.IsListening) { $context = $listener.GetContext(); $request = $context.Request; $response = $context.Response; $localPath = $request.Url.LocalPath; if ($localPath -eq '/') { $localPath = '/index.html' }; $filePath = Join-Path (Get-Location) $localPath.TrimStart('/'); if (Test-Path $filePath) { $content = [System.IO.File]::ReadAllBytes($filePath); $response.ContentLength64 = $content.Length; $response.OutputStream.Write($content, 0, $content.Length) } else { $response.StatusCode = 404 }; $response.OutputStream.Close(); }"
    goto end
)

echo.
echo Error: Could not find Python or PowerShell to start web server.
echo.

:end
pause