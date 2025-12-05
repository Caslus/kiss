import { z } from "zod";

const ServiceSchema = z.object({
	id: z.string().min(1, "Service ID cannot be empty"),
	displayName: z.string().min(1, "Service display name cannot be empty"),
	url: z.url("Service URL must be a valid URL").optional(),
	internalUrl: z.url("Service internal URL must be a valid URL").optional(),
	iconUrl: z
		.url("Service icon URL must be a valid URL")
		.or(z.string().startsWith("./"))
		.optional(),
	overrideCheckHealth: z.boolean().optional(), // if empty, use global config, otherwise use this value
});

const ConfigSchema = z.object({
	title: z.string().default("Homepage"),
	checkHealth: z.boolean().default(false),
	disableLogo: z.boolean().default(false),
	disableTitle: z.boolean().default(false),
	disableFooter: z.boolean().default(false),
	customLogo: z
		.url("Custom logo URL must be a valid URL")
		.or(z.string().startsWith("./"))
		.optional(),

	services: z
		.array(
			ServiceSchema,
			"There is no 'services' defined in the configuration, check for typos.",
		)
		.min(1, "At least one service must be defined"),
});

export type Service = z.infer<typeof ServiceSchema>;
export type Config = z.infer<typeof ConfigSchema>;
export { ConfigSchema as default };
