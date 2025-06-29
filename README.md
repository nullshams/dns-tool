# 🧠 DNS Manager - A Powerful Bash Script for Linux

This powerful and easy-to-use DNS management script simplifies how you handle DNS settings on your Linux system. It allows you to automatically or manually apply DNS configurations, add custom DNS entries, and easily restore your default setup.

---

## ✨ Features

* **🚀 Automatic Fast DNS Selection:** Automatically selects the fastest DNS server based on ping times, ensuring optimal performance.
* **🧭 Manual DNS Selection:** Choose your preferred DNS provider from a sorted list of known, reliable options.
* **🧠 View Current DNS Settings:** Quickly check your active DNS settings and identify the provider if it's a known one.
* **🔧 Restore Default DNS:** Easily revert to your original DNS configuration with a single command.
* **➕ Add Custom DNS Entries:** Permanently add and save your own custom DNS entries. These are stored in `~/.dns_custom.conf` for persistence across sessions.

---

## 📥 Installation

Getting started with DNS Manager is straightforward:

1.  **Clone the repository or download the script:**

    ```bash
    git clone https://github.com/mehditoxic/DNSTOOL.git
    cd dns-manager
    ```

2.  **Make the script executable:**

    ```bash
    chmod +x dns.sh
    ```

3.  **Run the script:**

    ```bash
    sudo ./dns.sh
    ```

Once running, you'll see a main menu with the following options:

* `1` — Automatically select the fastest DNS
* `2` — Manually choose a DNS from the ranked list
* `3` — Show current DNS settings
* `4` — Restore default DNS settings
* `5` — Add a new custom DNS
* `99` — Exit the tool

---

## 🔐 Permissions

* This script **must be run as root** (`sudo`) because it modifies `/etc/resolv.conf`.
* A backup of your original DNS settings is always saved at `/etc/resolv.conf.backup` before any changes are made.

---

## 💡 Important Notes

* **Ping Measurements:** Ping times are calculated using the first IP address of each DNS entry.
* **Server Status:** Non-responsive DNS servers are clearly marked within the script's output.
* **Persistence:** Custom DNS entries you add will persist across system reboots.

---

## 📜 License

This project is released under the [MIT License](https://opensource.org/licenses/MIT). Feel free to use, modify, and share it.

---

## 👨‍💻 Author

Created with 💚 by [METI]
