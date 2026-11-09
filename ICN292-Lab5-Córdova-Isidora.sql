CREATE DATABASE IF NOT EXISTS andesbike;

USE andesbike;
USE andesbike;

CREATE TABLE tiendas (
    id_tienda INT NOT NULL,
    nombre VARCHAR(60) NOT NULL,
    comuna VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_tienda)
);

CREATE TABLE bicicletas (
    id_bicicleta INT NOT NULL,
    modelo VARCHAR(60) NOT NULL,
    categoria ENUM(
        'Eléctrica',
        'Infantil',
        'Montaña',
        'Ruta',
        'Urbana'
    ) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_bicicleta)
);

CREATE TABLE vendedores (
    id_vendedor INT NOT NULL,
    nombre VARCHAR(80) NOT NULL,
    id_tienda INT NULL,
    fecha_ingreso DATE NOT NULL,
    PRIMARY KEY (id_vendedor),
    FOREIGN KEY (id_tienda)
        REFERENCES tiendas(id_tienda)
);

-- 4. Tabla ventas
CREATE TABLE ventas (
    id_venta INT NOT NULL,
    id_vendedor INT NOT NULL,
    id_bicicleta INT NOT NULL,
    fecha DATE NOT NULL,
    unidades INT NOT NULL,
    PRIMARY KEY (id_venta),
    FOREIGN KEY (id_vendedor)
        REFERENCES vendedores(id_vendedor),
    FOREIGN KEY (id_bicicleta)
        REFERENCES bicicletas(id_bicicleta)
);

USE andesbike;

INSERT INTO tiendas (id_tienda, nombre, comuna) VALUES
(1, 'Andes Providencia', 'Providencia'),
(2, 'Andes Maipú', 'Maipú'),
(3, 'Andes Concepción', 'Concepción'),
(4, 'Andes La Serena', 'La Serena');

INSERT INTO bicicletas (id_bicicleta, modelo, categoria, precio) VALUES
(1, 'Cordillera 29', 'Montaña', 549990.00),
(2, 'Ruta Austral', 'Ruta', 899990.00),
(3, 'Urbana Pro', 'Urbana', 329990.00),
(4, 'Pequeño Andes', 'Infantil', 149990.00),
(5, 'Volt City', 'Eléctrica', 1249990.00),
(6, 'Trail Master', 'Montaña', 749990.00),
(7, 'Urbana Lite', 'Urbana', 229990.00),
(8, 'Sprint R7', 'Ruta', 1099990.00);

INSERT INTO vendedores
(id_vendedor, nombre, id_tienda, fecha_ingreso) VALUES
(1, 'Camila Ortiz', 1, '2024-06-20'),
(2, 'Diego Fuentes', 1, '2024-01-15'),
(3, 'Javiera Soto', 2, '2023-07-24'),
(4, 'Matías Herrera', 2, '2024-01-15'),
(5, 'Paula Riquelme', 3, '2022-11-02'),
(6, 'Ignacio Vera', 3, '2024-08-19'),
(7, 'Fernanda Lillo', 1, '2025-02-03'),
(8, 'Rubén Castro', NULL, '2025-06-10');

INSERT INTO ventas
(id_venta, id_vendedor, id_bicicleta, fecha, unidades) VALUES
(1, 1, 1, '2025-03-04', 2),
(2, 1, 3, '2025-03-18', 1),
(3, 1, 5, '2025-04-02', 1),
(4, 2, 2, '2025-03-04', 1),
(5, 2, 1, '2025-04-11', 3),
(6, 2, 7, '2025-05-06', 2),
(7, 3, 4, '2025-03-21', 4),
(8, 3, 3, '2025-04-15', 2),
(9, 3, 6, '2025-05-20', 1),
(10, 4, 1, '2025-03-27', 1),
(11, 4, 5, '2025-05-09', 2),
(12, 5, 2, '2025-04-08', 1),
(13, 5, 6, '2025-04-23', 2),
(14, 5, 4, '2025-06-02', 5),
(15, 6, 3, '2025-05-13', 3),
(16, 6, 7, '2025-06-17', 1),
(17, 6, 1, '2025-06-24', 2),
(18, 1, 6, '2025-06-30', 1);

SELECT COUNT(*) AS total_tiendas
FROM tiendas;

SELECT COUNT(*) AS total_vendedores
FROM vendedores;

