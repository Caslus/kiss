import type { Config } from "../types/config";

interface Props {
	config: Config | null;
}

export default function Logo({ config }: Props) {
	if (config?.disableLogo) {
		return null;
	}

	return (
		<img
			src={config?.customLogo ?? "./kiss_logo.png"}
			alt={config?.customLogo ? "Custom Logo" : "KISS Logo"}
			className="pb-10 w-96 select-none"
			draggable={false}
		/>
	);
}
