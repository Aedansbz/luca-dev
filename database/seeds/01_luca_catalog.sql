-- Starter catalog. Inserts only new products and attaches their galleries in the same statement.
INSERT INTO "Brands" ("Name","Slug","LogoUrl","Description","CreatedAt","IsDeleted","IsActive")
VALUES ('LUCA','luca','/logo.png','لوپ‌های دندان‌پزشکی لوکا',now(),false,true)
ON CONFLICT DO NOTHING;

INSERT INTO "Categories" ("PersianName","EnglishName","Slug","ImageUrl","CategoryPersianDesc",
    "CategoryEnglishDesc","IsShowInLanding","CreatedAt","IsDeleted","IsActive")
VALUES ('لوپ دندان‌پزشکی لوکا','LUCA dental loupes','luca-dental-loupes','/images/products/luca-3x-sage.png',
    'مجموعه عینک‌های لوپ لوکا','Explore LUCA dental loupe frames.',true,now(),false,true)
ON CONFLICT DO NOTHING;

WITH models(slug, name, photo, diagram) AS (
    VALUES
        ('luca-sage-3x','لوپ لوکا ۳× با فریم سبز','luca-3x-sage.png',NULL),
        ('luca-sport-35x','لوپ لوکا ۳٫۵× با فریم ورزشی','luca-3-5x-black.webp','luca-onex-anatomy.png'),
        ('luca-wood-25x','لوپ لوکا ۲٫۵× با دسته طرح چوب','luca-2-5x-tortoise.webp',NULL),
        ('luca-gradient','لوپ لوکا با فریم مشکی و شفاف','luca-classic-black.webp',NULL),
        ('luca-black','لوپ لوکا با فریم مشکی','luca-pro-black.webp','luca-black-frame-anatomy.png'),
        ('luca-crystal-25x','لوپ لوکا ۲٫۵× با فریم شفاف','luca-2-5x-clear.webp',NULL),
        ('luca-smoke-3x','لوپ لوکا ۳× با فریم دودی','luca-3x-clear.webp',NULL)
), inserted AS (
    INSERT INTO "Products" ("Name","Slug","Description","CategoryId","BrandId","CreatedAt","IsActive","IsDeleted")
    SELECT m.name, m.slug, m.name, c."Id", b."Id", now(), true, false
    FROM models m
    JOIN "Brands" b ON b."Slug" = 'luca' AND NOT b."IsDeleted"
    JOIN "Categories" c ON c."Slug" = 'luca-dental-loupes' AND NOT c."IsDeleted"
    ON CONFLICT DO NOTHING
    RETURNING "Id","Slug"
)
INSERT INTO "ProductImages" ("ProductId","ImageUrl","IsMain","CreatedAt","IsDeleted","IsActive")
SELECT p."Id", '/images/products/' || img.file, img.main, now(), false, true
FROM inserted p JOIN models m ON p."Slug" = m.slug
CROSS JOIN LATERAL (VALUES (m.photo,true),(m.diagram,false)) AS img(file,main)
WHERE img.file IS NOT NULL;
