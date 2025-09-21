# Base de Datos E-commerce

Este directorio contiene el esquema de base de datos para la aplicación de e-commerce.

## Archivos

- **`schema.sql`**: Script completo de creación de la base de datos
- **`sample_data.sql`**: Datos de ejemplo adicionales (opcional)

## Estructura de la Base de Datos

### Tablas Principales

1. **usuarios**: Información de los usuarios registrados
2. **categorias**: Categorías de productos
3. **productos**: Catálogo de productos
4. **carritos**: Carritos de compra por usuario
5. **items_carrito**: Items individuales en cada carrito
6. **pedidos**: Pedidos realizados
7. **detalles_pedido**: Detalles de cada pedido
8. **metodos_pago**: Métodos de pago disponibles

### Características

- ✅ **Normalización**: Base de datos normalizada hasta 3FN
- ✅ **Integridad referencial**: Claves foráneas correctamente definidas
- ✅ **Índices**: Optimización para consultas frecuentes
- ✅ **Vistas**: Vistas útiles para consultas complejas
- ✅ **Procedimientos**: Stored procedures para operaciones críticas
- ✅ **Datos iniciales**: Categorías, métodos de pago y productos de ejemplo

## Conexión

La base de datos está desplegada en Azure SQL Server:

- **Servidor**: `upt-dbs-900.database.windows.net`
- **Base de datos**: `shorten`
- **Región**: Brazil South

## Uso

1. Ejecutar `schema.sql` en la base de datos Azure SQL
2. Verificar que todas las tablas, vistas y procedimientos se crearon correctamente
3. Los datos de ejemplo estarán disponibles inmediatamente

## Flujo de Operaciones

### 1. Registro de Usuario
```sql
INSERT INTO usuarios (nombre, email, password_hash, telefono, direccion) 
VALUES (?, ?, ?, ?, ?);
```

### 2. Agregar al Carrito
```sql
EXEC sp_agregar_al_carrito @usuario_id = ?, @producto_id = ?, @cantidad = ?;
```

### 3. Realizar Pedido
```sql
EXEC sp_crear_pedido_desde_carrito 
    @usuario_id = ?, 
    @direccion_envio = ?, 
    @metodo_pago_id = ?, 
    @pedido_id = ? OUTPUT;
```

## Consultas Útiles

### Productos más vendidos
```sql
SELECT TOP 10 p.nombre, SUM(dp.cantidad) as total_vendido
FROM productos p
INNER JOIN detalles_pedido dp ON p.id = dp.producto_id
GROUP BY p.id, p.nombre
ORDER BY total_vendido DESC;
```

### Pedidos por usuario
```sql
SELECT * FROM v_pedidos_completos 
WHERE usuario_email = 'cliente@demo.com'
ORDER BY fecha_pedido DESC;
```

### Stock bajo
```sql
SELECT nombre, stock FROM productos 
WHERE stock < 10 AND disponible = 1;
```