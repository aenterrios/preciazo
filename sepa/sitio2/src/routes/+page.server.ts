import { sql } from '$lib/server/db';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ setHeaders }) => {
	// https://www.cybertec-postgresql.com/en/postgresql-count-made-fast/
	const count = await sql`
  SELECT reltuples::bigint
  FROM pg_catalog.pg_class
  WHERE relname = 'precios';
  `;

	setHeaders({
		'Cache-Control': 'public, max-age=600'
	});

	return {
		count: count[0].reltuples
	};
};