SELECT COUNT(*) AS total_bicicletas
FROM bicicletas;

SELECT COUNT(*) AS total_ventas,
       SUM(unidades) AS total_unidades
FROM ventas;

SELECT SUM(v.unidades * b.precio) AS monto_total
FROM ventas v
JOIN bicicletas b
ON v.id_bicicleta = b.id_bicicleta;

-- CONSULTA 1
SELECT
    ve.nombre,
    COUNT(v.id_venta) AS cantidad_ventas
FROM vendedores ve
LEFT JOIN ventas v
    ON ve.id_vendedor = v.id_vendedor
GROUP BY ve.id_vendedor, ve.nombre
ORDER BY cantidad_ventas DESC, ve.nombre ASC;

SELECT
    t.nombre,
    COUNT(v.id_venta) AS cantidad_ventas,
    COALESCE(SUM(v.unidades), 0) AS unidades_vendidas
FROM tiendas t
LEFT JOIN vendedores ve
    ON t.id_tienda = ve.id_tienda
LEFT JOIN ventas v
    ON ve.id_vendedor = v.id_vendedor
GROUP BY t.id_tienda, t.nombre
ORDER BY unidades_vendidas DESC;

SELECT
    t.nombre
FROM tiendas t
LEFT JOIN vendedores ve
    ON t.id_tienda = ve.id_tienda
WHERE ve.id_vendedor IS NULL;

SELECT
    b.modelo
FROM bicicletas b
LEFT JOIN ventas v
    ON b.id_bicicleta = v.id_bicicleta
    AND v.fecha >= '2025-06-01'
    AND v.fecha < '2025-07-01'
WHERE v.id_venta IS NULL
ORDER BY b.modelo;

SELECT
    ve.nombre AS vendedor,
    COALESCE(t.nombre, 'Sin tienda asignada') AS tienda
FROM vendedores ve
LEFT JOIN tiendas t
    ON ve.id_tienda = t.id_tienda
LEFT JOIN ventas v
    ON ve.id_vendedor = v.id_vendedor
WHERE v.id_venta IS NULL
ORDER BY ve.nombre ASC;

SELECT
    v1.nombre AS vendedor_1,
    v1.fecha_ingreso AS fecha_ingreso_1,
    v2.nombre AS vendedor_2,
    v2.fecha_ingreso AS fecha_ingreso_2,
    t.nombre AS tienda
FROM vendedores v1
JOIN vendedores v2
    ON v1.id_tienda = v2.id_tienda
    AND v1.fecha_ingreso < v2.fecha_ingreso
JOIN tiendas t
    ON v1.id_tienda = t.id_tienda
ORDER BY t.nombre, v1.fecha_ingreso;

SELECT
    t.nombre AS tienda,
    SUM(v.unidades * b.precio) AS monto_total
FROM tiendas t
JOIN vendedores ve
    ON t.id_tienda = ve.id_tienda
JOIN ventas v
    ON ve.id_vendedor = v.id_vendedor
JOIN bicicletas b
    ON v.id_bicicleta = b.id_bicicleta
WHERE b.categoria IN ('Montaña', 'Ruta')
GROUP BY t.id_tienda, t.nombre
HAVING SUM(v.unidades * b.precio) > 2000000
ORDER BY monto_total DESC;

SELECT
    modelo,
    precio
FROM bicicletas
WHERE precio > (
    SELECT AVG(precio)
    FROM bicicletas
)
ORDER BY precio DESC;

SELECT
    ve.nombre,
    AVG(v.unidades) AS promedio_unidades
FROM vendedores ve
JOIN ventas v
    ON ve.id_vendedor = v.id_vendedor
GROUP BY ve.id_vendedor, ve.nombre
HAVING AVG(v.unidades) > (
    SELECT AVG(unidades)
    FROM ventas
)
ORDER BY promedio_unidades DESC, ve.nombre ASC;

SELECT ve.nombre AS vendedor,
       SUM(v.unidades * b.precio) AS monto_total
FROM vendedores ve
LEFT JOIN ventas v
    ON ve.id_vendedor = v.id_vendedor
LEFT JOIN bicicletas b
    ON v.id_bicicleta = b.id_bicicleta
GROUP BY ve.id_vendedor, ve.nombre
ORDER BY monto_total DESC, ve.nombre ASC;