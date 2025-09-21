using Microsoft.AspNetCore.Mvc;
using EcommerceApi.Models;

namespace EcommerceApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private static readonly List<User> Users = new();

    /// <summary>
    /// Registro de usuario
    /// </summary>
    [HttpPost("register")]
    public ActionResult<User> Register([FromBody] User user)
    {
        // Verificar si el email ya existe
        if (Users.Any(u => u.Email == user.Email))
            return BadRequest("Email already exists");

        user.Id = Users.Count + 1;
        user.PasswordHash = BCrypt.Net.BCrypt.HashPassword(user.PasswordHash); // En producción usar hash real
        user.RegisterDate = DateTime.Now;
        
        Users.Add(user);
        
        // No devolver el password hash
        user.PasswordHash = "";
        
        return Ok(user);
    }

    /// <summary>
    /// Inicio de sesión
    /// </summary>
    [HttpPost("login")]
    public ActionResult Login([FromBody] LoginRequest request)
    {
        var user = Users.FirstOrDefault(u => u.Email == request.Email);
        if (user == null || !BCrypt.Net.BCrypt.Verify(request.Password, user.PasswordHash))
            return Unauthorized("Invalid credentials");

        // En producción aquí generarías un JWT token
        return Ok(new { UserId = user.Id, Name = user.Name, Email = user.Email });
    }
}

public class LoginRequest
{
    public string Email { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;
}