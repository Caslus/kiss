// @ts-check

import preact from "@astrojs/preact";
import tailwindcss from "@tailwindcss/vite";
import { defineConfig, passthroughImageService } from "astro/config";

// https://astro.build/config
export default defineConfig({
	integrations: [preact()],
	vite: {
		plugins: [tailwindcss()],
	},
	image: {
		service: passthroughImageService(),
	},
});
