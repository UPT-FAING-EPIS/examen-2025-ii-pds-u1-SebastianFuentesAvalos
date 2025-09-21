using Microsoft.AspNetCore.Mvc;
using EcommerceApi.Models;

namespace EcommerceApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class OrdersController : ControllerBase
{
    private static readonly List<Order> Orders = new();

    /// <summary>
    /// Obtiene los pedidos de un usuario
    /// </summary>
    [HttpGet("{userId}")]
    public ActionResult<IEnumerable<Order>> GetUserOrders(int userId)
    {
        var userOrders = Orders.Where(o => o.UserId == userId).ToList();
        return Ok(userOrders);
    }

    /// <summary>
    /// Crea un nuevo pedido
    /// </summary>
    [HttpPost]
    public ActionResult<Order> CreateOrder([FromBody] Order order)
    {
        order.Id = Orders.Count + 1;
        order.OrderDate = DateTime.Now;
        order.Status = "Pending";
        
        Orders.Add(order);
        
        return CreatedAtAction(nameof(GetUserOrders), new { userId = order.UserId }, order);
    }

    /// <summary>
    /// Obtiene un pedido específico
    /// </summary>
    [HttpGet("order/{id}")]
    public ActionResult<Order> GetOrder(int id)
    {
        var order = Orders.FirstOrDefault(o => o.Id == id);
        if (order == null)
            return NotFound();
        
        return Ok(order);
    }
}