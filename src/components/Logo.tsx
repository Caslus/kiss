import type { Config } from "../types/config";

interface Props {
	config: Config | null;
}

export default function Logo({ config }: Props) {
	if (config?.disableLogo) {
		return null;
	}

	const usingCustomLogo = Boolean(
		config?.customLogo && config.customLogo.length > 0,
	);

	return (
		<img
			src={usingCustomLogo ? config?.customLogo : "./kiss_logo.png"}
			alt={usingCustomLogo ? "Custom Logo" : "KISS Logo"}
			className="pb-10 w-96 select-none"
			draggable={false}
		/>
	);
}
