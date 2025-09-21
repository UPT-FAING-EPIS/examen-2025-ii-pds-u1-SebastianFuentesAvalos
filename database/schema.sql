-- Script de creación de base de datos para E-commerce
-- Base de datos simple pero funcional para la aplicación

-- ============================================
-- TABLA USUARIOS
-- ============================================
CREATE TABLE usuarios (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    email NVARCHAR(150) NOT NULL UNIQUE,
    password_hash NVARCHAR(255) NOT NULL,
    telefono NVARCHAR(20),
    direccion NVARCHAR(500),
    fecha_registro DATETIME2 DEFAULT GETDATE(),
    activo BIT DEFAULT 1
);

-- ============================================
-- TABLA CATEGORIAS
-- ============================================
CREATE TABLE categorias (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(500),
    activa BIT DEFAULT 1,
    imagen_url NVARCHAR(500)
);

-- ============================================
-- TABLA PRODUCTOS
-- ============================================
CREATE TABLE productos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(200) NOT NULL,
    descripcion NTEXT,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    categoria_id INT NOT NULL,
    imagen_url NVARCHAR(500),
    disponible BIT DEFAULT 1,
    fecha_creacion DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

-- ============================================
-- TABLA CARRITOS
-- ============================================
CREATE TABLE carritos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    usuario_id INT NOT NULL,
    fecha_creacion DATETIME2 DEFAULT GETDATE(),
    fecha_actualizacion DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- ============================================
-- TABLA ITEMS_CARRITO
-- ============================================
CREATE TABLE items_carrito (
    id INT IDENTITY(1,1) PRIMARY KEY,
    carrito_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10,2) NOT NULL,
    fecha_agregado DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (carrito_id) REFERENCES carritos(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

-- ============================================
-- TABLA METODOS_PAGO
-- ============================================
CREATE TABLE metodos_pago (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(50) NOT NULL,
    tipo NVARCHAR(30) NOT NULL, -- 'tarjeta', 'transferencia', 'efectivo'
    activo BIT DEFAULT 1
);

-- ============================================
-- TABLA PEDIDOS
-- ============================================
CREATE TABLE pedidos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    usuario_id INT NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    estado NVARCHAR(30) NOT NULL DEFAULT 'Pendiente', -- 'Pendiente', 'Confirmado', 'EnProceso', 'Enviado', 'Entregado', 'Cancelado'
    direccion_envio NVARCHAR(500) NOT NULL,
    metodo_pago_id INT NOT NULL,
    fecha_pedido DATETIME2 DEFAULT GETDATE(),
    fecha_entrega DATETIME2,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (metodo_pago_id) REFERENCES metodos_pago(id)
);

