# Diagrama de Clases - Aplicación E-commerce

Este diagrama muestra la estructura de clases para la aplicación de e-commerce, incluyendo las entidades principales y sus relaciones.

## Diagrama de Base de Datos (Modelo Relacional)

```mermaid
erDiagram
    USUARIOS {
        int id PK
        string nombre
        string email UK
        string password_hash
        string telefono
        string direccion
        datetime fecha_registro
        boolean activo
    }

    CATEGORIAS {
        int id PK
        string nombre
        string descripcion
        boolean activa
        string imagen_url
    }

    PRODUCTOS {
        int id PK
        string nombre
        text descripcion
        decimal precio
        int stock
        int categoria_id FK
        string imagen_url
        boolean disponible
        datetime fecha_creacion
    }

    CARRITOS {
        int id PK
        int usuario_id FK
        datetime fecha_creacion
        datetime fecha_actualizacion
    }

    ITEMS_CARRITO {
        int id PK
        int carrito_id FK
        int producto_id FK
        int cantidad
        decimal precio_unitario
        datetime fecha_agregado
    }

    PEDIDOS {
        int id PK
        int usuario_id FK
        decimal total
        string estado
        string direccion_envio
        string metodo_pago
        datetime fecha_pedido
        datetime fecha_entrega
    }

    DETALLES_PEDIDO {
        int id PK
        int pedido_id FK
        int producto_id FK
        int cantidad
        decimal precio_unitario
        decimal subtotal
    }

    METODOS_PAGO {
        int id PK
        string nombre
        string tipo
        boolean activo
    }

    %% Relaciones
    USUARIOS ||--o{ CARRITOS : "tiene"
    USUARIOS ||--o{ PEDIDOS : "realiza"
    
    CATEGORIAS ||--o{ PRODUCTOS : "categoriza"
    
    CARRITOS ||--o{ ITEMS_CARRITO : "contiene"
    PRODUCTOS ||--o{ ITEMS_CARRITO : "incluido_en"
    
    PEDIDOS ||--o{ DETALLES_PEDIDO : "contiene"
    PRODUCTOS ||--o{ DETALLES_PEDIDO : "incluido_en"
    
    METODOS_PAGO ||--o{ PEDIDOS : "procesa"
```

## Flujo de Operaciones Principales

### 1. Registro y Autenticación
```mermaid
sequenceDiagram
    participant U as Usuario
    participant S as Sistema
    participant DB as Base de Datos

    U->>S: registrar(datos)
    S->>DB: validar email único
    DB-->>S: confirmación
    S->>DB: guardar usuario
    DB-->>S: usuario creado
    S-->>U: confirmación registro

    Note over U,DB: Proceso de Login
    U->>S: autenticar(email, password)
    S->>DB: verificar credenciales
    DB-->>S: datos usuario
    S-->>U: token/sesión
```

### 2. Compra de Productos
```mermaid
sequenceDiagram
    participant U as Usuario
    participant C as Carrito
    participant P as Producto
    participant Pe as Pedido
    participant DB as Base de Datos

    U->>C: agregar producto
    C->>P: verificar disponibilidad
    P-->>C: stock disponible
    C->>DB: guardar item carrito
    
    U->>C: proceder checkout
    C->>Pe: crear pedido
    Pe->>P: reducir stock
    Pe->>DB: guardar pedido
    DB-->>U: confirmación compra
```

## Patrones de Diseño Aplicados

### 1. Repository Pattern
- **ProductoRepository**: Manejo de datos de productos
- **UsuarioRepository**: Gestión de usuarios
- **PedidoRepository**: Operaciones de pedidos

### 2. Factory Pattern
- **PedidoFactory**: Creación de diferentes tipos de pedidos
- **MetodoPagoFactory**: Instanciación de métodos de pago

### 3. Observer Pattern
- **NotificacionPedido**: Notificaciones de estado de pedidos
- **InventarioObserver**: Alertas de stock bajo

## Principios SOLID Aplicados

✅ **Single Responsibility**: Cada clase tiene una responsabilidad específica  
✅ **Open/Closed**: Extensible para nuevos métodos de pago y tipos de productos  
✅ **Liskov Substitution**: Interfaces claras para diferentes implementaciones  
✅ **Interface Segregation**: Interfaces específicas por funcionalidad  
✅ **Dependency Inversion**: Dependencias a través de abstracciones  

---
*Generado automáticamente el $(date)*

## Estructura de la API (Arquitectura de Capas)

```mermaid
graph TB
    subgraph "Frontend Layer"
        VUE["Vue.js Components"]
        ROUTER["Vue Router"]
        STORE["Vuex/Pinia Store"]
    end

    subgraph "API Layer"
        AUTH["Auth Controller"]
        PROD["Product Controller"]
        CART["Cart Controller"]
        ORDER["Order Controller"]
        USER["User Controller"]
    end

    subgraph "Business Logic Layer"
        AUTH_SVC["Auth Service"]
        PROD_SVC["Product Service"]
        CART_SVC["Cart Service"]
        ORDER_SVC["Order Service"]
        PAY_SVC["Payment Service"]
    end

    subgraph "Data Access Layer"
        USER_REPO["User Repository"]
        PROD_REPO["Product Repository"]
        ORDER_REPO["Order Repository"]
        CART_REPO["Cart Repository"]
    end

    subgraph "Database Layer"
        AZURE_SQL["Azure SQL Database"]
    end

    %% Frontend connections
    VUE --> ROUTER
    VUE --> STORE
    STORE --> AUTH
    STORE --> PROD
    STORE --> CART
    STORE --> ORDER

    %% API to Service connections
    AUTH --> AUTH_SVC
    PROD --> PROD_SVC
    CART --> CART_SVC
    ORDER --> ORDER_SVC
    USER --> AUTH_SVC

    %% Service to Repository connections
    AUTH_SVC --> USER_REPO
    PROD_SVC --> PROD_REPO
    CART_SVC --> CART_REPO
    ORDER_SVC --> ORDER_REPO
    PAY_SVC --> ORDER_REPO

    %% Repository to Database
    USER_REPO --> AZURE_SQL
    PROD_REPO --> AZURE_SQL
    ORDER_REPO --> AZURE_SQL
    CART_REPO --> AZURE_SQL

    %% Styling
    classDef frontend fill:#e3f2fd
    classDef api fill:#f3e5f5
    classDef business fill:#e8f5e8
    classDef data fill:#fff3e0
    classDef database fill:#ffebee

    class VUE,ROUTER,STORE frontend
    class AUTH,PROD,CART,ORDER,USER api
    class AUTH_SVC,PROD_SVC,CART_SVC,ORDER_SVC,PAY_SVC business
    class USER_REPO,PROD_REPO,ORDER_REPO,CART_REPO data
    class AZURE_SQL database
```

## Estados del Pedido

```mermaid
stateDiagram-v2
    [*] --> Pendiente
    Pendiente --> Confirmado : Pago exitoso
    Pendiente --> Cancelado : Timeout/Error pago
    
    Confirmado --> EnProceso : Preparando pedido
    EnProceso --> Enviado : Despachado
    Enviado --> Entregado : Confirmación entrega
    
    Confirmado --> Cancelado : Cancelación usuario
    EnProceso --> Cancelado : Problema inventario
    
    Entregado --> [*]
    Cancelado --> [*]
    
    note right of Pendiente
        Máximo 15 minutos
        para confirmar pago
    end note
    
    note right of Enviado
        Tracking disponible
        para el usuario
    end note
```
