using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace EcommerceApi.Models;

[Table("productos")]
public class Product
{
    [Key]
    [Column("id")]
    public int Id { get; set; }
    
    [Required]
    [Column("nombre")]
    [MaxLength(200)]
    public string Name { get; set; } = string.Empty;
    
    [Column("descripcion")]
    public string Description { get; set; } = string.Empty;
    
    [Required]
    [Column("precio", TypeName = "decimal(10,2)")]
    public decimal Price { get; set; }
    
    [Required]
    [Column("stock")]
    public int Stock { get; set; }
    
    [Required]
    [Column("categoria_id")]
    public int CategoryId { get; set; }
    
    [Column("imagen_url")]
    [MaxLength(500)]
    public string ImageUrl { get; set; } = string.Empty;
    
    [Column("disponible")]
    public bool Available { get; set; } = true;
    
    [Column("fecha_creacion")]
    public DateTime CreatedDate { get; set; } = DateTime.Now;
}

[Table("usuarios")]
public class User
{
    [Key]
    [Column("id")]
    public int Id { get; set; }
    
    [Required]
    [Column("nombre")]
    [MaxLength(100)]
    public string Name { get; set; } = string.Empty;
    
    [Required]
    [Column("email")]
    [MaxLength(150)]
    public string Email { get; set; } = string.Empty;
    
    [Required]
    [Column("password_hash")]
    [MaxLength(255)]
    public string PasswordHash { get; set; } = string.Empty;
    
    [Column("telefono")]
    [MaxLength(20)]
    public string? Phone { get; set; }
    
    [Column("direccion")]
    [MaxLength(500)]
    public string? Address { get; set; }
    
    [Column("fecha_registro")]
    public DateTime CreatedDate { get; set; } = DateTime.Now;
    
    [Column("activo")]
    public bool Active { get; set; } = true;
}

// DTOs para registro y login
public class RegisterDto
{
    public string Name { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;
    public string ConfirmPassword { get; set; } = string.Empty;
    public int CaptchaAnswer { get; set; }
}

public class LoginDto
{
    public string Email { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;
    public int CaptchaAnswer { get; set; }
}

public class CaptchaDto
{
    public string Question { get; set; } = string.Empty;
    public int CorrectAnswer { get; set; }
}