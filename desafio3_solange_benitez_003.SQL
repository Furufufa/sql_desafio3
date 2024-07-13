-- Active: 1720909435626@@127.0.0.1@5432@desafio3_solange_benitez_003
CREATE DATABASE desafio3_Solange_Benitez_003;
/*Creación de tablas*/

/*Tabla Usuarios*/
CREATE TABLE Usuarios (
    Id SERIAL PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    rol VARCHAR(20) CHECK (rol IN ('administrador', 'usuario'))
);

INSERT INTO Usuarios (email, nombre, apellido, rol) VALUES
('botitas.bella@gmail.com', 'Botitas', 'Speziali', 'administrador'),
('evelyn.vet1@sainte.animals.com', 'Evelyn', 'García', 'usuario'),
('doctor123@medivet.com', 'Franco', 'González', 'usuario'),
('endocrinovet@gmail.com', 'Mario', 'Dubbo', 'usuario'),
('romina.sepulveda@hotmail.com', 'Romina', 'Sepúlveda', 'usuario');

SELECT * FROM usuarios;

/*Tabla 2 Posts*/

CREATE TABLE Posts (
    Id SERIAL PRIMARY KEY,
    título VARCHAR,
    contenido TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    destacado BOOLEAN DEFAULT FALSE,
    usuario_id BIGINT REFERENCES Usuarios(Id)
);

INSERT INTO Posts (título, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) VALUES
('Salud Canina', 'Enfermedades Endocrinas', '2024-07-01 10:00:00', '2024-07-01 10:00:00', TRUE, 1),
('Enfermarse en Chile', 'Cuando la salud solo depende de la capacidad económica', '2024-07-02 11:00:00', '2024-07-02 11:00:00', FALSE, 1),
('Momento de Despedida', 'El momento en que tu egoísmo queda de lado y optas por dejar partir', '2024-07-03 12:00:00', '2024-07-03 12:00:00', FALSE, 2),
('Cremación', 'Quienes prestan este servicio y cuál es el costo', '2024-07-04 13:00:00', '2024-07-04 13:00:00', TRUE, 3),
('Cuenta Médica', 'Después del dolor, el momento de pagar la cuenta', '2024-07-05 14:00:00', '2024-07-05 14:00:00', TRUE, NULL);

SELECT * FROM Posts;

/* Tabla 3 Comentarios*/
CREATE TABLE Comentarios (
    Id SERIAL PRIMARY KEY,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_id BIGINT REFERENCES Usuarios(Id),
    post_id BIGINT REFERENCES Posts(Id)
);

INSERT INTO Comentarios (contenido, fecha_creacion, usuario_id, post_id) VALUES
('No existen suficientes especialistas veterinarios para estas enfermedades', '2024-07-01 10:30:00', 1, 1),
('Los doctores pierden la vocación, solo les interesa sacar ganancias económicas a costa del dolor y desesperación de familiares', '2024-07-01 11:00:00', 2, 1),
('Es difícil, pero a veces hay que rendirse y dejar que descansen en paz', '2024-07-01 12:00:00', 3, 1),
('Uno se endeuda buscando su recuperación y finalmente se queda solo con las deudas y sin nuestros amores', '2024-07-02 12:30:00', 1, 2),
('La salud en general es un privilegio, no un derecho', '2024-07-02 13:00:00', 2, 2);

SELECT * FROM Comentarios;

/* 2) Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas: nombre y email del usuario junto al titulo y contenido del post*/
SELECT u.nombre, u.email, p.título, p.contenido
FROM Usuarios u
JOIN Posts p ON u.Id = p.usuario_id;

/* 3) Muestra el ID, titulo y contenido de los posts de los administradores*/
SELECT p.Id, p.título, p.contenido
FROM Posts p
JOIN Usuarios u ON p.usuario_id = u.Id
WHERE u.rol = 'administrador';

/* 4) Cuenta la cantidad de posts de cada usuario*/
SELECT u.Id, u.email, COUNT(p.Id) AS cantidad_posts
FROM Usuarios u
LEFT JOIN Posts p ON u.Id = p.usuario_id
GROUP BY u.Id, u.email;

/* 5) Muestra el email del usuario que ha creado mas posts*/
SELECT u.email
FROM Usuarios u
JOIN Posts p ON u.Id = p.usuario_id
GROUP BY u.email
ORDER BY COUNT(p.Id) DESC
LIMIT 1;

/* 6) Muestra la fecha del último post de cada usuario*/
SELECT u.Id, u.email, MAX(p.fecha_creacion) AS fecha_ultimo_post
FROM Usuarios u
LEFT JOIN Posts p ON u.Id = p.usuario_id
GROUP BY u.Id, u.email;

/* 7) Muestra el título y contenido del post (artículo) con mas comentarios*/
SELECT p.título, p.contenido
FROM Posts p
JOIN Comentarios c ON p.Id = c.post_id
GROUP BY p.Id, p.título, p.contenido
ORDER BY COUNT(c.Id) DESC
LIMIT 1;

/* 8) Muestra en la tabla el título de cada post, el contenido de cada post y el contenido de cada comentario asociado a los posts mostrados, junto con el email del usuario que lo escribio*/
SELECT p.título, p.contenido AS contenido_post, c.contenido AS contenido_comentario, u.email
FROM Posts p
LEFT JOIN Comentarios c ON p.Id = c.post_id
LEFT JOIN Usuarios u ON c.usuario_id = u.Id;

/* 9) Muestra el contenido del último comentario de cada usuario*/
SELECT u.email, c.contenido
FROM Usuarios u
JOIN Comentarios c ON u.Id = c.usuario_id
WHERE c.fecha_creacion = (
    SELECT MAX(fecha_creacion)
    FROM Comentarios
    WHERE usuario_id = u.Id
);

/* 10) Muestra los emails de los usuarios que no han escrito ningún comentario*/
SELECT u.email
FROM Usuarios u
LEFT JOIN Comentarios c ON u.Id = c.usuario_id
WHERE c.Id IS NULL;

