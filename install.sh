#!/bin/sh

# Function to install a theme from a GitHub repository
install_theme() {
  local REPO_NAME=$1
  local THEME_NAME=$2

  echo "Processing $THEME_NAME..."

  # GitHub repository URL and package name
  LATEST_RELEASE_URL="https://api.github.com/repos/peditx/$REPO_NAME/releases/latest"
  IPK_URL=$(curl -s "$LATEST_RELEASE_URL" | grep "browser_download_url.*ipk" | cut -d '"' -f 4)

  # Check if the download link is found
  if [ -z "$IPK_URL" ]; then
    echo "Download link for the .ipk file of $THEME_NAME not found."
    return 1
  fi

  # Download the .ipk package
  echo "Downloading the latest version of $THEME_NAME..."
  wget -q "$IPK_URL" -O "/tmp/$THEME_NAME.ipk"

  # Install the .ipk package
  echo "Installing $THEME_NAME..."
  opkg install "/tmp/$THEME_NAME.ipk"

  # Clean up the downloaded file
  rm "/tmp/$THEME_NAME.ipk"

  echo "$THEME_NAME installed successfully."
}

# Install luci-theme-peditx
install_theme "luci-theme-peditx" "luci-theme-peditx"

# Remove the default theme
opkg remove luci-theme-bootstrap --force-depends

# Restart the web service to apply the changes
echo "Restarting uhttpd service to apply changes..."
/etc/init.d/uhttpd restart

echo "Done."
