import * as fs from "node:fs";
import * as toml from "toml";
import ConfigSchema from "../types/config";

async function readConfig() {
	try {
		const configContent = fs.readFileSync("./config.toml", "utf-8");
		const parsedConfig = toml.parse(configContent);
		const validatedConfig = ConfigSchema.parse(parsedConfig);
		console.log("✅ Configuration file is valid.");
		console.log(validatedConfig);
		return validatedConfig;
	} catch (error) {
		console.error(
			"❌ Invalid configuration file, please make sure the structure is correct:",
			error,
		);
	}
}

export { readConfig };
