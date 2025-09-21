using Microsoft.AspNetCore.Mvc;
using EcommerceApi.Models;

namespace EcommerceApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ProductsController : ControllerBase
{
    // Datos de ejemplo - en producción vendría de la base de datos
    private static readonly List<Product> Products = new()
    {
        new Product { Id = 1, Name = "Smartphone Samsung", Description = "Teléfono inteligente", Price = 699.99m, Stock = 50, CategoryId = 1, ImageUrl = "https://via.placeholder.com/300" },
        new Product { Id = 2, Name = "Laptop HP", Description = "Laptop para profesionales", Price = 1299.99m, Stock = 25, CategoryId = 1, ImageUrl = "https://via.placeholder.com/300" },
        new Product { Id = 3, Name = "Camiseta Nike", Description = "Camiseta deportiva", Price = 29.99m, Stock = 200, CategoryId = 2, ImageUrl = "https://via.placeholder.com/300" }
    };

    /// <summary>
    /// Obtiene todos los productos
    /// </summary>
    [HttpGet]
    public ActionResult<IEnumerable<Product>> GetProducts()
    {
        return Ok(Products);
    }

    /// <summary>
    /// Obtiene un producto por ID
    /// </summary>
    [HttpGet("{id}")]
    public ActionResult<Product> GetProduct(int id)
    {
        var product = Products.FirstOrDefault(p => p.Id == id);
        if (product == null)
            return NotFound();
        
        return Ok(product);
    }

    /// <summary>
    /// Crea un nuevo producto
    /// </summary>
    [HttpPost]
    public ActionResult<Product> CreateProduct(Product product)
    {
        product.Id = Products.Max(p => p.Id) + 1;
        Products.Add(product);
        
        return CreatedAtAction(nameof(GetProduct), new { id = product.Id }, product);
    }
}