# grgx

**grgx** is a lightweight PowerShell script runner and manager designed to organize and execute your personal or project-specific PowerShell scripts efficiently.

## Features

- **Centralized Script Management**: Keep all your utility scripts in one place (`plugins` directory).
- **Easy Execution**: Run scripts using the `grgx` command (e.g., `grgx my-script`).
- **Tab Completion**: Auto-complete script names in your terminal.

## Installation

### Option 1: with git

1. Clone the repository:

   ```powershell
   git clone https://github.com/grgsh/grgx.git
   cd grgx
   ```

2. Run the installation script:

   ```powershell
   .\install.ps1
   ```

   This will copy the necessary files to your local application data folder (`$env:APPDATA\grgsh\grgx`) and add the `bin` directory to your `PATH`.

3. **Restart your terminal** to apply the PATH changes.

4. (Optional) Add initialization to your PowerShell profile for tab completion:
   Add the following line to your `$PROFILE`:
   ```
   grgx-init
   ```

#### Remote files

You can also use `-Remote` flag for the install script - it will download the latest source code from this repository and use it for the installation instead of the local files.

### Option 2: true remote installation

You can also install the suite without cloning this repo. I do not recommend this option as you should analyze the code you're executing - never run code you don't understand.

#### A one-liner

```powershell
$uS='https://github.com/grgsh/grgx/raw/refs/heads/main/Install.ps1';$uM='https://github.com/grgsh/grgx/raw/refs/heads/main/Install.psm1';$nS=Split-Path -Leaf $uS;$nM=Split-Path -Leaf $uM;$tmp=$env:TMP;$pS=Join-Path $tmp $nS;$pM=Join-Path $tmp $nM;iwr $uS -OutFile $pS -ea Stop;iwr $uM -OutFile $pM -ea Stop;powershell.exe -ep Bypass -f $pS -Remote;ri $pS -Force -ea SilentlyContinue;ri $pM -Force -ea SilentlyContinue
```

#### The one-liner explained:

```powershell
# Define the URLs
$ScriptUrl='https://github.com/grgsh/grgx/raw/refs/heads/main/Install.ps1';
$ModuleUrl='https://github.com/grgsh/grgx/raw/refs/heads/main/Install.psm1';

# Automatically extract names, define temp dir, and full paths
$ScriptFileName=Split-Path -Leaf $ScriptUrl;
$ModuleFileName=Split-Path -Leaf $ModuleUrl;
$TempDirectory=$env:TMP;
$FullScriptPath=Join-Path $TempDirectory $ScriptFileName;
$FullModulePath=Join-Path $TempDirectory $ModuleFileName;

# 1 & 2. Download files to the temporary directory
Invoke-WebRequest -Uri $ScriptUrl -OutFile $FullScriptPath -ErrorAction Stop;
Invoke-WebRequest -Uri $ModuleUrl -OutFile $FullModulePath -ErrorAction Stop;

# 3. Execute the script with Bypass policy (FIXED)
# The -Remote flag is passed to the Install.ps1 script after the -File argument.
powershell.exe -ExecutionPolicy Bypass -File $FullScriptPath -Remote;

# 4. Clean up (using alias 'ri' for Remove-Item and abbreviations)
ri $FullScriptPath -Force -ErrorAction SilentlyContinue;
ri $FullModulePath -Force -ErrorAction SilentlyContinue;
```

## Usage

Once installed, you can run any script located in your `modules` directory using the `grgx` command.

```powershell
grgx <script-name> [arguments]
```

> **Note:** Passing arguments down to scripts hasn't been tested yet

### Example

If you have a script named `hello.ps1` in your plugins directory:

```powershell
grgx hello -Name "World"
```

## Directory Structure

- **bin/**: Executable wrappers and entry points (`grgx.ps1`, `grgx-init.ps1`).
- **lib/**: Core PowerShell modules (`Grgx.psm1`, `GrgxConfig.psm1`, etc.).
- **completions/**: Tab completion logic.
- **plugins/**: Directory for your user scripts.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
