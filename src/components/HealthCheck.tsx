import { useEffect, useState } from "preact/hooks";

interface Props {
	serviceUrl: string;
	classes?: string;
}

export const HealthCheck = ({ serviceUrl, classes }: Props) => {
	const [healthy, setHealthy] = useState<boolean | undefined>(undefined);

	async function healthCheck(url: string) {
		try {
			const request: Request = new Request(url, {
				method: "HEAD",
				mode: "no-cors",
				cache: "no-cache",
			});
			await fetch(request).then(() => {
				setHealthy(true);
			});
		} catch (error) {
			console.log(error);
			setHealthy(false);
		}
	}

	useEffect(() => {
		if (serviceUrl) {
			healthCheck(serviceUrl);
		} else {
			setHealthy(false);
		}
	}, [serviceUrl]);

	return (
		<div
			class={`before:content-[''] w-4 h-4 rounded-full shadow-glow animate-glow-flicker
				${classes}
				${healthy === undefined ? "bg-yellow-500 shadow shadow-yellow-500" : healthy ? "bg-green-500 shadow-green-500" : "bg-red-500 shadow-red-500"}`}
		/>
	);
};
