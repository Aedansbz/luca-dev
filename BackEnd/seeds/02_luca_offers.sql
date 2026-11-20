-- Demo prices in storefront tomans. Never reset an edited price or replenish sold stock.
WITH prices(slug, price) AS (
    VALUES ('luca-sage-3x',     8900000),
           ('luca-sport-35x',  10500000),
           ('luca-wood-25x',    7900000),
           ('luca-gradient',    8200000),
           ('luca-black',       8500000),
           ('luca-crystal-25x', 7500000),
           ('luca-smoke-3x',    9200000)
), shop AS (
    SELECT "Id" FROM "Users"
    WHERE "RoleId" = 1 AND "IsActive" AND NOT "IsDeleted"
    ORDER BY "Id" LIMIT 1
)
INSERT INTO "ProductOffers"
    ("ProductId", "SupplierId", "BasePrice", "Inventory", "CreatedAt", "CreatedBy", "IsActive", "IsDeleted")
SELECT p."Id", shop."Id", prices.price, 10, now(), shop."Id", true, false
FROM prices
JOIN "Products" p ON p."Slug" = prices.slug AND p."IsActive" AND NOT p."IsDeleted"
JOIN "Brands" b ON b."Id" = p."BrandId" AND b."Slug" = 'luca'
CROSS JOIN shop
WHERE NOT EXISTS (SELECT 1 FROM "ProductOffers" o WHERE o."ProductId" = p."Id");
