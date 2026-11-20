using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;

namespace OnlineShop.Infrastructure.Persistence;

public class LucaCatalogInitializer(AppDbContext db, IConfiguration configuration) : IDataInitializer
{
    public void InitializeData()
    {
        if (configuration["Seed:LucaCatalog"] != "true")
            return;

        using var transaction = db.Database.BeginTransaction();
        db.Database.ExecuteSqlRaw("""LOCK TABLE "ProductOffers" IN SHARE ROW EXCLUSIVE MODE""");
        if (!db.Products.IgnoreQueryFilters().Any())
            Apply("LucaCatalog.sql");
        Apply("LucaOffers.sql");
        transaction.Commit();
    }

    private void Apply(string resource)
    {
        using var stream = typeof(LucaCatalogInitializer).Assembly.GetManifestResourceStream(resource)
            ?? throw new InvalidOperationException($"Bundled seed {resource} is missing.");
        using var reader = new StreamReader(stream);
        db.Database.ExecuteSqlRaw(reader.ReadToEnd());
    }
}
