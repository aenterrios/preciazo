CREATE INDEX IF NOT EXISTS "idx_precios_id_producto_id_dataset" ON "precios" USING btree ("id_producto","id_dataset");