# Sectigo Unzip Script

## Description

This script (`sectigo-unzip.sh`) is used to extract SSL certificates from a specified ZIP file. It cleans the CA bundle by removing the second certificate and concatenates the main certificate with the cleaned CA bundle. The final certificate is saved with the same name as the original certificate.

The script also includes options for more flexible handling of the extracted files.

## Usage

```bash
sectigo-unzip <zip_file> [options]
```

### Arguments
- `<zip_file>`: The ZIP file containing SSL certificates to be processed.

### Options
- `--nodel`: Keep the temporary directory after execution.
- `-s`, `--simple`: Extract the cleaned CA bundle and the main certificate separately without combining them.

## Examples

1. Extract and combine the certificates:
   ```bash
   sectigo-unzip crucerosmediterraneo.com.zip
   ```

2. Extract without deleting the temporary directory:
   ```bash
   sectigo-unzip crucerosmediterraneo.com.zip --nodel
   ```

3. Extract the certificates in simple mode without combining:
   ```bash
   sectigo-unzip crucerosmediterraneo.com.zip --simple
   ```

## Installation

### Manual Installation

1. Make the script executable:
   ```bash
   chmod +x sectigo-unzip.sh
   ```

2. Move the script to a directory in your PATH:
   - For a system-wide installation (requires root):
     ```bash
     sudo mv sectigo-unzip.sh /usr/local/bin/sectigo-unzip
     ```
   - For a user-only installation:
     ```bash
     mv sectigo-unzip.sh ~/.local/bin/sectigo-unzip
     ```

3. Ensure the directory is in your PATH:
   - For user-only installation, add the following line to your `.bashrc` or `.zshrc`:
     ```bash
     export PATH="$HOME/.local/bin:$PATH"
     ```

### Installation Script

You can also use the provided installation script:
```bash
./install_sectigo_unzip.sh
```
Follow the prompts to choose the installation location.

## Uninstallation

To uninstall the script, simply remove it from the installation directory:

- If installed system-wide:
  ```bash
  sudo rm /usr/local/bin/sectigo-unzip
  ```

- If installed for the current user:
  ```bash
  rm ~/.local/bin/sectigo-unzip
  ```

## Requirements

- `unzip` command must be available on your system.
- Ensure the ZIP file follows the structure expected by the script, containing the `.crt` and `.ca-bundle` files.

## License

MIT License. See the [license information](LICENSE) for details. 
 
 