-- ============================================
-- TABLA DETALLES_PEDIDO
-- ============================================
CREATE TABLE detalles_pedido (
    id INT IDENTITY(1,1) PRIMARY KEY,
    pedido_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal AS (cantidad * precio_unitario) PERSISTED,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

-- ============================================
-- ÍNDICES PARA OPTIMIZAR CONSULTAS
-- ============================================
CREATE INDEX IX_productos_categoria ON productos(categoria_id);
CREATE INDEX IX_items_carrito_carrito ON items_carrito(carrito_id);
CREATE INDEX IX_items_carrito_producto ON items_carrito(producto_id);
CREATE INDEX IX_pedidos_usuario ON pedidos(usuario_id);
CREATE INDEX IX_pedidos_fecha ON pedidos(fecha_pedido);
CREATE INDEX IX_detalles_pedido_pedido ON detalles_pedido(pedido_id);
CREATE INDEX IX_detalles_pedido_producto ON detalles_pedido(producto_id);

-- ============================================
-- DATOS INICIALES
-- ============================================

-- Métodos de pago
INSERT INTO metodos_pago (nombre, tipo) VALUES 
('Tarjeta de Crédito', 'tarjeta'),
('Tarjeta de Débito', 'tarjeta'),
('Transferencia Bancaria', 'transferencia'),
('Efectivo contra entrega', 'efectivo');

-- Categorías iniciales
INSERT INTO categorias (nombre, descripcion, imagen_url) VALUES 
('Electrónicos', 'Dispositivos electrónicos y tecnología', 'https://via.placeholder.com/300x200?text=Electronicos'),
('Ropa', 'Vestimenta para hombres y mujeres', 'https://via.placeholder.com/300x200?text=Ropa'),
('Hogar', 'Artículos para el hogar y decoración', 'https://via.placeholder.com/300x200?text=Hogar'),
('Deportes', 'Equipamiento y ropa deportiva', 'https://via.placeholder.com/300x200?text=Deportes'),
('Libros', 'Libros físicos y digitales', 'https://via.placeholder.com/300x200?text=Libros');

-- Productos de ejemplo
INSERT INTO productos (nombre, descripcion, precio, stock, categoria_id, imagen_url) VALUES 
-- Electrónicos
('Smartphone Samsung Galaxy', 'Teléfono inteligente con cámara de 64MP', 699.99, 50, 1, 'https://via.placeholder.com/300x300?text=Samsung'),
('Laptop HP Pavilion', 'Laptop para uso profesional y gaming', 1299.99, 25, 1, 'https://via.placeholder.com/300x300?text=Laptop'),
('Auriculares Sony', 'Auriculares inalámbricos con cancelación de ruido', 199.99, 100, 1, 'https://via.placeholder.com/300x300?text=Auriculares'),

-- Ropa
('Camiseta Nike', 'Camiseta deportiva 100% algodón', 29.99, 200, 2, 'https://via.placeholder.com/300x300?text=Camiseta'),
('Jeans Levis 501', 'Pantalón clásico de mezclilla', 89.99, 150, 2, 'https://via.placeholder.com/300x300?text=Jeans'),
('Chaqueta Adidas', 'Chaqueta deportiva impermeable', 79.99, 75, 2, 'https://via.placeholder.com/300x300?text=Chaqueta'),

-- Hogar
('Sofá 3 plazas', 'Sofá cómodo para sala de estar', 899.99, 10, 3, 'https://via.placeholder.com/300x300?text=Sofa'),
('Mesa de comedor', 'Mesa de madera para 6 personas', 599.99, 15, 3, 'https://via.placeholder.com/300x300?text=Mesa'),
('Lámpara LED', 'Lámpara de escritorio con control táctil', 49.99, 80, 3, 'https://via.placeholder.com/300x300?text=Lampara'),

-- Deportes
('Pelota de fútbol', 'Pelota oficial FIFA', 39.99, 120, 4, 'https://via.placeholder.com/300x300?text=Pelota'),
('Raqueta de tenis', 'Raqueta profesional de carbono', 199.99, 30, 4, 'https://via.placeholder.com/300x300?text=Raqueta'),
('Bicicleta montaña', 'Bicicleta todo terreno 21 velocidades', 799.99, 8, 4, 'https://via.placeholder.com/300x300?text=Bicicleta'),

-- Libros
('El Quijote', 'Clásico de la literatura española', 19.99, 50, 5, 'https://via.placeholder.com/300x300?text=Quijote'),
('Cien años de soledad', 'Obra maestra de García Márquez', 24.99, 40, 5, 'https://via.placeholder.com/300x300?text=Soledad'),
('Curso de programación', 'Aprende a programar desde cero', 45.99, 60, 5, 'https://via.placeholder.com/300x300?text=Programacion');

-- Usuario de prueba (password: 'admin123' hasheado)
INSERT INTO usuarios (nombre, email, password_hash, telefono, direccion) VALUES 
('Administrador', 'admin@ecommerce.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeU/nQ9Q9Q9Q9Q9Q9Q', '+51 999 888 777', 'Av. Principal 123, Lima, Perú'),
('Cliente Demo', 'cliente@demo.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeU/nQ9Q9Q9Q9Q9Q9Q', '+51 888 777 666', 'Jr. Secundario 456, Arequipa, Perú');

-- ============================================
-- VISTAS ÚTILES
-- ============================================

-- Vista de productos con información de categoría
CREATE VIEW v_productos_completos AS
SELECT 
    p.id,
    p.nombre,
    p.descripcion,
    p.precio,
    p.stock,
    p.imagen_url,
    p.disponible,
    p.fecha_creacion,
    c.nombre AS categoria_nombre,
    c.descripcion AS categoria_descripcion
FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.id;

-- Vista de pedidos con información del usuario
CREATE VIEW v_pedidos_completos AS
SELECT 
    p.id,
    p.total,
    p.estado,
    p.direccion_envio,
    p.fecha_pedido,
    p.fecha_entrega,
    u.nombre AS usuario_nombre,
    u.email AS usuario_email,
    mp.nombre AS metodo_pago_nombre
FROM pedidos p
INNER JOIN usuarios u ON p.usuario_id = u.id
INNER JOIN metodos_pago mp ON p.metodo_pago_id = mp.id;

-- ============================================
-- PROCEDIMIENTOS ALMACENADOS
-- ============================================

-- Procedimiento para agregar producto al carrito
CREATE PROCEDURE sp_agregar_al_carrito
    @usuario_id INT,
    @producto_id INT,
    @cantidad INT
AS
BEGIN
    DECLARE @carrito_id INT;
    DECLARE @precio_unitario DECIMAL(10,2);
    
    -- Obtener precio del producto
    SELECT @precio_unitario = precio FROM productos WHERE id = @producto_id;
    
    -- Buscar carrito existente para el usuario
    SELECT @carrito_id = id FROM carritos WHERE usuario_id = @usuario_id;
    
    -- Si no existe carrito, crear uno
    IF @carrito_id IS NULL
    BEGIN
        INSERT INTO carritos (usuario_id) VALUES (@usuario_id);
        SET @carrito_id = SCOPE_IDENTITY();
    END
    
    -- Verificar si el producto ya está en el carrito
    IF EXISTS (SELECT 1 FROM items_carrito WHERE carrito_id = @carrito_id AND producto_id = @producto_id)
    BEGIN
        -- Actualizar cantidad
        UPDATE items_carrito 
        SET cantidad = cantidad + @cantidad,
            precio_unitario = @precio_unitario
        WHERE carrito_id = @carrito_id AND producto_id = @producto_id;
    END
    ELSE
    BEGIN
        -- Agregar nuevo item
        INSERT INTO items_carrito (carrito_id, producto_id, cantidad, precio_unitario)
        VALUES (@carrito_id, @producto_id, @cantidad, @precio_unitario);
    END
    
    -- Actualizar fecha de actualización del carrito
    UPDATE carritos SET fecha_actualizacion = GETDATE() WHERE id = @carrito_id;
END;

-- Procedimiento para crear pedido desde carrito
CREATE PROCEDURE sp_crear_pedido_desde_carrito
    @usuario_id INT,
    @direccion_envio NVARCHAR(500),
    @metodo_pago_id INT,
    @pedido_id INT OUTPUT
AS
BEGIN
    DECLARE @carrito_id INT;
    DECLARE @total DECIMAL(10,2);
    
    -- Obtener carrito del usuario
    SELECT @carrito_id = id FROM carritos WHERE usuario_id = @usuario_id;
    
    IF @carrito_id IS NULL
    BEGIN
        RAISERROR('No existe carrito para el usuario', 16, 1);
        RETURN;
    END
    
    -- Calcular total
    SELECT @total = SUM(cantidad * precio_unitario) 
    FROM items_carrito 
    WHERE carrito_id = @carrito_id;
    
    -- Crear pedido
    INSERT INTO pedidos (usuario_id, total, direccion_envio, metodo_pago_id)
    VALUES (@usuario_id, @total, @direccion_envio, @metodo_pago_id);
    
    SET @pedido_id = SCOPE_IDENTITY();
    
    -- Transferir items del carrito al pedido
    INSERT INTO detalles_pedido (pedido_id, producto_id, cantidad, precio_unitario)
    SELECT @pedido_id, producto_id, cantidad, precio_unitario
    FROM items_carrito
    WHERE carrito_id = @carrito_id;
    
    -- Reducir stock de productos
    UPDATE p
    SET stock = stock - ic.cantidad
    FROM productos p
    INNER JOIN items_carrito ic ON p.id = ic.producto_id
    WHERE ic.carrito_id = @carrito_id;
    
    -- Limpiar carrito
    DELETE FROM items_carrito WHERE carrito_id = @carrito_id;
    DELETE FROM carritos WHERE id = @carrito_id;
END;