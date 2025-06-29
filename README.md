
````markdown
# 🧠 DNS Manager - Bash Script

A powerful and simple-to-use DNS management script for Linux. It allows you to automatically or manually apply DNS settings, add custom DNS entries, and restore the default configuration.



## ✨ Features

- 🚀 Automatically select the fastest DNS based on ping time
- 🧭 Manually choose from a sorted list of known DNS providers
- 🧠 View current DNS settings and the provider name (if known)
- 🔧 Restore your original DNS configuration
- ➕ Add custom DNS entries and save them permanently
- 📦 Stores custom DNS entries in `~/.dns_custom.conf`



## 📥 Installation

1. **Clone the repository or download the script:**

   ```bash
   git clone https://github.com/yourusername/dns-manager.git
   cd dns-manager


2. **Make the script executable:**

   ```bash
   chmod +x dns.sh
   ```
3. **RUN:**

   ```bash
  sudo ./dns.sh
   ```

Main menu options include:

* `1` — Automatically select the fastest DNS
* `2` — Manually choose a DNS from the ranked list
* `3` — Show current DNS settings
* `4` — Restore default DNS settings
* `5` — Add a new custom DNS
* `99` — Exit the tool



## 🔐 Permissions

* This script **must be run as root** (`sudo`) to modify `/etc/resolv.conf`.
* A backup of your original DNS settings is saved at `/etc/resolv.conf.backup`.



## 💡 Notes

* Ping times are measured using the first IP address of each DNS entry.
* Non-responsive DNS servers are marked accordingly.
* Custom DNS entries persist across sessions.



## 📜 License

MIT License — Feel free to use, modify, and share.



## 👨‍💻 Author

Created with 💚 by \[METI]




Let me know if you'd like help generating this into a file, or if you're planning to publish it under your GitHub username — I can update the repo URL and author credits for you.
```
