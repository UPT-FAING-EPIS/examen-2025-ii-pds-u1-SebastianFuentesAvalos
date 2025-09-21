using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using EcommerceApi.Models;
using EcommerceApi.Data;

namespace EcommerceApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ProductsController : ControllerBase
{
    private readonly EcommerceDbContext _context;
    private readonly ILogger<ProductsController> _logger;

    public ProductsController(EcommerceDbContext context, ILogger<ProductsController> logger)
    {
        _context = context;
        _logger = logger;
    }

    /// <summary>
    /// Obtiene todos los productos de la base de datos
    /// </summary>
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Product>>> GetProducts()
    {
        try
        {
            _logger.LogInformation("Obteniendo productos de la base de datos...");
            
            var products = await _context.Products
                .Where(p => p.Available == true)
                .OrderBy(p => p.Id)
                .ToListAsync();

            _logger.LogInformation($"Se encontraron {products.Count} productos");
            return Ok(products);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error al obtener productos de la base de datos");
            return StatusCode(500, "Error interno del servidor al obtener productos");
        }
    }

    /// <summary>
    /// Obtiene un producto por ID de la base de datos
    /// </summary>
    [HttpGet("{id}")]
    public async Task<ActionResult<Product>> GetProduct(int id)
    {
        try
        {
            _logger.LogInformation($"Buscando producto con ID: {id}");
            
            var product = await _context.Products
                .FirstOrDefaultAsync(p => p.Id == id && p.Available == true);

            if (product == null)
            {
                _logger.LogWarning($"Producto con ID {id} no encontrado");
                return NotFound($"Producto con ID {id} no encontrado");
            }

            _logger.LogInformation($"Producto encontrado: {product.Name}");
            return Ok(product);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error al obtener producto con ID {id}");
            return StatusCode(500, "Error interno del servidor al obtener el producto");
        }
    }

    /// <summary>
    /// Crea un nuevo producto en la base de datos
    /// </summary>
    [HttpPost]
    public async Task<ActionResult<Product>> CreateProduct(Product product)
    {
        try
        {
            _logger.LogInformation($"Creando nuevo producto: {product.Name}");
            
            _context.Products.Add(product);
            await _context.SaveChangesAsync();

            _logger.LogInformation($"Producto creado con ID: {product.Id}");
            return CreatedAtAction(nameof(GetProduct), new { id = product.Id }, product);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error al crear producto");
            return StatusCode(500, "Error interno del servidor al crear el producto");
        }
    }

    /// <summary>
    /// Actualiza un producto existente
    /// </summary>
    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateProduct(int id, Product product)
    {
        if (id != product.Id)
        {
            return BadRequest("El ID del producto no coincide");
        }

        try
        {
            _logger.LogInformation($"Actualizando producto con ID: {id}");
            
            _context.Entry(product).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            _logger.LogInformation($"Producto con ID {id} actualizado correctamente");
            return NoContent();
        }
        catch (DbUpdateConcurrencyException)
        {
            if (!await ProductExists(id))
            {
                return NotFound();
            }
            throw;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error al actualizar producto con ID {id}");
            return StatusCode(500, "Error interno del servidor al actualizar el producto");
        }
    }

    /// <summary>
    /// Elimina un producto (eliminación lógica)
    /// </summary>
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteProduct(int id)
    {
        try
        {
            _logger.LogInformation($"Eliminando producto con ID: {id}");
            
            var product = await _context.Products.FindAsync(id);
            if (product == null)
            {
                return NotFound();
            }

            // Eliminación lógica - marcar como no disponible
            product.Available = false;
            await _context.SaveChangesAsync();

            _logger.LogInformation($"Producto con ID {id} marcado como no disponible");
            return NoContent();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error al eliminar producto con ID {id}");
            return StatusCode(500, "Error interno del servidor al eliminar el producto");
        }
    }

    private async Task<bool> ProductExists(int id)
    {
        return await _context.Products.AnyAsync(e => e.Id == id);
    }
}