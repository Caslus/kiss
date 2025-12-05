import type { Service as ServiceType } from "../types/config";
import { HealthCheck } from "./HealthCheck";

interface Props {
	checkHealth?: boolean;
	service: ServiceType;
}

export default function Service({ checkHealth, service }: Props) {
	return (
		<>
			{service.url ? (
				<a
					href={service.url}
					target="_blank"
					rel="noopener noreferrer"
					draggable={false}
				>
					<div
						className="bg-[rgb(106,95,142)]/20 w-72 h-32 flex flex-row items-center p-4 gap-3 rounded-lg select-none
                    backdrop-blur-sm hover:backdrop-blur-3xl hover:bg-purple-300/20 transition-colors duration-200
                    inset-shadow-card inset-shadow-gray-200
                    relative"
					>
						{service.iconUrl && (
							<img
								src={service.iconUrl}
								alt={`${service.displayName} icon`}
								className="w-16 h-16 select-none"
								draggable={false}
							/>
						)}
						<h2 className="font-semibold text-xl">{service.displayName}</h2>
						{checkHealth ? (
							<HealthCheck
								serviceUrl={service.internalUrl || service.url || ""}
								classes="absolute top-2 right-2"
							/>
						) : null}
					</div>
				</a>
			) : (
				<div
					className="bg-[rgb(106,95,142)]/10 w-72 h-32 flex flex-row items-center p-4 gap-3 rounded-lg select-none
                    backdrop-blur-sm hover:backdrop-blur-3xl hover:bg-purple-300/6 transition-colors duration-200
                    inset-shadow-card inset-shadow-gray-400
                    relative"
				>
					{service.iconUrl && (
						<img
							src={service.iconUrl}
							alt={`${service.displayName} icon`}
							className="w-16 h-16 select-none"
							draggable={false}
						/>
					)}
					<h2 className="font-semibold text-xl">{service.displayName}</h2>
					{checkHealth ? (
						<HealthCheck
							serviceUrl={service.internalUrl || service.url || ""}
							classes="absolute top-2 right-2"
						/>
					) : null}
				</div>
			)}
		</>
	);
}
