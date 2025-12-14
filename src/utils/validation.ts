import type { Config } from "../types/config";

export function hasDuplicateServiceIds(config: Config): boolean {
	const seenIds = new Set<string>();
	for (const service of config.services) {
		const currentId = service.id;
		if (seenIds.has(currentId)) {
			return true;
		}
		seenIds.add(currentId);
	}
	return false;
}
