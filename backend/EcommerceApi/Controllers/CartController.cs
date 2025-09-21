using Microsoft.AspNetCore.Mvc;
using EcommerceApi.Models;

namespace EcommerceApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class CartController : ControllerBase
{
    private static readonly List<Cart> Carts = new();

    /// <summary>
    /// Obtiene el carrito del usuario
    /// </summary>
    [HttpGet("{userId}")]
    public ActionResult<Cart> GetCart(int userId)
    {
        var cart = Carts.FirstOrDefault(c => c.UserId == userId);
        if (cart == null)
        {
            cart = new Cart { Id = Carts.Count + 1, UserId = userId };
            Carts.Add(cart);
        }
        
        return Ok(cart);
    }

    /// <summary>
    /// Agrega un producto al carrito
    /// </summary>
    [HttpPost]
    public ActionResult AddToCart([FromBody] CartItem item)
    {
        var cart = Carts.FirstOrDefault(c => c.UserId == item.CartId) ?? 
                   new Cart { Id = Carts.Count + 1, UserId = item.CartId };
        
        if (!Carts.Contains(cart))
            Carts.Add(cart);

        var existingItem = cart.Items.FirstOrDefault(i => i.ProductId == item.ProductId);
        if (existingItem != null)
        {
            existingItem.Quantity += item.Quantity;
        }
        else
        {
            item.Id = cart.Items.Count + 1;
            cart.Items.Add(item);
        }

        return Ok(cart);
    }
}