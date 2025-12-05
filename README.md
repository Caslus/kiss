<div style="text-align: center;">
    <img src="./public/kiss_banner.svg" alt="KISS Homelab Dashboard" style="width: 60%; max-width: 400px;" />
</div>

**KISS** is a fast, minimal, and static launcher for your self-hosted services or favorite websites. Built with **Astro** and **Preact**, it's designed to be a somewhat lightweight and good-looking alternative to more complex dashboards.

![KISS Homelab Dashboard Screenshot](./public/screenshot.png)

### ✨ Key Features

* **Insane Performance:** Static frontend built with Astro, loads pretty quick if you were to ask me. 😉
* **Simple Configuration:** Uses a single `config.json` file. Change the JSON, restart the container, done.
* **Type Safe:** Configuration is validated at runtime. If something is wrong, the page gives you clear feedback.
* **Docker-Native:** Ships ready for deployment via Docker, handling config injection seamlessly.


<br>

## 🚀 Quick Start: Copy-Paste Deployment

The fastest way to deploy KISS is using **Docker Compose**.

### 1. Run with Docker Compose

Use the following `docker-compose.yml` file:

```yaml
version: '3.8'

services:
  homepage:
    image: caslus/kiss:latest
    container_name: kiss
    ports:
      - "8080:8080"
    volumes:
    # change ./config.json to the path of your config file
    # or create one in the same directory as this docker-compose.yml
      - ./config.json:/app/external/config.json
    restart: unless-stopped
```

Start the application:

```bash
docker-compose up -d
```

### 1.2. Alternative: Using `docker run`

```bash
docker run \
  --name kiss \
  -p 8080:8080 \
  -v ./config.json:/app/external/config.json \
  --restart unless-stopped \
  caslus/kiss:latest
```
---

### 2. Configuration File (Example)

To set up your own `config.json`, you can start with this example:

```json
{
  "title": "My Awesome Homelab",
  "checkHealth": true,
  "customLogo": "./local-logo.svg",
  "services": [
    {
      "id": "plex",
      "displayName": "Plex Media Server",
      "url": "https://plex.example.com",
      "iconUrl": "https://cdn.example.com/icons/plex.svg"
    },
    {
      "id": "some-service",
      "displayName": "Some local service",
      "internalUrl": "http://local-service:1234",
      "overrideCheckHealth": false
    }
  ]
}
```

📄 **See the Full Configuration Schema in the Docs**

For all available fields and options, including required fields like `id` and `displayName`, please refer to the **[documentation](<https://caslus.github.io/kiss/>)**.

<br>

## 💻 Local Development

1.  **Install dependencies:**
    ```sh
    pnpm install
    ```
2.  **Run development server:**
    ```sh
    pnpm dev
    ```
    *(Requires a local `config.json` file for the dev server. You can copy the example from the root directory and rename it to `config.json`.)*