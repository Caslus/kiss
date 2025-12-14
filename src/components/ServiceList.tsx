import { useEffect, useState } from "preact/hooks";

import type { Config } from "../types/config";
import ConfigSchema from "../types/config";
import { hasDuplicateServiceIds } from "../utils/validation";
import ErrorMessage from "./ErrorMessage";
import Footer from "./Footer";
import Logo from "./Logo";
import Service from "./Service";
import Title from "./Title";

const Width = {
	ROWS_1: "max-w-xl",
	ROWS_2: "max-w-2xl",
	ROWS_3: "max-w-4xl",
	ROWS_4: "max-w-7xl",
};

export default function ServiceList() {
	const [config, setConfig] = useState<Config | null>(null);
	const [loading, setLoading] = useState(true);
	const [error, setError] = useState<string | null>(null);

	useEffect(() => {
		fetch("/config.json", {
			cache: "no-cache",
		})
			.then((res) => {
				if (!res.ok) {
					throw new Error(`HTTP error! status: ${res.status}`);
				}
				return res.json();
			})
			.then((data) => {
				try {
					const validatedConfig = ConfigSchema.parse(data);

					if (hasDuplicateServiceIds(validatedConfig)) {
						throw new Error(
							"Duplicate service IDs found in configuration. Each service must have a unique ID.",
						);
					}

					setConfig(validatedConfig);
					document.title = `${validatedConfig.title} • KISS`;
				} catch (e) {
					throw new Error("Invalid configuration structure.", { cause: e });
				}
			})
			.catch((err) => {
				console.error("Failed to load configuration.\n", err.cause || err);
				setError(
					`${err.message}${err.message[err.message.length - 1] !== "." ? "." : ""} Please check console for details.`,
				);
				document.title = `Configuration Error • KISS`;
			})
			.finally(() => {
				setLoading(false);
			});
	}, []);

	if (loading) {
		return (
			<div class="flex flex-col justify-center items-center">
				<div className="text-gray-400 animate-spin">😵‍💫</div>
				<div className="text-gray-400 mt-4">Loading configuration...</div>
			</div>
		);
	}

	if (error || !config) {
		return (
			<>
				<ErrorMessage config={config} error={error} />
				<Footer disabled={config?.disableFooter} />
			</>
		);
	}

	return (
		<>
			<div class="flex-1 flex flex-col items-center justify-center">
				<Logo config={config} />
				<Title title={config.title} disableTitle={config.disableTitle} />
				<ul
					className={`flex flex-row flex-wrap justify-center ${Width.ROWS_2} gap-2`}
				>
					{config.services.map((service) => (
						<li key={service.id}>
							<Service
								service={service}
								checkHealth={
									service.overrideCheckHealth !== undefined
										? service.overrideCheckHealth
										: config.checkHealth &&
											(service.internalUrl || service.url) !== undefined
								}
							/>
						</li>
					))}
				</ul>
			</div>
			<Footer disabled={config.disableFooter} />
		</>
	);
}
