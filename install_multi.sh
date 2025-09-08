#!/usr/bin/env bash
set -euo pipefail

# ask for repository and clone if needed
read -rp "Enter Git repository URL for the bot: " REPO_URL
REPO_DIR=$(basename "$REPO_URL" .git)

if [ ! -d "$REPO_DIR" ]; then
    git clone "$REPO_URL"
fi
cd "$REPO_DIR"

# install required packages
sudo apt-get update
sudo apt-get install -y python3 python3-venv python3-pip git

# set up virtual environment
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

# ask user how many bots
read -rp "How many bots do you want to install? " BOT_COUNT

for i in $(seq 1 "$BOT_COUNT"); do
    read -rp "Enter Telegram bot token for bot #$i: " TOKEN
    ENV_FILE=".env.$i"
    cat > "$ENV_FILE" <<EOF2
TELEGRAM_BOT_TOKEN=$TOKEN
EOF2
    SERVICE_NAME="semeru-bot$i"
    SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"
    sudo tee "$SERVICE_FILE" >/dev/null <<EOF2
[Unit]
Description=Semeru Booking Bot instance $i
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$(pwd)
Environment="PATH=$(pwd)/venv/bin"
EnvironmentFile=$(pwd)/$ENV_FILE
ExecStart=$(pwd)/venv/bin/python bot-semeru.py
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF2

done

sudo systemctl daemon-reload
for i in $(seq 1 "$BOT_COUNT"); do
    sudo systemctl enable "semeru-bot$i"
    sudo systemctl restart "semeru-bot$i"
done

echo "Installation complete. Started $BOT_COUNT bot service(s)."
echo "Use 'sudo systemctl restart semeru-bot1' (etc.) to restart the bots."
echo "View logs with 'sudo journalctl -u semeru-bot1 -f' (etc.)."
